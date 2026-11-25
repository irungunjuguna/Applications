#!/usr/bin/env bash
# Create and verify a timestamped compressed backup of a directory.
set -Eeuo pipefail

usage() {
    echo "Usage: $0 <source_directory> <backup_directory>"
    echo
    echo "Example:"
    echo "  $0 /etc /mnt/backups"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

if (($# != 2)); then
    usage >&2
    exit 2
fi

source_dir="$1"
backup_dir="$2"

if [[ ! -d "$source_dir" ]]; then
    echo "Error: Source directory does not exist: $source_dir" >&2
    exit 1
fi

if ! command -v realpath >/dev/null 2>&1; then
    echo "Error: realpath is required but was not found." >&2
    exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
    echo "Error: tar is required but was not found." >&2
    exit 1
fi

source_real=$(realpath -e -- "$source_dir")

if [[ "$source_real" == "/" ]]; then
    echo "Error: Backing up the filesystem root is not permitted." >&2
    exit 1
fi

mkdir -p -- "$backup_dir"
backup_real=$(realpath -e -- "$backup_dir")

if [[ "$backup_real" == "$source_real" || "$backup_real" == "$source_real/"* ]]; then
    echo "Error: Backup directory must not be the source directory or a directory inside it." >&2
    exit 1
fi

source_parent=$(dirname -- "$source_real")
source_name=$(basename -- "$source_real")
timestamp=$(date '+%Y%m%d_%H%M%S')

archive="$backup_real/${source_name}_${timestamp}.tar.gz"
tmp_archive=$(mktemp "$backup_real/.backup_tmp.XXXXXX")

cleanup() {
    if [[ -n "${tmp_archive:-}" && -e "$tmp_archive" ]]; then
        rm -f -- "$tmp_archive"
    fi
}

trap cleanup EXIT

printf 'Creating backup of: %s\n' "$source_real"
printf 'Backup destination: %s\n' "$archive"

tar -czf "$tmp_archive" -C "$source_parent" -- "$source_name"

echo "Verifying backup archive..."

if ! tar -tzf "$tmp_archive" >/dev/null; then
    echo "Error: Backup archive verification failed." >&2
    exit 1
fi

# Create the final archive name without replacing an existing file.
# The temporary file and final archive are in the same directory.
if ! ln -- "$tmp_archive" "$archive"; then
    echo "Error: Could not publish backup. The destination may already exist." >&2
    exit 1
fi

rm -f -- "$tmp_archive"
tmp_archive=""

printf '\nBackup completed and verified successfully.\n'
printf 'Archive: %s\n' "$archive"
printf 'Size: %s\n' "$(du -h -- "$archive" | awk '{print $1}')"
