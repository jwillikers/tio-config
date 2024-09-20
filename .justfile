default: install

alias f := format
alias fmt := format

format:
    just --fmt --unstable

install:
    #!/usr/bin/env bash
    set -euxo pipefail
    distro=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)
    if [ "$distro" = "fedora" ]; then
        variant=$(awk -F= '$1=="VARIANT_ID" { print $2 ;}' /etc/os-release)
        if [ "$variant" = "toolbx" ]; then
            sudo usermod --append --groups dialout $USER
            sudo dnf --assumeyes install tio
        elif [ "$variant" = "iot" ] || [[ "$variant" = *-atomic ]]; then
            echo (getent group dialout) | sudo tee --append /etc/group
            sudo usermod --append --groups dialout $USER
            sudo rpm-ostree install --idempotent tio
            echo "Reboot and rerun to finish installation."
        fi
    fi
    mkdir --parents "{{ config_directory() }}/tio"
    ln --force --relative --symbolic tio/config "{{ config_directory() }}/tio/"
