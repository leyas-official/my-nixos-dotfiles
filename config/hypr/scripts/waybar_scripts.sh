#!/usr/bin/env fish

switch $argv[1]
    case --impala
        exec kitty -e impala
end
