#!/bin/bash

## Constants

# Pi
export PI="3.14159"
# Naiper's constant
export E="2.71828"
# Pisagor constant
export PC="1.41421"
# Theodorus constant
export TC="1.73205"
# Euler Mascheroni constant
export EMC="0.57721"
# Golden mean
export GM="1.61803"
# Embree Trefethen constant
export ETC="0.70258"

math:sqrt() {
    command -v "bc" &> /dev/null || return 1

    # Square Roots
    echo "scale=0;sqrt(${1})" | bc
}

math:is_integer() {
    # Return status:
    # 0: okay, you can go ahead
    # 1: insufficient argument

    if [[ "${#}" -gt 0 ]] ; then
        if [[ "${1}" =~ ^[0-9]+$ ]] ; then
            return 0
        fi
    else
        return 1
    fi
}