#!/usr/bin/env fish

set step 5

function get_backlight
    brightnessctl -m | cut -d, -f4 | string replace "%" ""
end

function change_backlight
    set current_brightness (get_backlight)

    switch $argv[1]
        case "+$step%"
            set new_brightness (math "$current_brightness + $step")
        case "$step%-"
            set new_brightness (math "$current_brightness - $step")
    end

    if test $new_brightness -lt 5
        set new_brightness 5
    else if test $new_brightness -gt 100
        set new_brightness 100
    end

    brightnessctl set "$new_brightness%"
end

switch $argv[1]
    case "--get"
        get_backlight

    case "--inc"
        change_backlight "+$step%"

    case "--dec"
        change_backlight "$step%-"

    case "*"
        get_backlight
end
