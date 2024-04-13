#!/bin/bash
set -e

rm -f /blast_stn_knowledge/tmp/pids/server.pid

exec "$@"

