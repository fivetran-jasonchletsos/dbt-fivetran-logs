#!/bin/bash
# Script to convert a private key file to the format needed for .nao.env
# Usage: ./scripts/convert_key_to_env.sh /path/to/your/private_key.pem

if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_private_key_file>"
    echo "Example: $0 ~/Downloads/rsa_key.pem"
    exit 1
fi

KEY_FILE=$1

if [ ! -f "$KEY_FILE" ]; then
    echo "Error: File '$KEY_FILE' not found!"
    exit 1
fi

echo "Converting private key to .nao.env format..."
echo ""
echo "Copy the following line to your .nao.env file:"
echo "================================================"
echo -n 'SNOWFLAKE_PRIVATE_KEY="'
cat "$KEY_FILE" | tr -d '\n' | sed 's/-----BEGIN PRIVATE KEY-----/-----BEGIN PRIVATE KEY-----\\n/g' | sed 's/-----END PRIVATE KEY-----/\\n-----END PRIVATE KEY-----/g'
echo '"'
echo "================================================"
echo ""
echo "Or simply run:"
echo "  cat $KEY_FILE"
echo "And copy the entire output (including BEGIN/END lines) into .nao.env"
