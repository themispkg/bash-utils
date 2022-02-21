#!/bin/bash

#    Bash Library Controller - delphi(import shell, imports.h)
#    Copyright (C) 2022  lazypwny751
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

# Delphi: It is known that Themis built it, this place has prophecy.
# source: https://en.wikipedia.org/wiki/Themis https://en.wikipedia.org/wiki/Temple_of_Apollo_(Delphi) 

# Delfi: Themis'in inşa ettirdiği bilinmektedir bu yerin kehanet özelliği vardır.
# kaynak: https://tr.wikipedia.org/wiki/Themis https://tr.wikipedia.org/wiki/Delfi

# Main variables of delphi
delphiver="1.0.0"
delphidir="/usr/local/lib/bash"

# init
command -v grep &> /dev/null || { echo "awk not found!" ; exit 1 ; }
command -v awk &> /dev/null || { echo "awk not found!" ; exit 1 ; } 
command -v cat &> /dev/null || { echo "cat not found!" ; exit 1 ; }
command -v tr &> /dev/null || { echo "awk not found!" ; exit 1 ; }
command -v wc &> /dev/null || { echo "awk not found!" ; exit 1 ; }

delphi:env() {
    delphi:env:help() {
        cat - <<USAGE

USAGE
    }
    delphi:env:getver() {
        if [[ -f "${delphidir}/${1}" ]] ; then
            grep "# delphiver: " "${delphidir}/${1}" | tail -n 1 | awk '{print $3}' || { echo -e "'${1}' \033[0;31mhaven't version yet\033[0m!"; return 1; }
        else
            echo -e "'${1}' \033[0;31mdoesn't exist\033[0m!"
            return 1
        fi
    }
}

case "${1}" in
    [iI][nN][fF][oO]|--[iI][nN][fF][oO]|-[iI])
        case "${2}" in
            #[cC][hH][aA][nN][gG][eE]-[rR][eE][cC][oO][rR][dD])
            #    delphi:env
            #    echo -e "\033[0;31mthis feature haven't yet ready\033[0m"
            #    for i in $(seq 1 $((${#} - 2))) ; do
            #        true
            #    done
            #;;
            #[cC][oO][mM][mM][eE][nN][tT]|--[cC][oO][mM][mM][eE][nN][tT]|-[cC])
            #    delphi:env
            #    echo -e "\033[0;31mthis feature haven't yet ready\033[0m"
            #    for i in $(seq 1 $((${#} - 2))) ; do
            #        true
            #    done
            #;;
            *)
                # just type full name of lib
                delphi:env
                for i in ${@:2:1} ; do
                    if delphi:env:getver "${i}" &> /dev/null ; then
                        echo "$(delphi:env:getver "${i}") / ${i}"
                    else
                        echo -e "'${i}' \033[0;31m isn't found!\033[0m"
                    fi
                done
            ;;
        esac
    ;;
    [vV][eE][rR][sS][iI][oO][nN]|--[vV][eE][rR][sS][iI][oO][nN]|-[vV])
        echo "${delphiver}"
    ;;
    [hH][eE][lL][pP]|--[hH][eE][lL][pP]|-[hH])
        delphi:env
        delphi:env:help
    ;;
    *)
        delphi:env
        delphistatus="true"
        for i in $@ ; do
            # If wants custom version
            if [[ "$(echo "${i}" | tr "#" " " | wc -w)" = 2 ]]; then
                delphilib="$(echo "${i}" | tr "#" " " | awk '{print $1}')"
                delphiwantlibver="$(echo "${i}" | tr "#" " " | awk '{print $2}')"
                # If .sh
                if [[ -f "${delphidir}/${delphilib}.sh" ]] ; then
                    if [[ "$(echo "${delphiwantlibver}" | head -c 1)" = ">" ]] ; then
                        if [[ "$(delphi:env:getver "${delphilib}.sh")" -gt "$(echo "${delphiwantlibver}" | cut -c2-)" ]] 2> /dev/null ; then
                            source "${delphidir}/${delphilib}.sh"
                        else
                            echo -e "the package '${delphilib}.sh' found but the version '$(delphis:env:getver "${delphilib}.sh")' is little than $(echo "${delphiwantlibver}" | cut -c2-) so it will be not source."
                            delphistatus="false"
                        fi
                    elif [[ "$(echo "${delphiwantlibver}" | head -c 1)" = "<" ]] 2> /dev/null ; then
                        if [[ "$(delphi:env:getver "${delphilib}.sh")" -lt "$(echo "${delphiwantlibver}" | cut -c2-)" ]] ; then
                            source "${delphidir}/${delphilib}.sh"
                        else
                            echo -e "the package '${delphilib}.sh' found but the version '$(delphis:env:getver "${delphilib}.sh")' is greater than $(echo "${delphiwantlibver}" | cut -c2-) so it will be not source."
                            delphistatus="false"
                        fi
                    elif [[ "$(echo "${delphiwantlibver}" | head -c 1)" = "=" ]] 2> /dev/null ; then
                        if [[ "$(delphi:env:getver "${delphilib}.sh")" -eq "$(echo "${delphiwantlibver}" | cut -c2-)" ]] ; then
                            source "${delphidir}/${delphilib}.sh"
                        else
                            echo -e "the package '${delphilib}.sh' found but the version '$(delphis:env:getver "${delphilib}.sh")' isn't equal than $(echo "${delphiwantlibver}" | cut -c2-) so it will be not source."
                            delphistatus="false"
                        fi
                    else
                        echo -e "delphi doesn't support the operator '$(echo "${delphiwantlibver}" | head -c 1)'"
                        delphistatus="false"
                    fi

                # If not .sh
                elif [[ -f "${delphidir}/${delphilib}" ]] ; then

                    if [[ "$(echo "${delphiwantlibver}" | head -c 1)" = ">" ]] ; then
                        if [[ "$(delphi:env:getver "${delphilib}")" -gt "$(echo "${delphiwantlibver}" | cut -c2-)" ]] 2> /dev/null ; then
                            source "${delphidir}/${delphilib}"
                        else
                            echo -e "the package '${delphilib}.sh' found but the version '$(delphis:env:getver "${delphilib}")' is little than $(echo "${delphiwantlibver}" | cut -c2-) so it will be not source."
                            delphistatus="false"
                        fi
                    elif [[ "$(echo "${delphiwantlibver}" | head -c 1)" = "<" ]] 2> /dev/null ; then
                        if [[ "$(delphi:env:getver "${delphilib}")" -lt "$(echo "${delphiwantlibver}" | cut -c2-)" ]] ; then
                            source "${delphidir}/${delphilib}"
                        else
                            echo -e "the package '${delphilib}.sh' found but the version '$(delphis:env:getver "${delphilib}")' is greater than $(echo "${delphiwantlibver}" | cut -c2-) so it will be not source."
                            delphistatus="false"
                        fi
                    elif [[ "$(echo "${delphiwantlibver}" | head -c 1)" = "=" ]] 2> /dev/null ; then
                        if [[ "$(delphi:env:getver "${delphilib}")" -eq "$(echo "${delphiwantlibver}" | cut -c2-)" ]] ; then
                            source "${delphidir}/${delphilib}"
                        else
                            echo -e "the package '${delphilib}.sh' found but the version '$(delphis:env:getver "${delphilib}")' isn't equal than $(echo "${delphiwantlibver}" | cut -c2-) so it will be not source."
                            delphistatus="false"
                        fi
                    else
                        echo -e "delphi doesn't support the operator '$(echo "${delphiwantlibver}" | head -c 1)'"
                        delphistatus="false"
                    fi
                else
                    echo -e "'${delphilib}' \033[0;31mnot found!\033[0m"
                    delphistatus="false"
                fi 

            else
                if [[ -f "${delphidir}/${i}.sh" ]] ; then
                    source "${delphidir}/${i}.sh"
                elif [[ -f "${delphidir}/${i}" ]] ; then
                    source "${delphidir}/${i}"
                else
                    echo -e "'${i}' \033[0;31mnot found!\033[0m"
                    delphistatus="false"
                fi
            fi

        done

        if [[ "${delphistatus}" = "true" ]] ; then
            true
        else
            echo -e "\033[0;31mdelphi could not load libraries correctly\033[0m!"
            exit 1
        fi
    ;;
esac