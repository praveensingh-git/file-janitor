#!/bin/bash
# Created on Sunday 17 August 2025 06:34:37 PM IST
# Example= ./auto-archive.sh /home/nedstark/myscripts 10 1 0

BASE="/home/nedstark/myscripts"
DAYS=10
DEPTH=1
RUN=1   # 0 = dry run, 1 = real run

#Override with CLI arguments

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "Usage: $0 [BASE] [DAYS] [DEPTH] [RUN]"
    echo "  BASE : directory to scan (default: $BASE)"
    echo "  DAYS : days to keep archives (default: $DAYS)"
    echo "  DEPTH: max depth for find (default: $DEPTH)"
    echo "  RUN  : 0 = dry run, 1 = real run (default: $RUN)"
    exit 0
fi

[ -n "$1" ] && BASE="$1"
[ -n "$2" ] && DAYS="$2"
[ -n "$3" ] && DEPTH="$3"
[ -n "$4" ] && RUN="$4"

#Check base dir exists

if [ ! -d "$BASE" ]; then
    echo "Error: dir doesn't exist: $BASE"
    exit 1
fi

#Ensure archive dir exists

mkdir -p "$BASE/archive"

#Find and process files

if [ "$RUN" -eq 1 ]; then
    echo "[RUN MODE] Archiving files..."
    find "$BASE" -maxdepth "$DEPTH" -type f -size +20M | while read -r i; do
        echo "[$(date '+%y-%m-%d %H:%M:%S')] archiving $i ==> $BASE/archive"
        gzip -c "$i" > "$BASE/archive/$(basename "$i").gz" && rm "$i"
    done
else

#Dry Run
echo "[DRY RUN] Listing files that would be archived..."
    find "$BASE" -maxdepth "$DEPTH" -type f -size +20M | while read -r i; do
        echo "[$(date '+%y-%m-%d %H:%M:%S')] would archive $i ==> $BASE/archive"
    done
fi


#Cleanup old archives
if [[ "$RUN" -eq 1 ]]; then
echo "Cleaning up archives older than $DAYS days..."
find "$BASE/archive" -type f -mtime +"$DAYS" -print -delete
fi
