#!/usr/bin/env bash
set -euo pipefail
input=$(cat)
@jq@ \
  --arg rtk "@rtk@" \
  '.tool_input.command = ($rtk + " " + .tool_input.command)' \
  <<<"$input"
echo "Hook"
