#!/bin/bash
pkill_imaginary() {
  pkill imaginary
}

trap pkill_imaginary SIGINT
trap pkill_imaginary SIGTERM

if type /bin/imaginary 2>&1 >/dev/null; then
  /bin/imaginary "$@" &
else
  ./imaginary "$@" &
fi

sleep 10

pkill -USR2 imaginary

while pgrep imaginary 2>&1 >/dev/null; do
  sleep 5
done
