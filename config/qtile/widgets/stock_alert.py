import sqlite3
import os

class StockAlertManager:
    def __init__(self, db_file):
        """初始化数据库连接路径"""
        if db_file == '':
            self.db_file = os.path.join(os.path.expanduser('~'), '.local', 'stock.db')
        else:
            self.db_file = db_file

    def _connect(self):
        """创建数据库连接（内部方法）"""
        try:
            return sqlite3.connect(self.db_file)
        except sqlite3.Error as e:
            print(f"数据库连接失败: {e}")
            return None

    # -------------------- 查 --------------------
    def get_alert_by_stock_code(self, stock_code):
        """根据股票代码查询所有预警价格和类型（返回二元组列表）"""
        conn = self._connect()
        if conn is None:
            return []

        try:
            cur = conn.cursor()
            cur.execute("""
                SELECT alert_price, alert_type
                FROM stock_alert
                WHERE stock_code=?
            """, (stock_code,))
            return [(row[0], row[1]) for row in cur.fetchall()]
        except sqlite3.Error as e:
            print(f"查询失败: {e}")
            return []
        finally:
            conn.close()

    def get_all_alerts(self):
        """获取全部股票提醒"""
        conn = self._connect()
        if conn is None:
            return []

        try:
            cur = conn.cursor()
            cur.execute("SELECT * FROM stock_alert")
            return [self._row_to_dict(row) for row in cur.fetchall()]
        except sqlite3.Error as e:
            print(f"查询失败: {e}")
            return []
        finally:
            conn.close()

    # -------------------- 删 --------------------
    def delete_alert(self, stock_code):
        """根据股票代码删除所有相关记录"""
        conn = self._connect()
        if conn is None:
            return 0

        try:
            cur = conn.cursor()
            cur.execute("DELETE FROM stock_alert WHERE stock_code=?", (stock_code,))
            conn.commit()
            return cur.rowcount  # 返回删除的记录数
        except sqlite3.Error as e:
            print(f"删除失败: {e}")
            return 0
        finally:
            conn.close()

    # -------------------- 增/改 --------------------
    def upsert_alert(self, alert_data):
        """
        插入或更新记录（根据stock_code + alert_type唯一性）
        参数格式：
        {
            "name": "股票名称",
            "stock_code": "股票代码",
            "alert_price": 10.5,
            "alert_type": "BUY/SELL"
        }
        """
        self._validate_alert_data(alert_data)

        conn = self._connect()
        if conn is None:
            return None

        try:
            # 先查询是否存在相同 stock_code + alert_type 的记录
            cur = conn.cursor()
            cur.execute("""
                SELECT id
                FROM stock_alert
                WHERE stock_code=? AND alert_type=?
            """, (alert_data["stock_code"], alert_data["alert_type"]))
            existing = cur.fetchone()

            if existing:
                # 执行更新操作（保留原有ID）
                sql = """
                    UPDATE stock_alert
                    SET name=?, alert_price=?
                    WHERE id=?
                """
                params = (
                    alert_data["name"],
                    alert_data["alert_price"],
                    existing[0]
                )
            else:
                # 插入新记录（需要生成新ID）
                sql = """
                    INSERT INTO stock_alert
                    (name, stock_code, alert_price, alert_type)
                    VALUES (?, ?, ?, ?)
                """
                params = (
                    alert_data["name"],
                    alert_data["stock_code"],
                    alert_data["alert_price"],
                    alert_data["alert_type"]
                )

            cur.execute(sql, params)
            conn.commit()
            return cur.lastrowid
        except sqlite3.Error as e:
            print(f"操作失败: {e}")
            return None
        finally:
            conn.close()

    # -------------------- 辅助方法 --------------------
    @staticmethod
    def _row_to_dict(row):
        """将查询结果转为字典"""
        return {
            "id": row[0],
            "name": row[1],
            "stock_code": row[2],
            "alert_price": row[3],
            "alert_type": row[4]
        } if row else None

    @staticmethod
    def _validate_alert_data(data):
        """数据校验"""
        required_keys = ["name", "stock_code", "alert_price", "alert_type"]
        for key in required_keys:
            if key not in data:
                raise ValueError(f"缺少必要字段: {key}")

