#!/usr/bin/env bash

hyprctl dispatch focuswindow 'class:zen'
exec zen "$@"
