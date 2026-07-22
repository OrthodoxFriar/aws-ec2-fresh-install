#!/usr/bin/env bash
#
# pull_from_s3.sh
# Fetch the latest aws-ec2-fresh-install tree from S3 into the current directory.
# Intended to be run on a fresh EC2 instance to bootstrap the environment.
#
# Usage:
#   ./pull_from_s3.sh my-bucket-name [optional-prefix]
#
# Example:
#   ./pull_from_s3.sh my-bootstrap-bucket aws-ec2-fresh-install
#

set -euo pipefail

BUCKET="${1:-}"
PREFIX="${2:-aws-ec2-fresh-install}"

if [[ -z "$BUCKET" ]]; then
    echo "Usage: $0 <bucket-name> [prefix]"
    echo "Example: $0 my-bootstrap-bucket aws-ec2-fresh-install"
    exit 1
fi

DEST_DIR="$(pwd)/aws-ec2-fresh-install"

echo "Pulling s3://$BUCKET/$PREFIX/ into $DEST_DIR ..."

mkdir -p "$DEST_DIR"
aws s3 sync "s3://$BUCKET/$PREFIX/" "$DEST_DIR/"

echo "Done. Files are in: $DEST_DIR"
echo "Run: cd $DEST_DIR && chmod +x *.sh && ./software.sh"
