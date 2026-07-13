#!/usr/bin/env bash
app="helium"
hyprctl dispatch focuswindow "class:$app"
exec "$app" "$@"
