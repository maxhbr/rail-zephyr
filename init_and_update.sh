#!/usr/bin/env bash

if [[ ! -d zephyr ]]; then
    west init
fi
west update
