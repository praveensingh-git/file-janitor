#!/bin/bash
#Saturday 16 August 2025 11:41:57 PM IST

BASE="/home/nedstark/myscripts"
DAYS=10
DEPTH=1
RUN=0   # set to 1 

# Check if dir is present or not
if [ ! -d "$BASE" ]; then
    echo "dir doesn't exist: $BASE"
    exit 1
fi

# Create archive dir if it doesn't exist
mkdir -p "$BASE/archive"

# Find files larger than 20MB
 find "$BASE" -maxdepth $DEPTH -type f -size +20M | while read -r i; do
    echo "[$(date '+%y-%m-%d %H:%M:%S')] archiving $i ==> $BASE/archive"

    if [ $RUN -eq 1 ]; then
        gzip -c "$i" > "$BASE/archive/$(basename "$i").gz" || exit 1
        rm "$i" || exit 1
    fi
done

