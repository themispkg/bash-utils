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
    local status="true" directory=() trigger=() file=()

    while [[ "${#}" -gt 0 ]] ; do
        case "${1}" in
            -d)
                shift
                while [[ "${#}" -gt 0 ]] ; do
                    case "${1}" in
                        -d|-t|-f)
                            break
                        ;;
                        *)
                            local directory+=("${1}")
                            shift
                        ;;
                    esac
                done
            ;;
            -t)
                shift
                while [[ "${#}" -gt 0 ]] ; do
                    case "${1}" in
                        -d|-t|-f)
                            break
                        ;;
                        *)
                            local trigger+=("${1}")
                            shift
                        ;;
                    esac
                done
            ;;
            -f)
                shift
                while [[ "${#}" -gt 0 ]] ; do
                    case "${1}" in
                        -d|-t|-f)
                            break
                        ;;
                        *)
                            local file+=("${1}")
                            shift
                        ;;
                    esac
                done
            ;;
            -s|--silent)
                local IS_SILENT="true"
                shift
            ;;
            *)
                shift
            ;;
        esac
    done

    # Directory
    for i in ${directory[@]} ; do
        if [[ "${IS_SILENT}" = "yes" ]] ; then
            if ! [[ -d "${i}" ]] ; then
                echo -e "\tDirectory: '\033[0;31m${i}\033[0m' not found!"
                local status="false"
            fi
        else
            if [[ -d "${i}" ]] ; then
                echo -e "\tDirectory: '\033[0;32m${i}\033[0m' found."
            else
                echo -e "\tDirectory: '\033[0;31m${i}\033[0m' not found!"
                local status="false"
            fi
        fi
    done
    # end

    # Trigger
    for i in ${trigger[@]} ; do
        if [[ "${IS_SILENT}" = "true" ]] ; then
            if ! command -v "${i}" &> /dev/null ; then
                echo -e "\tTrigger: '\033[0;31m${i}\033[0m' not found!"
                local status="false"
            fi
        else
            if command -v "${i}" &> /dev/null ; then
                echo -e "\tTrigger: '\033[0;32m${i}\033[0m' found."
            else
                echo -e "\tTrigger: '\033[0;31m${i}\033[0m' not found!"
                local status="false"
            fi
        fi
    done
    # end

    # File
    for i in ${file[@]} ; do
        if [[ "${IS_SILENT}" = "true" ]] ; then
            if ! [[ -f "${i}" ]] ; then
                echo -e "\tFile: '\033[0;31m${i}\033[0m' not found!"
                local status="false"
            fi
        else
            if [[ -f "${i}" ]] ; then
                echo -e "\tFile: '\033[0;32m${i}\033[0m' found."
            else
                echo -e "\tFile: '\033[0;31m${i}\033[0m' not found!"
                local status="false"
            fi
        fi
    done
    # end

    # Result
    if [[ "${IS_SILENT}" = "true" ]] ; then
        if [[ "${status}" = "false" ]] ; then
            echo "\033[0;31mRequirements not met!\033[0m"
            return 1
        fi
    else
        if [[ "${status}" = "true" ]] ; then
            echo -e "\033[0;32mRequirements are met.\033[0m"
        else
            echo -e "\033[0;31mRequirements not met!\033[0m"
            return 1
        fi
    fi
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