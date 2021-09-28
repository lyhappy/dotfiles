# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import socket
import subprocess

from typing import List  # noqa: F401

from libqtile import qtile
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy

mod = "mod4"
alt = "mod1"
ctl = "control"
myTerm = "alacritty"                             # My terminal of choice
# myTerm = "kitty"                             # My terminal of choice

browser = "firefox"

keys = [
    ### The essentials
    Key([mod], "Return", lazy.spawn(myTerm), desc='Launches My Terminal'),
    Key([mod, "shift"], "Return", lazy.spawn("dmenu_run -p 'Run: '"), desc='Dmenu Run Launcher'),
    Key([mod], "Tab", lazy.next_layout(), desc='Toggle through layouts'),
    Key([mod, "shift"], "c", lazy.window.kill(), desc='Kill active window'),
    Key([mod, "shift"], "r", lazy.restart(), desc='Restart Qtile'),
    Key([mod, "shift"], "q", lazy.shutdown(), desc='Shutdown Qtile'),
    Key([ctl, "shift"], "e", lazy.spawn("emacs"), desc='Doom Emacs'),
    Key([mod], "s", lazy.spawn(myTerm+" -e bash ~/.stools/relay"), desc='ssh relay'),
    ### Switch focus to specific monitor (out of three)
    Key([mod], "w", lazy.to_screen(0), desc='Keyboard focus to monitor 1'),
    Key([mod], "e", lazy.to_screen(1), desc='Keyboard focus to monitor 2'),
    Key([ctl, "shift"], "l", lazy.spawn("slock")),
    Key([mod], "z", lazy.spawn("zathura"), desc='e-book viewer'),
    Key([mod], "f", lazy.spawn(myTerm + " -e ./.config/vifm/scripts/vifmrun"), desc='file explorer'),
    ### Switch focus of monitors
    Key([mod], "period", lazy.next_screen(), desc='Move focus to next monitor'),
    Key([mod], "comma", lazy.prev_screen(), desc='Move focus to prev monitor'),
    ### Treetab controls
    Key([mod, ctl], "k", lazy.layout.section_up(), desc='Move up a section in treetab'),
    Key([mod, ctl], "j", lazy.layout.section_down(), desc='Move down a section in treetab'),
    ### Window controls
    Key([mod], "k", lazy.layout.down(), desc='Move focus down in current stack pane'),
    Key([mod], "j", lazy.layout.up(), desc='Move focus up in current stack pane'),
    Key([mod, "shift"], "k", lazy.layout.shuffle_down(), desc='Move windows down in current stack'),
    Key([mod, "shift"], "j", lazy.layout.shuffle_up(), desc='Move windows up in current stack'),
    Key([mod, "shift"], "h", lazy.layout.grow(), lazy.layout.increase_nmaster(), desc='Expand window (MonadTall), increase number in master pane (Tile)'),
    Key([mod, "shift"], "l", lazy.layout.shrink(), lazy.layout.decrease_nmaster(), desc='Shrink window (MonadTall), decrease number in master pane (Tile)'),
    Key([mod], "n", lazy.layout.normalize(), desc='normalize window size ratios'),
    Key([mod], "m", lazy.layout.maximize(), desc='toggle window between minimum and maximum sizes'),
    Key([mod, "shift"], "f", lazy.window.toggle_floating(), desc='toggle floating'),
    Key([mod, "shift"], "m", lazy.window.toggle_fullscreen(), desc='toggle fullscreen'),
    ### Stack controls
    Key([mod, "shift"], "space", lazy.layout.rotate(), lazy.layout.flip(), desc='Switch which side main pane occupies (XmonadTall)'),
    Key([mod], "space", lazy.layout.next(), desc='Switch window focus to other pane(s) of stack'),
    Key([mod, ctl], "Return", lazy.layout.toggle_split(), desc='Toggle between split and unsplit sides of stack'),
    ### Dmenu scripts launched with ALT + CTRL + KEY
    Key([alt, ctl], "e", lazy.spawn("./.dmenu/dmenu-edit-configs.sh"), desc='Dmenu script for editing config files'),
    Key([alt, ctl], "m", lazy.spawn("./.dmenu/dmenu-sysmon.sh"), desc='Dmenu system monitor script'),
    Key([alt, ctl], "p", lazy.spawn("passmenu"), desc='Passmenu'),
    Key([alt, ctl], "r", lazy.spawn("./.dmenu/dmenu-reddio.sh"), desc='Dmenu reddio script'),
    Key([alt, ctl], "s", lazy.spawn("./.dmenu/dmenu-surfraw.sh"), desc='Dmenu surfraw script'),
    Key([alt, ctl], "t", lazy.spawn("./.dmenu/dmenu-trading.sh"), desc='Dmenu trading programs script'),
    Key([alt, ctl], "i", lazy.spawn("./.dmenu/dmenu-scrot.sh"), desc='Dmenu scrot script'),
    ### My applications launched with SUPER + ALT + KEY
    Key([mod], "b", lazy.spawn(browser), desc='firefox browser'),
    Key([mod, alt], "n", lazy.spawn(myTerm+" -e newsboat"), desc='newsboat'),
    Key([mod, alt], "m", lazy.spawn(myTerm+" -e sh ./scripts/toot.sh"), desc='toot mastodon cli'),
    Key([mod, alt], "t", lazy.spawn(myTerm+" -e sh ./scripts/tig-script.sh"), desc='tig'),
]

group_names = [(" 🛠  ", {'layout': 'monadtall'}),
               (" 📡 ", {'layout': 'monadtall'}),
               (" 🛰  ", {'layout': 'monadtall'}),
               (" 📚 ", {'layout': 'monadtall'}),
               (" 📝 ", {'layout': 'monadtall'}),
               (" ⛽ ", {'layout': 'monadtall'}),
               (" 👽 ", {'layout': 'monadtall'}),
               (" 🏦 ", {'layout': 'monadtall'}),
               (" 🗑  ", {'layout': 'floating'})]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

# colors = [["#292d3e", "#292d3e"],
#         ["#434758", "#434758"],
#         ["#ffffff", "#ffffff"],
#         ["#ff5555", "#ff5555"],
#         ["#2aa198", "#2aa198"],
#         ["#657b83", "#657b83"],
#         ["#268bd2", "#268bd2"]]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))        # Switch to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) # Send current window to another group

layout_theme = {"border_width": 1,
                "margin": 8,
                "border_focus": "#5d6771",
                "border_normal": "#292d3e"
                }

layouts = [
    #layout.MonadWide(**layout_theme),
    #layout.Bsp(**layout_theme),
    #layout.Stack(stacks=2, **layout_theme),
    #layout.Columns(**layout_theme),
    #layout.RatioTile(**layout_theme),
    #layout.VerticalTile(**layout_theme),
    #layout.Matrix(**layout_theme),
    #layout.Zoomy(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    layout.Tile(shift_windows=True, **layout_theme),
    layout.Stack(num_stacks=2),
    layout.TreeTab(
         font = "Ubuntu",
         fontsize = 10,
         sections = ["FIRST", "SECOND"],
         section_fontsize = 11,
         bg_color = "#839496",
         active_bg = "#90C435",
         active_fg = "#FFFFFF",
         inactive_bg = "#384323",
         inactive_fg = "#a0a0a0",
         padding_y = 5,
         section_top = 10,
         panel_width = 220
         ),
    layout.Floating(**layout_theme)
]

colors = [["#292d3e", "#292d3e"], # panel background
          ["#434758", "#434758"], # background for current screen tab
          ["#ffffff", "#ffffff"], # font color for group names
          ["#ff5555", "#ff5555"], # border line color for current tab
          ["#8d62a9", "#8d62a9"], # border line color for other tab and odd widgets
          ["#668bd7", "#668bd7"], # color for the even widgets
          ["#e1acff", "#e1acff"]] # window name



prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

widget_defaults = dict(
    font="Ubuntu Mono",
    fontsize=12,
    padding=2,
    background=colors[1]
)
extension_defaults = widget_defaults.copy()

def open_calendar():
    qtile.cmd_spawn('kitty -e nvim -c "Calendar"') # nvim -c Calendar"')

def dmenu_run():
    qtile.cmd_spawn("dmenu_run -p 'Run: '")

sep_widget = widget.TextBox(text = '✧', background = colors[0], foreground = colors[4], padding = 2, fontsize = 20)

def left_widgets():
    return [
        widget.Sep( linewidth = 0, padding = 2, foreground = colors[2], background = colors[0]),
        widget.Image( filename = "~/.config/qtile/icons/archlinux.png", mouse_callbacks = {'Button1': dmenu_run}, padding = 2, background = colors[0]),
        widget.GroupBox(
            font = "Ubuntu Bold",
            fontsize = 16,
            margin_y = 3,
            margin_x = 2,
            padding_y = 5,
            padding_x = 3,
            borderwidth = 3,
            active = colors[2],
            inactive = colors[2],
            rounded = False,
            highlight_color = colors[4],
            highlight_method = "line",
            this_current_screen_border = colors[4],
            this_screen_border = colors [5],
            other_current_screen_border = colors[0],
            other_screen_border = colors[5],
            foreground = colors[2],
            background = colors[0]
            ),
        ]

widget_clock = widget.Clock(foreground = colors[2], background = colors[0], format = " %A %Y-%m-%d %H:%M:%S ", mouse_callbacks = {'Button1': open_calendar})

def init_widgets_list1():
    widgets_list = left_widgets() + [
            widget.TaskList(background = colors[0], border = colors[0]),

            widget.Net(
                    interface = "enp0s3",
                    fmt="{:>20}",
                    format = '{down} ↓↑ {up}',
                    foreground = colors[2],
                    background = colors[0],
                    mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn("stacer")},
                    padding = 0
                    ),
            sep_widget,
            widget.CPU(background = colors[0], max_chars=15),
            sep_widget,
            widget.Memory(foreground = colors[2], background = colors[0], mouse_callbacks = {'Button1': lambda : qtile.cmd_spawn('kitty -e htop')}, padding = 5),
            sep_widget,
            widget.TextBox(text = " Vol:", foreground = colors[2], background = colors[0], padding = 0),
            widget.Volume(foreground = colors[2], background = colors[0], padding = 5),
            sep_widget,
            widget.CurrentLayoutIcon(
                    custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
                    foreground = colors[0],
                    background = colors[0],
                    padding = 0,
                    scale = -1.7
                    ),
            widget.CurrentLayout(foreground = colors[2], background = colors[0], padding = 2),
            sep_widget,
            widget_clock,
            widget.Sep(linewidth = 0, padding = 10, foreground = colors[0], background = colors[0]),
            widget.Systray(background = colors[0], padding = 0),
            ]
    return widgets_list

def widget_us_stock_info(stock, symbol):
    return widget.GenPollUrl(background = colors[5], foreground=colors[2], padding=5,
            fmt=symbol+': $ {0}', url='http://hq.sinajs.cn/list=' + stock, json=False, parse=lambda r: r.split(',')[1], update_interval=30)

def widget_a_stock_info(stock, symbol):
    return widget.GenPollUrl(background = colors[4], foreground=colors[2], padding=5,
            fmt=symbol+': ¥ {0}', url='http://hq.sinajs.cn/list=' + stock, json=False, parse=lambda r: r.split(',')[3], update_interval=30)

# stock_sep = widget.Sep(linewidth = 0, padding = 5, foreground = colors[1], background = colors[0])

def init_widgets_list2():
    return left_widgets() + [
            widget.TaskList(background = colors[0], border = colors[0]),
            widget_a_stock_info('sh000001', 'SZ'),
            # widget_us_stock_info('gb_didi', 'DD'),
            # widget_us_stock_info('gb_tal', 'HWL'),
            # widget_a_stock_info('sz300013', 'XN'),
            # widget_a_stock_info('sz002673', 'XB'),
            # widget_a_stock_info('sz002385', 'DBN'),
            widget_a_stock_info('sh601179', 'XD'),
            # widget_us_stock_info('gb_edu', 'XDF'),
            # widget_a_stock_info('sh600198', 'DT'),
            widget_a_stock_info('sz000516', 'GJYX'),
            # widget_us_stock_info('gb_bidu', 'BD'),
            widget_a_stock_info('sh600258', 'SL'),
            widget_clock,
            ]

def init_widgets_screen1():
    return init_widgets_list1()                 # Slicing removes unwanted widgets on Monitors 1,3

def init_widgets_screen2():
    return init_widgets_list2()                 # Monitor 2 will display all widgets in widgets_list

screens = [
        Screen(top=bar.Bar(widgets=init_widgets_screen2(), opacity=0.6, size=20)),
        Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=0.6, size=20))]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"



