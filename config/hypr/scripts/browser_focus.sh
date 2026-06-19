#!/usr/bin/env bash

hyprctl dispatch focuswindow 'class:librewolf'
exec librewolf "$@"
