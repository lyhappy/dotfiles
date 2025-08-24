# encoding: utf-8

import os
from libqtile.config import Key
from libqtile.lazy import lazy

from default_apps import TERM, BROWSER, HOME

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

M_Key = lambda key, cmd, desc: Key(M, key, cmd, desc)

def focus():
    return [
            # 多个窗口切换聚焦，方向类似vim，h和l仅在matrix布局中好使
            M_Key("h", lazy.layout.left(),  desc="focus on left"),
            M_Key("k", lazy.layout.up(),    desc="focus on up"),
            M_Key("j", lazy.layout.down(),  desc="focus on down"),
            M_Key("l", lazy.layout.right(), desc="focus on right"),

            # screen focus 多显示器时，显示器聚焦切换
            ### Switch focus to specific monitor (out of three)
            M_Key("w",        lazy.to_screen(0),    desc='Keyboard focus to monitor 1'),
            M_Key("e",        lazy.to_screen(1),    desc='Keyboard focus to monitor 2'),

            ### Switch focus of monitors
            M_Key("period",   lazy.next_screen(),   desc='Move focus to next monitor'),
            M_Key("comma",    lazy.prev_screen(),   desc='Move focus to prev monitor'),
            ]


def layout_opt():
    return [
            # 调整一屏窗口的布局
            M_Key("Tab",        lazy.next_layout(),                 desc='Toggle through layouts'),
            Key(M_S, "k",        lazy.layout.shuffle_up(),           desc='Move window down in current stack'),
            Key(M_S, "j",        lazy.layout.shuffle_down(),         desc='Move window up in current stack'),
            Key(M_S, "h",       lazy.layout.grow(), lazy.layout.increase_nmaster(), desc='Expand window (MonadTall), increase number in master pane (Tile)'),
            Key(M_S, "l",       lazy.layout.shrink(), lazy.layout.decrease_nmaster(), desc='Shrink window (MonadTall), decrease number in master pane (Tile)'),
            M_Key("m",          lazy.layout.maximize(),             desc='toggle window between minimum and maximum sizes'),
            M_Key("n",          lazy.layout.normalize(),            desc='normalize window size ratios'),

            Key(M_S, "f",        lazy.window.toggle_floating(),          desc='toggle floating'),
            Key(M_S, "m",        lazy.window.toggle_fullscreen(),        desc='toggle fullscreen'),

            ### Treetab controls
            Key(M_C, "k",        lazy.layout.section_up(),               desc='Move up a section in treetab'),
            Key(M_C, "j",        lazy.layout.section_down(),             desc='Move down a section in treetab'),
            # Key(M,   "p",        lazy.spawn(myTerm+" -e sh ./.xprofile"),             desc='xrandr for double monitors'),
            ### Stack controls
            Key(M,   "space",    lazy.layout.next(),                       desc='Switch window focus to other pane(s) of stack'),
            Key(M_S, "space",    lazy.layout.rotate(), lazy.layout.flip(), desc='Switch which side main pane occupies (XmonadTall)'),
            Key(M_C, "Return",   lazy.layout.toggle_split(),               desc='Toggle between split and unsplit sides of stack'),

            # windows kill and qtile config reload
            M_Key("c",   lazy.window.kill(),    desc='Kill active window'),
            Key(M_S, "r", lazy.restart(),        desc='Restart Qtile'),
            Key(M_S, "q", lazy.shutdown(),       desc='Shutdown Qtile'),
            ]

def rofi_menus():
    rofi_key = lambda key, cmd, desc: Key(A_C, key, cmd, desc)
    enter = "Return"
    rofi_conf_path = f"{HOME}/.config/rofi"

    return [
            Key(M_S, enter,   lazy.spawn("rofi -show drun"),           desc='Dmenu Run Launcher'),
            M_Key(enter, lazy.spawn(f"{rofi_conf_path}/scripts/rofi-bangs.sh"),    desc="rofi launcher"),
            M_Key("p", lazy.spawn(f"{rofi_conf_path}/scripts/rofi-powermenu.sh"),  desc="power menu"),

            rofi_key("w", lazy.spawn(f"{rofi_conf_path}/scripts/rofi-wifi-menu"), desc="wifi connection managerment"),
            rofi_key("e", lazy.spawn(f"{rofi_conf_path}/scripts/edit-configs.sh"),  desc='rofi script for editing config files'),
            rofi_key("i", lazy.spawn(f"{rofi_conf_path}/scripts/rofi-scrot.sh"),  desc='scrot script for screen print'),
            rofi_key("s", lazy.spawn(f"{rofi_conf_path}/scripts/system-settings.sh"),  desc='rofi script for system settings'),
            rofi_key("d", lazy.spawn(f"{rofi_conf_path}/scripts/rofi-systemd-all.sh"),     desc='systemd all'),
            rofi_key("c", lazy.spawn("rofi -modi 'clipboard:greenclip print' -show clipboard"), desc='rofi menu for clipboard'),
            rofi_key("b", lazy.spawn(f"{rofi_conf_path}/scripts/rofi-bluetooth"), desc="blue tooth managerment"),
            rofi_key("m", lazy.spawn(f"{rofi_conf_path}/scripts/system-monitors.sh"),  desc='rofi script for system monitors'),
            ]

def app_shortcut():
    app_key = lambda key, cmd, desc: Key(M, key, cmd, desc)
    app_key_shift = lambda key, cmd, desc: Key(M_S, key, cmd, desc)
    # vs_code_run = "code --enable-proposed-api ms-toolsai.jupyter"
    return [
            app_key("z", lazy.spawn("zathura"),     desc='e-book viewer'),
            app_key("b", lazy.spawn(BROWSER),       desc='web browser'),
            app_key("f", lazy.spawn("nautilus"),    desc='file explorer'),
            app_key("t", lazy.spawn(TERM),          desc='launche terminal'),
            # app_key("n", lazy.spawn(f"{TERM} -e newsboat"), desc='newsboat'),

            # 以下因为按键冲突，所以加shift键
            app_key_shift("e", lazy.spawn("emacs"),     desc='Doom Emacs'),
            app_key_shift("c", lazy.spawn("calibre"),   desc='book library'),
            app_key_shift("w", lazy.spawn(f"{HOME}/.local/bin/WeChatLinux_x86_64.AppImage"), desc='wechat'),
            ]

def hardware_fn_binding():
    return [
            # Volume
            Key([], "XF86AudioMute", lazy.spawn(f"{HOME}/.local/bin/volumecontrol mute")),
            Key([], "XF86AudioLowerVolume", lazy.spawn(f"{HOME}/.local/bin/volumecontrol down")),
            Key([], "XF86AudioRaiseVolume", lazy.spawn(f"{HOME}/.local/bin/volumecontrol up")),
            # Brightness
            Key([], "XF86MonBrightnessDown", lazy.spawn(f"{HOME}/.local/bin/brightnesscontrol down")),
            Key([], "XF86MonBrightnessUp", lazy.spawn(f"{HOME}/.local/bin/brightnesscontrol up")),
            ]


def bind_key():
    return focus() + layout_opt() + rofi_menus() + app_shortcut() + hardware_fn_binding()

