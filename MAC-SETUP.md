# Mac Workstation Setup

## 1. Install Homebrew

Install Homebrew from the official Homebrew site if it is not already installed.

Verify:

    brew --version

## 2. Install Git and Podman

    brew install git podman

Verify:

    git --version
    podman --version

## 3. Create the Linux Podman machine

    podman machine init --cpus 4 --memory 8192 --disk-size 40
    podman machine start

Verify:

    podman info

The containers run inside this Linux VM rather than directly on macOS.

## 4. SSH key

    ssh-keygen -t ed25519 -C "bootc-lab" -f ~/.ssh/bootc-lab

Keep `~/.ssh/bootc-lab` private. Only the `.pub` file belongs on the server.

## 5. Troubleshooting

If Podman behaves unexpectedly:

    podman machine stop
    podman machine start

Bootc image building is Linux-native. If a privileged `bootc-image-builder` operation does not work through the Podman machine on your Mac, use a small Linux VM as the build helper while keeping the Mac for Git, SSH and editing.
