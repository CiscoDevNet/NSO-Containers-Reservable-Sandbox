#!/bin/bash
set -e
set -x

dir=/tmp/neds
prefix_regex='^ncs-[0-9]+\.[0-9]+\.[0-9]+-'

for file in "$dir"/*.signed.bin; do
	chmod +x "$file"
	base_name=$(basename "$file" .signed.bin)
	name_without_prefix=$(echo "$base_name" | sed -E "s/$prefix_regex//")

	mkdir -p "/tmp/ned/$base_name"
	mkdir -p "$NCS_DIR/packages/neds/$name_without_prefix"

	mv "$file" "/tmp/ned/$base_name"
	cd "/tmp/ned/$base_name"
	./"$base_name.signed.bin" --skip-verification

	# Extract the tarball directly into the desired directory
	tar --strip-components=1 -xzf "$base_name.tar.gz" -C "$NCS_DIR/packages/neds/$name_without_prefix/"
	ln -s "$NCS_DIR/packages/neds/$name_without_prefix" "$NCS_RUN_DIR/packages/$name_without_prefix"
	cd -
done