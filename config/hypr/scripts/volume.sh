#!/usr/bin/env fish
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Scripts for volume controls for audio and mic

set iDIR "$HOME/.config/swaync/icons"
set sDIR "$HOME/.config/hypr/scripts"

# Get Volume
function get_volume
    set volume (pamixer --get-volume)
    if test "$volume" -eq 0
        echo "Muted"
    else
        echo "$volume %"
    end
end

# Get icons
function get_icon
    set current (get_volume)
    if test "$current" = "Muted"
        echo "$iDIR/volume-mute.png"
    else
        set level (string replace '%' '' -- $current)
        if test "$level" -le 30
            echo "$iDIR/volume-low.png"
        else if test "$level" -le 60
            echo "$iDIR/volume-mid.png"
        else
            echo "$iDIR/volume-high.png"
        end
    end
end

# Increase Volume
function inc_volume
    if test (pamixer --get-mute) = "true"
        toggle_mute
    else
        pamixer -i 5 --allow-boost --set-limit 150
    end
end

# Decrease Volume
function dec_volume
    if test (pamixer --get-mute) = "true"
        toggle_mute
    else
        pamixer -d 5 --allow-boost --set-limit 150
    end
end

# Toggle Mute
function toggle_mute
    if test (pamixer --get-mute) = "false"
        pamixer -m
    else if test (pamixer --get-mute) = "true"
        pamixer -u
    end
end

# Toggle Mic
function toggle_mic
    if test (pamixer --default-source --get-mute) = "false"
        pamixer --default-source -m
    else if test (pamixer --default-source --get-mute) = "true"
        pamixer --default-source -u
    end
end

# Get Mic Icon
function get_mic_icon
    set current (pamixer --default-source --get-volume)
    if test "$current" -eq 0
        echo "$iDIR/microphone-mute.png"
    else
        echo "$iDIR/microphone.png"
    end
end

# Get Microphone Volume
function get_mic_volume
    set volume (pamixer --default-source --get-volume)
    if test "$volume" -eq 0
        echo "Muted"
    else
        echo "$volume %"
    end
end

# Notify for Microphone
function notify_mic_user
    set volume (get_mic_volume)
    set icon (get_mic_icon)
end

# Increase MIC Volume
function inc_mic_volume
    if test (pamixer --default-source --get-mute) = "true"
        toggle_mic
    else
        pamixer --default-source -i 5
        and notify_mic_user
    end
end

# Decrease MIC Volume
function dec_mic_volume
    if test (pamixer --default-source --get-mute) = "true"
        toggle_mic
    else
        pamixer --default-source -d 5
    end
end

# Execute accordingly
switch $argv[1]
    case --get
        get_volume
    case --inc
        inc_volume
    case --dec
        dec_volume
    case --toggle
        toggle_mute
    case --toggle-mic
        toggle_mic
    case --get-icon
        get_icon
    case --get-mic-icon
        get_mic_icon
    case --mic-inc
        inc_mic_volume
    case --mic-dec
        dec_mic_volume
    case '*'
        get_volume
end
