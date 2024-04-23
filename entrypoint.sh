#!/bin/bash
set -e

rm -f /second_to_none/tmp/pids/server.pid

exec "$@"

