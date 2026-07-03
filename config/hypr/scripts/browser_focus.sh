#!/usr/bin/env bash
app="zen"
hyprctl dispatch focuswindow "class:$app"
exec "$app" "$@"
