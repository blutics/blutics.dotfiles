#!/usr/bin/env bash

sudo pacman -Syu --needed ansible git

ansible-galaxy collection install community.general
