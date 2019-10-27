#!/usr/bin/env bash

## run (only once) processes which spawn with the same name
function run {
   if (command -v $1 && ! pgrep $1); then
     $@&
   fi
}

## run (only once) processes which spawn with different name
if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
    gnome-keyring-daemon --daemonize --login &
fi
if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
    pulseaudio -D
fi
if (command -v /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 && ! pgrep polkit-mate-aut) ; then
    /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
fi
if (command -v  xfce4-power-manager && ! pgrep xfce4-power-man) ; then
    xfce4-power-manager &
fi
# System-config-printer-applet is not installed in minimal edition
if (command -v system-config-printer-applet && ! pgrep applet.py ); then
  system-config-printer-applet &
fi

run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
# run xfsettingsd
run nm-applet
run light-locker
# run compton --shadow-exclude '!focused'
run xcape -e 'Super_L=Super_L|Control_L|Escape'
# run thunar --daemon
run pa-applet
run pamac-tray
run optimus-manager-qt
run redshift -t 6500:3500 
# blueman-applet and msm_notifier are not installed in minimal edition
run blueman-applet
run msm_notifier
run setxkbmap -option grp:switch,grp:lctrl_space_toggle,grp_led:scroll de,ru,ua,us