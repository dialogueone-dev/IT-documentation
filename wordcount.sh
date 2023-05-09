#!/bin/sh

find IT-documentation/ -type f -name "*.md" -exec wc -m {} \; | awk '{total += $1} END {print total}'