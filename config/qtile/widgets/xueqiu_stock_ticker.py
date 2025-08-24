;q# Copyright (c) 2024 Your Name
# 基于雪球接口的股票组件实现

import time
import locale
import gzip
import zlib
import json
from io import BytesIO
from urllib.parse import urlencode
from json import JSONDecodeError

from libqtile.log_utils import logger
from libqtile.widget.generic_poll_text import GenPollUrl
from urllib.request import Request, urlopen
from widgets.stock_alert import StockAlertManager


class XueQiuStockTicker(GenPollUrl):
    """
    基于雪球实时行情接口的股票组件

    参数说明：
    symbol - 股票代码（例如：SZ000001）
    cookie - 雪球登录Cookie（必需）
    show_change - 是否显示涨跌幅（默认True）
    show_volume - 是否显示成交量（默认False）
    rise_color - 上涨颜色（默认#00FF00）
    fall_color - 下跌颜色（默认#FF0000）
    neutral_color - 平盘颜色（默认None，使用主题前景色）
    """

    defaults = [
        ("symbol", "SZ000001", "股票代码（交易所+代码）"),
        ("cookie", None, "雪球认证Cookie"),
        ("show_change", True, "显示涨跌幅百分比"),
        ("show_volume", False, "显示成交量"),
        ("rise_color", "#FF0000", "上涨颜色"),
        ("fall_color", "#00FF00", "下跌颜色"),
        ("neutral_color", None, "平盘颜色（默认使用主题前景色）"),
        ("alert_bg_color", "#FFFF00", "预警背景颜色"),
        ("alert_fg_color_buy", "#005f85", "买入预警前景色"),
        ("alert_fg_color_sell", "#6f116f", "卖出预警前景色"),
        ("buy_alert_color", "#90EE90", "买入预警前景色"),
        ("sell_alert_color", "#FFA07A", "卖出预警前景色"),
        ("alert_db_path", "", "预警数据库路径（空表示使用默认路径）"),
        ("headers", {
            'Accept-Encoding': 'gzip, deflate, br',
            'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
            'Referer': 'https://xueqiu.com/S/',
            'Origin': 'https://xueqiu.com'
        }, "请求头配置"),
        ("update_interval", 30, "更新频率（秒）")
    ]

    def __init__(self, **config):
        super().__init__(**config)
        self.add_defaults(XueQiuStockTicker.defaults)
        self.sign = '¥'
        self.headers['Accept-Encoding'] = 'gzip, deflate, br'
        self._current_color = None  # 当前颜色状态
        self._alert_manager = StockAlertManager(self.alert_db_path)

    @property
    def url(self):
        base_url = "https://stock.xueqiu.com/v5/stock/realtime/quotec.json"
        params = {
            "symbol": self.symbol,
            "_": int(time.time() * 1000)  # 防缓存时间戳
        }
        return f"{base_url}?{urlencode(params)}"

    def _decompress_response(self, response, body):
        """处理压缩响应"""
        encoding = response.headers.get('Content-Encoding', '').lower()

        if encoding == 'gzip':
            buf = BytesIO(body)
            with gzip.GzipFile(fileobj=buf) as f:
                return f.read()
        elif encoding == 'deflate':
            try:
                return zlib.decompress(body, -zlib.MAX_WBITS)
            except zlib.error:
                return zlib.decompress(body)
        return body

    def fetch(self):
        """重写fetch方法处理压缩"""
        try:
            req = Request(self.url, headers=self.headers)
            res = urlopen(req, timeout=10)

            if res.status != 200:
                logger.error(f"请求失败 HTTP {res.status}")
                return None

            body = res.read()
            decoded = self._decompress_response(res, body)
            return json.loads(decoded.decode('utf-8'))

        except Exception as e:
            logger.error(f"数据获取失败: {str(e)}")
            return None

    def parse(self, body):
        """解析数据并确定颜色"""
        if body['data'] is None:
            return 'N/A'
        try:
            data = body['data'][0]
            percent = data['percent']
            current = data['current']
            last_close = data['last_close']
            symbol = data['symbol']

            # 检查预警价格
            alerts = self._alert_manager.get_alert_by_stock_code(symbol)
            for price, alert_type in alerts:
                if alert_type == 'SELL' and current >= price:
                    self.background = self.sell_alert_color
                    self._current_color = self.alert_fg_color_sell
                    break
                elif alert_type == 'BUY' and current <= price:
                    self.background = self.buy_alert_color
                    self._current_color = self.alert_fg_color_buy
                    break
            else:
                # 没有触发预警时重置背景色并使用原颜色逻辑
                self.background = None
                if current > last_close:
                    self._current_color = self.rise_color
                elif current < last_close:
                    self._current_color = self.fall_color
                else:
                    self._current_color = self.neutral_color or self.foreground

            # 构建显示内容
            parts = [f"{symbol}: {self.sign}{current}"]

            if self.show_change:
                if type(percent) is not None:
                    sign = '+' if percent >=0 else ''
                    parts.append(f"{sign}{percent:.2f}%")

            if self.show_volume:
                parts.append(f"{data['volume']//100}手")

            return ' '.join(parts)

        except (KeyError, IndexError, JSONDecodeError) as e:
            logger.error(f"数据解析失败: {str(e)}")
            return "N/A"

    # def poll(self):
    #     """重写poll方法更新颜色"""
    #     result = super().poll()
    #     if self._current_color and self.qtile:
    #         # 在主线程更新颜色和背景
    #         def _update():
    #             self.foreground = self._current_color
    #             if hasattr(self, 'background'):
    #                 self.bar.draw()
    #         self.qtile.call_soon(_update)
    #     return result

    def poll(self):
        result = super().poll()
        if self._current_color and self.qtile:
            def _update():
                # 改实际渲染对象颜色
                if hasattr(self, 'layout'):
                    self.layout.colour = self._current_color
                # 如果背景色也要改
                if hasattr(self, 'background') and self.background:
                    self.layout.background = self.background
                self.bar.draw()
            self.qtile.call_soon(_update)
        return result

