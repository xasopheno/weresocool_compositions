
#!/bin/bash

# Check for an input argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file-to-compress>"
    exit 1
fi

input_file="$1"
output_file="${input_file%.*}" # Remove extension and add suffix

# Remove all whitespace and compress
tr -d " \t\n\r" < "$input_file" | xz -9e -k > "$output_file.xz"

if [ $? -eq 0 ]; then
    echo "Compression successful. Output file: $output_file.xz"
else
    echo "Compression failed."
    exit 2
fi
