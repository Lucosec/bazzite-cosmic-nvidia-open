#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux 

# Install COSMIC Desktop Environment
dnf5 install -y @cosmic-desktop-environment

# Remove GNOME Desktop Environment
# The 'dnf swap' command remains the same and is recommended for a cleaner transition.
dnf5 swap -y fedora-release-identity-workstation.noarch fedora-release-identity-cosmic.noarch || { echo "Warning: dnf swap failed, continuing with direct group removal."; }

# The 'dnf group remove' command is now 'dnf environment remove' in dnf5.
dnf5 group remove -y @fedora-workstation 

dnf5 remove -y firefox thunderbird okular libreoffice

# Clean up any orphaned packages
dnf5 autoremove -y

# Configure and Enable the COSMIC Greeter
systemctl disable gdm.service

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
