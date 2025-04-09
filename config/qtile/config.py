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

import colors

colors = colors.Nord
home = os.path.expanduser('~')

mod = "mod4"
alt = "mod1"
ctl = "control"

M = [mod]
A_C = [alt, ctl]
M_A = [mod, alt]
M_C = [mod, ctl]
M_S = [mod, "shift"]
C_S = [ctl, "shift"]

myTerm = "kitty"                             # My terminal of choice
browser = "firefox"
term_sbg_exec = f"kitty -c {home}/.config/kitty/kitty_bg_solid.conf -e "
todo_file = f"{home}/Org/todo.org"
todo_edit = f"nvim {todo_file}"

def dmenu_run():
    qtile.cmd_spawn("dmenu_run -fn 'FiraCode-28' -p 'Run: '")

def open_calendar():
    qtile.cmd_spawn('kitty -e nvim -c "Calendar"') # nvim -c Calendar"')

keys = [
    ### The essentials
    Key(M,   "Return",   lazy.spawn(myTerm),                     desc='Launches My Terminal'),
    Key(M,   "Tab",      lazy.next_layout(),                     desc='Toggle through layouts'),
    Key(M_S, "Return",   lazy.spawn("dmenu_run -fn 'FiraCode-28' -p 'Run: '"),     desc='Dmenu Run Launcher'),
    Key(M,   "c",        lazy.window.kill(),                     desc='Kill active window'),
    Key(M_S, "r",        lazy.restart(),                         desc='Restart Qtile'),
    Key(M_S, "q",        lazy.shutdown(),                        desc='Shutdown Qtile'),
    Key(C_S, "e",        lazy.spawn("emacs"),                    desc='Doom Emacs'),
    Key(M_S, "c",        lazy.spawn("code --enable-proposed-api ms-toolsai.jupyter"),                    desc='vscode'),
    ### Switch focus to specific monitor (out of three)
    Key(M,   "w",        lazy.to_screen(0),                      desc='Keyboard focus to monitor 1'),
    Key(M,   "e",        lazy.to_screen(1),                      desc='Keyboard focus to monitor 2'),
    Key(M,   "z",        lazy.spawn("zathura"),                  desc='e-book viewer'),
    Key(M,   "f",        lazy.spawn(myTerm + " -e ./.config/vifm/scripts/vifmrun"), desc='file explorer'),
    Key(C_S, "l",        lazy.spawn("slock")),
    ### Switch focus of monitors
    Key(M,   "period",   lazy.next_screen(),                     desc='Move focus to next monitor'),
    Key(M,   "comma",    lazy.prev_screen(),                     desc='Move focus to prev monitor'),
    ### Treetab controls
    Key(M_C, "k",        lazy.layout.section_up(),               desc='Move up a section in treetab'),
    Key(M_C, "j",        lazy.layout.section_down(),             desc='Move down a section in treetab'),
    ### Window controls
    Key(M,   "k",        lazy.layout.up(),                     desc='Move focus down in current stack pane'),
    Key(M,   "j",        lazy.layout.down(),                       desc='Move focus up in current stack pane'),
    Key(M,   "n",        lazy.layout.normalize(),                desc='normalize window size ratios'),
    Key(M,   "m",        lazy.layout.maximize(),                 desc='toggle window between minimum and maximum sizes'),
    Key(M_S, "k",        lazy.layout.shuffle_down(),             desc='Move windows down in current stack'),
    Key(M_S, "j",        lazy.layout.shuffle_up(),               desc='Move windows up in current stack'),
    Key(M_S, "h",        lazy.layout.grow(), lazy.layout.increase_nmaster(), desc='Expand window (MonadTall), increase number in master pane (Tile)'),
    Key(M_S, "l",        lazy.layout.shrink(), lazy.layout.decrease_nmaster(), desc='Shrink window (MonadTall), decrease number in master pane (Tile)'),
    Key(M_S, "f",        lazy.window.toggle_floating(),          desc='toggle floating'),
    Key(M_S, "m",        lazy.window.toggle_fullscreen(),        desc='toggle fullscreen'),
    Key(M,   "p",        lazy.spawn(myTerm+" -e sh ./.xprofile"),             desc='xrandr for double monitors'),
    ### Stack controls
    Key(M,   "space",    lazy.layout.next(),                       desc='Switch window focus to other pane(s) of stack'),
    Key(M_S, "space",    lazy.layout.rotate(), lazy.layout.flip(), desc='Switch which side main pane occupies (XmonadTall)'),
    Key(M_C, "Return",   lazy.layout.toggle_split(),               desc='Toggle between split and unsplit sides of stack'),
    ### Dmenu scripts launched with ALT + CTRL + KEY
    Key(A_C, "e",        lazy.spawn("./.dmenu/dmenu-edit-configs.sh"),   desc='Dmenu script for editing config files'),
    Key(A_C, "m",        lazy.spawn("./.dmenu/dmenu-sysmon.sh"),         desc='Dmenu system monitor script'),
    Key(A_C, "r",        lazy.spawn("./.dmenu/dmenu-reddio.sh"),         desc='Dmenu reddio script'),
    Key(A_C, "s",        lazy.spawn("./.dmenu/dmenu-sys-settings.sh"),        desc='Dmenu surfraw script'),
    Key(A_C, "t",        lazy.spawn("./.dmenu/dmenu-trading.sh"),        desc='Dmenu trading programs script'),
    Key(A_C, "i",        lazy.spawn("./.dmenu/dmenu-scrot.sh"),          desc='Dmenu scrot script'),
    ### My applications launched with SUPER + ALT + KEY
    Key(M,   "b",        lazy.spawn(browser),                                 desc='firefox browser'),
    Key(M_A, "n",        lazy.spawn(myTerm+" -e newsboat"),                   desc='newsboat'),
    Key(M_A, "m",        lazy.spawn(myTerm+" -e sh ./scripts/toot.sh"),       desc='toot mastodon cli'),
    Key(M_A, "t",        lazy.spawn(myTerm+" -e sh ./scripts/tig-script.sh"), desc='tig'),

    Key(M_S, "w",        lazy.spawn(home + "/.local/bin/WeChatLinux_x86_64.AppImage"),         desc='wechat'),

    # ------------ Hardware Configs ------------
    # Volume
    Key([], "XF86AudioMute", lazy.spawn(home + "/.local/bin/volumecontrol mute")),
    Key([], "XF86AudioLowerVolume", lazy.spawn(home + "/.local/bin/volumecontrol down")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn(home + "/.local/bin/volumecontrol up")),
    # Brightness
    Key([], "XF86MonBrightnessDown", lazy.spawn(home + "/.local/bin/brightnesscontrol down")),
    Key([], "XF86MonBrightnessUp", lazy.spawn(home + "/.local/bin/brightnesscontrol up")),

    Key(A_C, "p", lazy.group['ps'].dropdown_toggle('process_mgr')),
    Key(A_C, "t", lazy.group['todo'].dropdown_toggle('todo_list')),
    Key(A_C, "c", lazy.group['calendar'].dropdown_toggle('calendar')),
]

groups = [
        Group("code", layout='monadtall', matches=[Match(wm_class="jetbrains-idea"), Match(wm_class="code")]),
        Group("车库", layout='monadtall', matches=[Match(wm_class="jetbrains-idea")]),
        Group("环球", layout='monadtall', matches=[Match(wm_class="firefox")]),
        Group("书房", layout='monadtall', matches=[Match(wm_class="obsidian")]),
        Group("草稿", layout='monadtall', matches=[Match(wm_class="Zathura")]),
        Group("机房", layout='monadtall', matches=[Match(wm_class="VirtualBox Manager")]),
        Group("信使", layout='monadtall', matches=[Match(wm_class="wechat")]),
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
                "margin": 8,
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
        layout.Floating()
        ]

def split_bar(fs: int=18):
    return widget.TextBox(text = '|', font = "Ubuntu Mono", foreground = colors[1], padding = 2, fontsize = fs)


def workspace_widgets(fontsize: int) -> list:
    return [
            widget.Image(
                filename = "~/.config/qtile/icons/arch.ico",
                mouse_callbacks = {'Button1': dmenu_run}
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
                format = '▓  CPU: {load_percent}%',
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
                    format = '{tag}: {temp:.0f}{unit}',
                    foreground = colors[4],
                    tag_sensor = "GPU",
                    threshold = 80,
                    foreground_alert = 'ff0000',
                    fontsize = fontsize,
                    decorations = [ underline(colors[4]) ]
                    ),
            widget.Spacer(length = 8),

            # memory
            widget.Memory(
                    foreground = colors[8],
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e htop')},
                    format = '{MemUsed: .2f}{mm}',
                    fmt = '🖥  Mem: {} used',
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
                    fmt = '🖴  Disk: {}',
                    visible_on_warn = False,
                    fontsize = fontsize,
                    decorations=[ underline(colors[5]) ],
                    ),
            widget.Spacer(length = 8),

            # volume
            widget.Volume(
                    foreground = colors[7],
                    fmt = '🕫  Vol: {}',
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
    widgets = workspace_widgets(fontsize) + layout_and_window_name(fontsize) + sysinfo_widgets(fontsize) + [
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

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

wmname = "LG3D"
