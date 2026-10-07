#!/usr/bin/env bash
set -Eeuo pipefail

exec tor -f /etc/tor/torrc
