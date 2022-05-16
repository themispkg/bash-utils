#!/bin/bash

#    Operating Systems Utils - os utils 1.0.0
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

# delphiver: 1

export SUDOUSER="${SUDO_USER:-$USER}"

osutil:is_root() {
    case "${1}" in
        -[sS]|--[sS][iI][lL][eE][nN][tT])
            if [[ "${UID}" = 0 ]] ; then
                return 0
            else
                return 1
            fi
        ;;
        *)
            if [[ "${UID}" = 0 ]] ; then
                echo -e "\033[0;32mThis user has super cow powers\033[0m."
                return 0
            else
                echo -e "\033[0;31mPlease run it as root privalages\033[0m."
                return 1
            fi
        ;;
    esac
}

osutil:check() {
    tabs 15
    
    conf:check:output() {
        case "${1}" in
            --error|-e)
                echo -e "\t\033[0;31mNOT\033[0m\t${2}"
                export status="bad"
            ;;
            --success|-s)
                echo -e "\t\033[0;32mOK\033[0m\t${2}"
            ;;
        esac
    }

    ## Check it self depends
    file /usr/bin/command &> /dev/null || return 1
    file /usr/bin/basename &> /dev/null || return 1
    ## Main command block
    
    export status="good"
    local i=""

    # parsing arguments

    while [[ "${#}" -gt 0  ]] ; do
        case "${1}" in
            -t)
                shift
                local x=""
                while [[ "${#}" -gt 0 ]] ; do
                    case "${1}" in
                        -t|-f|-d)
                            break
                        ;;
                        *)
                            [[ -z "${trigger}" ]] && local trigger="${1}" || local trigger="${trigger}:${1}"
                            shift
                        ;;
                    esac
                done
                unset x
            ;;
            -f)
                shift
                local x=""
                while [[ "${#}" -gt 0 ]] ; do
                    case "${1}" in
                        -t|-f|-d)
                            break
                        ;;
                        *)
                            [[ -z "${file}" ]] && local file="${1}" || local file="${file}:${1}"
                            shift
                        ;;
                    esac
                done
                unset x
            ;;
            -d)
                shift
                local x=""
                while [[ "${#}" -gt 0 ]] ; do
                    case "${1}" in
                        -t|-f|-d)
                            break
                        ;;
                        *)
                            [[ -z "${directory}" ]] && local directory="${1}" || local directory="${directory}:${1}"
                            shift
                        ;;
                    esac
                done
                unset x
            ;;
            -[sS]|--[sS][iI][lL][eE][nN][tT])
                export IS_SILENT="yes"
            ;;
        esac
        shift
    done

    local IFS=":" # <- first ifs is here and no unset recomended before

    # Check trigger
    local z=""
    for z in ${trigger} ; do
        if [[ "${IS_SILENT}" = "yes" ]] ; then
            command -v "${z}" &> /dev/null || conf:check:output --error "${z} not found!"
        else
            command -v "${z}" &> /dev/null && conf:check:output --success "${z} found." || conf:check:output --error "${z} not found!"
        fi
    done
    unset z

    # Check file
    local z=""
    for z in ${file} ; do
        if [[ "${IS_SILENT}" = "yes" ]] ; then
            [[ -f "${z}" ]] || conf:check:output --error "file ${z} doesn't exist!"
        else
            [[ -f "${z}" ]] && conf:check:output --success "file $(basename ${z}) exist." || conf:check:output --error "file ${z} doesn't exist!"
        fi 
    done
    unset z

    # Check directory
    local z=""
    for z in ${directory} ; do
        if [[ "${IS_SILENT}" = "yes" ]] ; then
            [[ -d "${z}" ]] || conf:check:output --error "directory ${z} doesn't exist!"
        else
            [[ -d "${z}" ]] && conf:check:output --success "directory $(basename ${z}) exist." || conf:check:output --error "directory ${z} doesn't exist!"
        fi
    done
    unset z

    if [[ "${status}" = "good" ]] ; then
        if [[ "${IS_SILENT}" != "yes" ]] ; then
            echo -e "\033[0;32mAll dependencies found, skipping to next step..\033[0m"
        fi
        unset i x status trigger file directory IS_SILENT
        unset -f conf:check:output
        return 0
    else
        echo -e "\033[0;31mSome dependencies not found, aborting!\033[0m"
        unset -f conf:check:output
        unset i x status trigger file directory
        return 1
    fi

    # If the return code != 0 then we need any error output
    # so when you use the 'silent' option it doesn't metter 
    # when the return code != 0.
}

osutil:define() {
    case "${1}" in
        [bB][aA][sS][eE]|--[bB][aA][sS][eE]|-[bB])
            case "${2}" in
                [sS][iI][lL][eE][nN][tT]|--[sS][iI][lL][eE][nN][tT]|-[sS])
                    if [[ -e /etc/debian_version ]] ; then
                        sysbase="debian"
                    elif [[ -e /etc/arch-release ]] ; then
                        sysbase="arch"
                    elif [[ -e /etc/artix-release ]] ; then
                        sysbase="arch"
                    elif [[ -e /etc/fedora-release ]] ; then
                        sysbase="fedora"
                    elif [[ -e /etc/pisi-release ]] ; then
                        sysbase="pisi"
                    elif [[ -e /etc/zypp/zypper.conf ]] ; then
                        sysbase="opensuse"
                    else
                        sysbase="unknow"
                    fi
                ;;
                *)
                    if [[ -e /etc/debian_version ]] ; then
                        echo "debian"
                    elif [[ -e /etc/arch-release ]] ; then
                        echo "arch"
                    elif [[ -e /etc/artix-release ]] ; then
                        echo "arch"
                    elif [[ -e /etc/fedora-release ]] ; then
                        echo "fedora"
                    elif [[ -e /etc/pisi-release ]] ; then
                        echo "pisi"
                    elif [[ -e /etc/zypp/zypper.conf ]] ; then
                        echo "opensuse"
                    else
                        echo "unknow"
                    fi
                ;;
            esac
        ;;
        [iI][sS]-[aA][rR][cC][hH]|--[iI][sS]-[aA][rR][cC][hH]|-[iI][aA])
            case "${2}" in
                [xX]86)
                    if [[ $(uname -i) = "x86" ]] ; then
                        return 0
                    else
                        return 1
                    fi
                ;;
                [xX]64|[xX]86_[xX]64)
                    if [[ $(uname -i) = "x86_64" ]] ; then
                        return 0
                    else
                        return 1
                    fi
                ;;
                [aA][aA][rR][cC][hH]64)
                    if [[ $(uname -i) = "aarch64" ]] ; then
                        return 0
                    else
                        return 1
                    fi
                ;;
            esac
        ;;
    esac
}

osutil:update() {
    # just run this function ostutil:update
    osutil:is_root --silent || exit 1
    case "$(osutil:define --base)" in
        debian)
            apt update
        ;;
        arch)
            pacman -Syy
        ;;
        fedora)
            dnf check-update
        ;;
        pisi)
            pisi ur
        ;;
        opensuse)
            zypper refresh
        ;;
        unknow)
            echo "unknow base so there is nothing to do"
            return 1
        ;;
    esac
}

osutil:install() {
    # osutil:install <package as base> <package as base>..
    osutil:is_root --silent || exit 1
    case "$(osutil:define --base)" in
        debian)
            apt install -y ${1}
        ;;
        arch)
            pacman -Sy --noconfirm ${1}
        ;;
        fedora)
            dnf install -y ${1}
        ;;
        pisi)
            pisi it -y ${1}
        ;;
        opensuse)
            zypper remove --no-confirm ${1}
        ;;
    esac
}

osutil:uninstall() {
    # osutil:uninstall <package as base> <package as base>..
    osutil:is_root --silent || exit 1
    case "$(osutil:define --base)" in
        debian)
            apt remove -y ${1}
        ;;
        arch)
            pacman -R --noconfirm ${1}
        ;;
        fedora)
            dnf remove -y ${1}
        ;;
        pisi)
            pisirmt -y ${1}
        ;;
        opensuse)
            zypper remove --no-confirm ${1}
        ;;
    esac
}