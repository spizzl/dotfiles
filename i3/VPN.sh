#!/bin/bash

out=$(ip addr | grep tun)

if [ "$out" ]; then
    printf "VPN: ✅  "
else
    printf "VPN: ❌  "
fi
