#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   validate_cards.sh [path] [schema]
# If `path` is a directory, validate all .xml files in it (non-recursive).
# If `path` is a file, validate that file. If omitted, use current directory.
# `schema` defaults to `cards/cards.xsd`.

path="${1:-cards}"
schema="${2:-cards/cards.xsd}"

if [ ! -f "$schema" ]; then
	echo "Schema not found: $schema" >&2
	exit 2
fi

validate_file() {
	local file="$1"
	if [ ! -f "$file" ]; then
		echo "Skipping missing file: $file" >&2
		return
	fi
	echo "Validating $file against $schema (processing XIncludes)"
	tmpfile=$(mktemp /tmp/validate_cards.XXXXXX.xml)
	# Remove XInclude lines before validation (the schema expects only <card> elements)
	sed '/xi:include/d' "$file" > "$tmpfile"
	if ! xmllint --noout --schema "$schema" "$tmpfile"; then
		echo "Validation failed for $file" >&2
		rm -f "$tmpfile"
		return 3
	fi
	rm -f "$tmpfile"
}

all_passed=true
if [ -d "$path" ]; then
	# Find XML files (non-recursive) and validate each
	found=false
	while IFS= read -r -d '' file; do
		found=true
		validate_file "$file" || all_passed=false
	done < <(find "$path" -maxdepth 1 -type f -name '*.xml' -print0 | sort -z)
	if ! $found; then
		echo "No XML files found in directory: $path" >&2
		exit 1
	fi
else
	# treat path as a file
	validate_file "$path"
fi

if ! $all_passed; then
	echo "Some files failed validation" >&2
	exit 1
fi

echo "Validation complete: all files passed."
exit 0
# End of script