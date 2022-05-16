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

export status="true" version="1.0.0" export versionsperator="%"

if [[ -z "${delphipath}" ]] ; then
    export delphipath="/usr/local/lib/bash"
fi

delphi:check() {
    local i="" status="true" IFS=""

    for i in ${@} ; do
        if ! command -v "${i}" &> /dev/null ; then
            echo -e "'${i}' not found.."
            local status="false"
        fi
    done

    if [[ "${status}" = "false" ]]; then
        echo "some dependencies not available!"
        unset i status
        exit 1
    fi
}

delphi:parse:path() {
    local i="" IFS=":"

    if [[ -n "${delphipath}" ]]; then
        for i in ${delphipath} ; do
            echo "${i}"
        done
    else
        return 1
    fi
}

# Check the required triggers.
delphi:check grep awk tr

# Parse the arguments and parameters
if [[ "${#}" -eq 1 ]] && [[ "${1}" = -* || "${1}" = --* ]] ; then
    case "${1}" in
        --[vV][eE][rR][sS][iI][oO][nN]|-[vV])
            # keep it simple.
            echo "${version}"
        ;;
        --[pP][aA][tT][hH]|-[pP])
            echo "${delphipath}"
        ;;
        --[hH][eE][lL][pP]|-[hH])
            echo -e "The delphi library caller v${version} - lazypwny751 2022
there are 4 flags: version, path, help, <libname>

version: --version, -v;
\tprint's current delphi version.

path: --path, -p;
\tprint's delphi library directories.

help: --help, -h;
\tshow's this screen.

<libname>: <libname 1> <libname 2> .. <libname N-1>;
\tcheck and call the library, if not exist them abort the project.
\talso '<libname>%<OPERATION><wantver>' mean <libname> the library
\tto call you want, <OPERATION> the mathematical operator '>', '<' and '='
\tthe last thing <wantwer> is version to you want to call.
"
        ;;
        *)
            echo "'${1}' is an unknown option, please type '${0##*/} --help' for more information."
            exit 1
        ;;
    esac
else
    export import=() 
    while ! [[ "${#}" -le 0 ]] ; do
        export substatus="false"
        read file ver  <<< "$(echo "${1/"${versionsperator}"/" "}")"
        for i in $(delphi:parse:path) ; do
            if [[ -n ${file} && -n ${ver} ]] ; then
                if [[ -f "${i}/${file}.sh" ]] ; then
                    export filever="$(grep '^\#.*$' "${i}/${file}.sh" | grep -w "delphiver:" | awk 'END{print $3}')"
                    if echo "${ver}" | grep ">" &> /dev/null && [[ "${filever}" -gt "${ver/">"/}" ]] ; then
                        export import+=("${i}/${file}.sh")
                        export substatus="true"
                    elif echo "${ver}" | grep "<" &> /dev/null && [[ "${filever}" -lt "${ver/"<"/}" ]] ; then
                        export import+=("${i}/${file}.sh")
                        export substatus="true"
                    elif echo "${ver}" | grep "=" &> /dev/null && [[ "${filever}" -eq "${ver/"="/}" ]] ; then
                        export import+=("${i}/${file}.sh")
                        export substatus="true"
                    fi
                elif [[ "${i}/${file}" ]] ; then
                    export filever="$(grep '^\#.*$' "${i}/${file}" | grep -w "delphiver:" | awk 'END{print $3}')"
                    if echo "${ver}" | grep ">" &> /dev/null && [[ "${filever}" -gt "${ver/">"/}" ]] ; then
                        export import+=("${i}/${file}")
                        export substatus="true"
                    elif echo "${ver}" | grep "<" &> /dev/null && [[ "${filever}" -lt "${ver/"<"/}" ]] ; then
                        export import+=("${i}/${file}")
                        export substatus="true"
                    elif echo "${ver}" | grep "=" &> /dev/null && [[ "${filever}" -eq "${ver/"="/}" ]] ; then
                        export import+=("${i}/${file}")
                        export substatus="true"
                    fi
                fi
            elif [[ -f "${i}/${file}.sh" ]] ; then
                export import+=("${i}/${file}.sh")
                export substatus="true"
            elif [[ -f "${i}/${file}" ]] ; then
                export import+=("${i}/${file}")
                export substatus="true"
            fi
        done

        if [[ "${substatus}" = "false" ]] ; then
            echo "'${file}' couldn't sourcing!"
            export status="false"
        fi
        shift
    done
fi

if [[ "${status}" = "false" ]] ; then
    echo "Some libraries are missing or do not meet the required version to be imported!"
    if [[ -n "${DELPHIRETURN}" ]] ; then
        return 1
    else
        exit 1
    fi
else
    unset version status delphipath versionsperator file ver i
    unset -f delphi:check
fi

for x in ${import[@]} ; do
    source "${x}"
done

unset x