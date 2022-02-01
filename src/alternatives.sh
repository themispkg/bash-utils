#!/bin/bash

#    command alternatives library - alternatives 1.0.0
#    Copyright (C) 2021  lazypwny751
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

alternatives:filename() {
    command -v "seq" &> /dev/null || return 1
    command -v "awk" &> /dev/null || return 1
    command -v "tr" &> /dev/null || return 1

    if [[ "${#}" -gt 0 ]] ; then
        if ! command -v filename &> /dev/null ; then
            for y in $(seq 1 ${#}) ; do
                echo ${@:y:1} | tr "/" " " | awk '{print $NF}'
            done
        else
            filename ${@}
        fi
    else
        echo -e "Usage: enter parametres as file/directory path. Example:\n> alternatives:filename /tmp/test/test.sh\n< test.sh"
        return 1
    fi
}

alternatives:install() {
    command -v "chmod" &> /dev/null || return 1
    command -v "cp" &> /dev/null || return 1

    case "${1}" in
        [mM][oO][dD]|--[mM][oO][dD]|-[mM])
            if [[ "${#}" -lt 5 ]] ; then
                local set_mod="${2}"
                cp -r "${3}" "${4}"
                if [[ "$(alternatives:filename "$_")" = "$(alternatives:filename "${3}")" ]] ; then
                    chmod "${set_mod}" "$_"
                else
                    chmod "${set_mod}" "${4}"
                fi
            else
                echo "insufficient argument"
                return 1 # stderr
            fi
        ;;
        *)
            if [[ "${#}" -lt 3 ]] ; then
                cp -r "${1}" "${2}"
            else
                echo "insufficient argument"
                return 1 # stderr
            fi
        ;;
    esac
}

alternatives:mktemp() {
    command -v "mkdir" &> /dev/null || return 1
    command -v "touch" &> /dev/null || return 1
    command -v "head" &> /dev/null || return 1
    command -v "tr" &> /dev/null || return 1

    alternatives:mktemp:build:random:string() {
        < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c "${1}"
    }

    case "${1}" in
        [dD][iI][rR][eE][cC][tT][oO][rR][yY]|--[dD][iI][rR][eE][cC][tT][oO][rR][yY]|-[dD])
            if [[ -d "/tmp" ]] ; then
                while :; do
                    local digit="8"
                    local dir="/tmp/tmp.$(alternatives:mktemp:build:random:string "${digit}")"
                    if [[ ! -d "${dir}" ]] ; then
                        mkdir -p "${dir}" &> /dev/null
                        echo "${dir}"
                        break
                    fi
                done
            else
                return 1
            fi
        ;;
        *)
            if [[ -d "/tmp" ]] ; then
                while :; do
                    local digit="8"
                    local file="/tmp/tmp.$(alternatives:mktemp:build:random:string "${digit}")"
                    if [[ ! -e "${file}" ]] ; then
                        touch "${file}" &> /dev/null
                        echo "${file}"
                        break
                    fi
                done
            else
                return 1
            fi
        ;;
    esac
}