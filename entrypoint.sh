#!/bin/bash
set -e

rm -f /shine_stn_app/tmp/pids/server.pid

exec "$@"

