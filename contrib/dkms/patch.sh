#!/bin/bash
set -e

# Get the major and minor version from uname
VERSION=$(uname -r | cut -d. -f1,2)

# Ask the user to confirm the detected version
read -p "The detected version is $VERSION. Type 'yes' to confirm and continue: " RESPONSE

# If the user types 'yes', continue; otherwise, stop the script
if [ "$RESPONSE" != "yes" ]; then
    echo "Aborting."
    exit 1
fi

echo "Patching for kernel ${VERSION}"

wget "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/scsi/hpsa.h?h=linux-${VERSION}.y" -O hpsa.h
wget "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/scsi/hpsa.c?h=linux-${VERSION}.y" -O hpsa.c
wget "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/scsi/hpsa_cmd.h?h=linux-${VERSION}.y" -O hpsa_cmd.h

shopt -s nullglob
for PATCH in ../../kernel/"${VERSION}"*/*.patch; do
    echo "Applying ${PATCH}"
    patch --no-backup-if-mismatch -Np3 < "${PATCH}"
done
