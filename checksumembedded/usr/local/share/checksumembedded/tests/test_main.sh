#! /usr/bin/env bash

function is_docker() {
    # Check for the presence of .dockerenv file
    if [ -f /.dockerenv ]; then
        # We are inside the docker container
        return 0
    else
        # Check cgroup for docker path
        if grep -q docker /proc/1/cgroup; then
            return 0
        else
            # We are not inside a docker container
            return 1
        fi
    fi
}

# Halt on error.
set -euo pipefail

# Go to execution directory.
cd "$(dirname $(readlink -f "${0}"))"

export REFERENCE_DIR="${REFERENCE_DIR:-}"

export PATH="${PATH}:${REFERENCE_DIR}/usr/local/bin"

# ???:
# checksumembedded --version

# No options passed.
! checksumembedded ./data/test_data_00.md

checksumembedded --verify ./data/test_data_00.md

lines_three_expected="$(
    checksumembedded --verify ./data/test_data_01.md
)"
((3 == $(echo "${lines_three_expected}" | wc --lines)))

checksumembedded --verify ./data/test_data_02.md
! checksumembedded --verify ./data/test_data_03.md
checksumembedded --verify ./data/test_data_04.md
checksumembedded --verify ./data/test_data_05.md
checksumembedded --verify ./data/test_data_06.md
! checksumembedded --verify ./data/test_data_07.md

if is_docker; then
    :
else
    # Verify the documentation files.
    root_dir_="$(git rev-parse --show-toplevel || true)"
    # This should not run when actually installed (because it will be outside
    # of git).
    if [[ -n ${root_dir_} ]]; then
        for file_ in ./docs/manpage.md ./readme.md ./readme.md.jinja; do
            echo ${root_dir_}/${file_}
            [[ -f ${root_dir_}/${file_} ]]
            checksumembedded --verify ${root_dir_}/${file_}
        done
    fi
fi

# vim: set filetype=sh fileformat=unix nowrap:
