#!/usr/bin/env python
# encoding: utf-8

import os
import subprocess

from libqtile import qtile
from libqtile import bar, hook, layout, widget
from libqtile.config import Group, Key, Match, Screen, Drag, Click, ScratchPad, DropDown

from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration


from libqtile.lazy import lazy
from widgets.xueqiu_stock_ticker import XueQiuStockTicker


from libqtile.log_utils import logger  # <- 用 Qtile 自带的 logger

import colors

from keybinding import bind_key
from default_apps import HOME, TERM, LAUNCHER

colors = colors.Nord

mod = "mod4"
alt = "mod1"
ctl = "control"

M = [mod]
A_C = [alt, ctl]
CR_A = [ctl, "mod5"]
M_A = [mod, alt]
M_C = [mod, ctl]
M_S = [mod, "shift"]
C_S = [ctl, "shift"]

myTerm = "kitty"                             # My terminal of choice
browser = "firefox"
term_sbg_exec = f"kitty -c {HOME}/.config/kitty/kitty_bg_solid.conf -e "
todo_file = f"{HOME}/Org/todo.org"
todo_edit = f"nvim {todo_file}"

def open_calendar():
    qtile.cmd_spawn('kitty -e nvim -c "Calendar"') # nvim -c Calendar"')

_prev_group = None
_curr_group = None

@hook.subscribe.setgroup
def save_last_group():
    global _prev_group, _curr_group
    new_group = qtile.current_group.name

    if new_group != _curr_group:
        # logger.warning(f"Switch group: {_curr_group} -> {new_group}")
        _prev_group, _curr_group = _curr_group, new_group

def go_last_group(qtile):
    global _prev_group, _curr_group
    if _prev_group and _prev_group in qtile.groups_map:
        # logger.warning(f"Go last group: {_curr_group} -> {_prev_group}")
        qtile.groups_map[_prev_group].toscreen()
    else:
        logger.warning("No previous group yet")

keys = bind_key() + [
    # 切换到上一个 group
    Key(M, "Left", lazy.screen.prev_group(), desc="Switch to previous group"),
    # 切换到下一个 group
    Key(M, "Right", lazy.screen.next_group(), desc="Switch to next group"),
    Key([ctl], "Tab", lazy.function(go_last_group), desc="Go to last group"),

    Key(A_C, "p", lazy.group['ps'].dropdown_toggle('process_mgr')),
    Key(A_C, "t", lazy.group['todo'].dropdown_toggle('todo_list')),
    #Key(M_S, "c", lazy.group['calendar'].dropdown_toggle('calendar')),
]

groups = [
        Group("code", layout='monadtall', matches=[Match(wm_class="jetbrains-idea"), Match(wm_class="code")]),
        Group("车库", layout='monadtall', matches=[Match(wm_class="jetbrains-idea")]),
        Group("环球", layout='monadtall', matches=[Match(wm_class="firefox")]),
        Group("书房", layout='monadtall', matches=[Match(wm_class="obsidian")]),
        Group("股市", layout='bsp', matches=[Match(wm_class="Zathura")]),
        Group("机房", layout='monadtall', matches=[Match(wm_class="VirtualBox Manager")]),
        Group("信使", layout='treetab', matches=[Match(wm_class="wechat")]),
        Group("阳台", layout='floating', matches=[Match(wm_class="netease-cloud-music")]),
        ]

for i, group in enumerate(groups, 1):
    keys.append(Key([mod], str(i), lazy.group[group.name].toscreen()))        # Switch to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(group.name))) # Send current window to another group

groups = groups + [
        # scratchpad
        ScratchPad("ps", [DropDown("process_mgr", term_sbg_exec + "htop", x=0.05, y=0.1, width=0.9, height = 0.8, opacity=1, on_focus_lost_hide=False)]),
        ScratchPad("todo", [DropDown("todo_list", term_sbg_exec + todo_edit, x=0.2, y=0.1, width=0.6, height = 0.6, opacity=0.9, on_focus_lost_hide=False)]),
        ScratchPad("calendar", [DropDown("calendar", term_sbg_exec + 'nvim -c "Calendar"', x=0.15, y=0.1, width=0.7, height = 0.6, opacity=0.9, on_focus_lost_hide=False)]),
        ]

layout_theme = {"border_width": 1,
                "margin": 5,
                "border_focus": "#5d6771",
                "border_normal": "#292d3e"
                }

layouts = [
        layout.MonadTall(**layout_theme),
        layout.TreeTab(
            font = "Ubuntu Bold",
            fontsize = 11,
            border_width = 0,
            bg_color = colors[0],
            active_bg = colors[8],
            active_fg = colors[2],
            inactive_bg = colors[1],
            inactive_fg = colors[0],
            padding_left = 8,
            padding_x = 8,
            padding_y = 6,
            sections = ["ONE", "TWO", "THREE"],
            section_fontsize = 10,
            section_fg = colors[7],
            section_top = 15,
            section_bottom = 15,
            level_shift = 8,
            vspace = 3,
            panel_width = 240
            ),
        layout.Matrix(columns=4, **layout_theme),
        layout.Bsp(**layout_theme),
        layout.Floating()
        ]

def split_bar(fs: int=18):
    return widget.TextBox(text = '|', font = "Ubuntu Mono", foreground = colors[1], padding = 2, fontsize = fs)

def workspace_widgets(fontsize: int) -> list:
    return [
            widget.Image(
                filename = "~/.config/qtile/icons/arch.ico",
                mouse_callbacks = {'Button1': lambda: qtile.spawn(LAUNCHER)}
                ),
            widget.GroupBox(
                fontsize = fontsize,
                margin_y = 5,
                margin_x = 10,
                padding_y = 0,
                padding_x = 1,
                borderwidth = 3,
                active = colors[8],
                inactive = colors[1],
                rounded = False,
                highlight_color = colors[2],
                highlight_method = "line",
                this_current_screen_border = colors[7],
                this_screen_border = colors [4],
                other_current_screen_border = colors[7],
                other_screen_border = colors[4],
                ),
            split_bar(fontsize)
            ]

def underline(color):
    return BorderDecoration(
            colour = color,
            border_width = [0, 0, 2, 0],
            )

def sysinfo_widgets(fontsize: int) -> list:
    return [
            # kerner version
            widget.GenPollText(
                update_interval = 300,
                func = lambda: subprocess.check_output("printf $(uname -r)", shell=True, text=True),
                foreground = colors[3],
                fmt = '❤  {}',
                fontsize = fontsize,
                decorations = [underline(colors[3])]
                ),
            widget.Spacer(length = 8),

            # battery
            widget.Battery(
                foreground = colors[7],
                format = "🔌 {percent:2.0%}",
                fontsize = fontsize,
                decorations = [underline(colors[7])]
                ),
            widget.Spacer(length = 8),

            # CPU & GPU
            widget.CPU(
                format = '💻 CPU: {load_percent}%',
                foreground = colors[4],
                fontsize = fontsize,
                decorations = [underline(colors[4])]
                ),
            widget.ThermalSensor(
                format = '{temp:.0f}{unit}',
                foreground = colors[4],
                tag_sensor = "CPU",
                threshold = 80,
                foreground_alert = 'ff0000',
                fontsize = fontsize,
                decorations = [underline(colors[4])]
                ),
            widget.Spacer(length = 8),
            widget.ThermalSensor(
                format = 'GPU: {temp:.0f}{unit}',
                foreground = colors[6],
                tag_sensor = "GPU",
                threshold = 80,
                foreground_alert = 'ff0000',
                fontsize = fontsize,
                decorations = [ underline(colors[6]) ]
                ),
            widget.Spacer(length = 8),

            # memory
            widget.Memory(
                    foreground = colors[8],
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e htop')},
                    format = '{MemUsed: .2f}{mm}',
                    fmt = 'Mem: {} used',
                    measure_mem = 'G',
                    fontsize = fontsize,
                    decorations = [underline(colors[8])]
                    ),
            widget.Spacer(length = 8),

            # disk
            widget.DF(
                    update_interval = 60,
                    foreground = colors[5],
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e df')},
                    partition = '/',
                    format = '{uf}{m} free',
                    fmt = '🖴 Disk: {}',
                    visible_on_warn = False,
                    fontsize = fontsize,
                    decorations=[ underline(colors[5]) ],
                    ),
            widget.Spacer(length = 8),

            # volume
            widget.Volume(
                    foreground = colors[7],
                    fmt = '🎧 Vol: {}',
                    fontsize = fontsize,
                    decorations = [underline(colors[7])]
                    ),
            widget.Spacer(length = 8),
            ]

def layout_and_window_name(fontsize):
    return [
            widget.CurrentLayoutIcon(
                # custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
                foreground = colors[1],
                padding = 4,
                scale = 0.6
                ),
            widget.CurrentLayout(
                foreground = colors[1],
                padding = 5,
                fontsize = fontsize
                ),
            split_bar(fontsize),
            widget.WindowName(
                foreground = colors[6],
                max_chars = 40,
                fontsize = fontsize
                ),
            ]


def laptop_screen_bar(fontsize=18):
    widgets = workspace_widgets(fontsize) + layout_and_window_name(fontsize) + sysinfo_widgets(fontsize = 14) + [
            widget.Systray(),
            widget.Spacer(length = 8),
            ]

    return widgets

# 4K monitor
def large_screen_bar(fontsize=28):
    widgets = workspace_widgets(fontsize) + layout_and_window_name(fontsize) + [
            XueQiuStockTicker(
                symbol="xx",
                show_change=True,
                show_volume=False,
                fontsize = fontsize,
                update_interval=10,
                foreground = colors[3],
                decorations = [underline(colors[3])]
            ),
            split_bar(fontsize),
            XueQiuStockTicker(
                symbol="xx",
                show_change=True,
                show_volume=False,
                fontsize = fontsize,
                update_interval=10,
                foreground = colors[4],
                decorations = [underline(colors[4])]
            ),

            widget.Spacer(length = 8),

            widget.Clock(
                foreground = colors[8],
                format = "⏱  %a, %b %d - %H:%M:%S",
                fontsize = fontsize,
                decorations=[ underline(colors[8]) ],
                ),
            ]
    return widgets

screens = [
        Screen(top=bar.Bar(widgets=laptop_screen_bar(), opacity=.8, size=30)),
        Screen(top=bar.Bar(widgets=large_screen_bar(), opacity=.7, size=40))
        ]

# Drag floating layouts.
mouse = [
    # 按住 mod 键和鼠标左键拖拽可移动窗口
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
        # 按住 mod 键（通常是 Super/Win 键）再点击鼠标左键，将浮动窗口提升到最顶层
    Click([mod], "Button1", lazy.window.bring_to_front()),
    # 按住 mod 键和鼠标右键拖拽可调整窗口大小
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
]

# from libqtile.log_utils import logger

# @lazy.function
# def switch_groups(qtile, group_name):
#     logger.info("group name: %s" % group_name)


@hook.subscribe.startup_once
def start_once():
    subprocess.call([HOME + '/.config/qtile/autostart.sh'])

wmname = "LG3D"
