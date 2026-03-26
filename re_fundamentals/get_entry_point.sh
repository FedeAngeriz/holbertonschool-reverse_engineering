#!/bin/bash

source ./messages.sh

file_name=$1

# Validate argument
if [ -z "$file_name" ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

# Check if file exists
if [ ! -f "$file_name" ]; then
    echo "Error: File does not exist."
    exit 1
fi

# Check if ELF
if ! file "$file_name" | grep -q "ELF"; then
    echo "Error: Not a valid ELF file."
    exit 1
fi

# Read ELF header (force English)
elf_header=$(LC_ALL=C readelf -h "$file_name")

# Extract values
magic_number=$(echo "$elf_header" | grep "Magic" | cut -d ":" -f2 | xargs)

class=$(echo "$elf_header" | grep "Class" | cut -d ":" -f2 | xargs)

byte_order=$(echo "$elf_header" | grep "Data" | cut -d "," -f2 | xargs)

entry_point_address=$(echo "$elf_header" | grep "Entry point address" | cut -d ":" -f2 | xargs)

# Display
display_elf_header_info