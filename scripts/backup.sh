#!/usr/bin/env bash
# Create a timestamped compressed tar archive without modifying source files.
set -Eeuo pipefail

usage() { echo "Usage: $0 SOURCE_DIR BACKUP_DIR" >&2; exit 2; }
(($# == 2)) || usage
source_dir=$(realpath -e -- "$1")
backup_dir=$(realpath -m -- "$2")
[[ -d "$source_dir" ]] || { echo 'SOURCE_DIR must be a directory.' >&2; exit 2; }
[[ "$source_dir" != / ]] || { echo 'Refusing to archive the filesystem root.' >&2; exit 2; }
if [[ "$backup_dir" == "$source_dir" || "$backup_dir" == "$source_dir"/* ]]; then
  echo 'BACKUP_DIR must not be inside SOURCE_DIR.' >&2
  exit 2
fi
mkdir -p -- "$backup_dir"
base=$(basename -- "$source_dir")
stamp=$(date -u +%Y%m%dT%H%M%SZ)
archive="$backup_dir/${base}-${stamp}.tar.gz"
tmp="$archive.tmp.$$"
trap 'rm -f -- "$tmp"' EXIT

printf 'Creating archive: %s\n' "$archive"
tar -C "$(dirname -- "$source_dir")" -czf "$tmp" -- "$base"
mv -- "$tmp" "$archive"
trap - EXIT
printf 'Backup complete: %s (%s)\n' "$archive" "$(du -h -- "$archive" | cut -f1)"
printf 'Verify with: tar -tzf %q | head\n' "$archive"
