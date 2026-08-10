#!/usr/bin/env fish

switch $argv[1]
    case --nmtui
        exec kitty -e nmtui
end
