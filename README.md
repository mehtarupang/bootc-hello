# Bootc Hello World + GitOps Beginner Lab

This lab teaches the basic bootc + GitOps workflow using a bare-metal server and a Mac workstation.

## Architecture

Mac workstation
  -> Git repository
  -> build bootc image
  -> OCI registry
  -> GitOps desired state
  -> bare-metal bootc server
  -> Hello World web service

## Important

The Mac is the workstation. The bare-metal Linux server is the bootc target.

The first version uses a simple systemd-managed NGINX service inside the bootc image. A later lab can move the application to a separate Quadlet/container model.

## Prerequisites

### Mac
- macOS
- Homebrew
- Git
- Podman
- Podman machine with at least 4 CPUs, 8 GiB RAM, 40 GiB disk
- SSH client
- GitHub account
- OCI registry account

### Bare-metal server
- Dedicated lab server
- x86_64 CPU
- UEFI boot
- At least 4 CPU cores
- At least 8 GiB RAM
- At least 40 GiB disk
- Network access to the registry
- Console/iDRAC/iLO access

WARNING: Installing bootc to a disk is destructive. Use a dedicated lab disk.

## First Mac setup

    brew install git podman
    podman machine init --cpus 4 --memory 8192 --disk-size 40
    podman machine start
    podman info

Create an SSH key:

    ssh-keygen -t ed25519 -C "bootc-lab" -f ~/.ssh/bootc-lab

## Build

    podman build -t bootc-hello:dev .

Run a normal container test first:

    podman run --rm -p 8080:8080 bootc-hello:dev

Then open http://localhost:8080 from the Mac if the Podman machine forwards the port.

## Registry

Tag and push the image to your registry, replacing REGISTRY/USER:

    podman login REGISTRY
    podman tag bootc-hello:dev REGISTRY/USER/bootc-hello:latest
    podman push REGISTRY/USER/bootc-hello:latest

Update gitops/desired-image.txt with the fully-qualified image.

## GitOps reconciler

The included systemd timer is educational. It periodically reads the desired image and runs:

    bootc switch --apply IMAGE

For production fleet management, use a proper fleet/operator/controller model rather than this simple shell-based reconciler.

## Learning sequence

1. Build the image.
2. Run it as an ordinary container.
3. Push it to an OCI registry.
4. Generate/install a bootc disk image.
5. Boot the bare-metal server.
6. Confirm with `bootc status`.
7. Change the image.
8. Commit the desired image to Git.
9. Reconcile the server.
10. Observe the transactional bootc update.
11. Practice rollback.
