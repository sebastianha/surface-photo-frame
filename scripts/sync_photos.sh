#!/usr/bin/env bash

# Load config
source $HOME/.bilderrahmen.env

BASEURL="${LYCHEE_BASEURL}"
AUTHTOKEN="${LYCHEE_AUTHTOKEN}"
ALBUMNAME="${LYCHEE_ALBUMNAME}"
TARGETDIR="${IMPRESSIVE_PHOTODIR}"

# Get album ID for album name, if there are multiple with the same name select first
ALBUMID="`curl -s --data \"{}\" -H \"Content-Type: application/json\" -H \"Accept: application/json\" -H \"Authorization: ${AUTHTOKEN}\" \"${BASEURL}api/Albums::get\" | jq -r \".albums[]|select(.title == \\\"${ALBUMNAME}\\\")|.id\" | head -n 1`"

# Get md5sum of last download
LASTMD5SUMFILE="${LYCHEE_ALBUM_MD5}"
LASTMD5SUM="`cat ${LASTMD5SUMFILE} | cut -d " " -f 1`"

# Get current md5sum of album
MD5SUM=`curl -s -H "Authorization: ${AUTHTOKEN}" "${BASEURL}api/Album::get?albumIDs=${ALBUMID}" --header 'Accept: application/json' --header 'Content-Type: application/json' --data "{\"albumID\": \"${ALBUMID}\"}" | jq -r '.photos[]|.id' | sort | md5sum | cut -d " " -f 1`


# Compare md5sums and exit if identical
[[ "${LASTMD5SUM}" == "${MD5SUM}" ]] && exit 0


# Prepare tmp download dir
TMPOUTDIR="/tmp/photosync/"
rm -rf ${TMPOUTDIR}
mkdir -p ${TMPOUTDIR}

# Download album as zip
curl -s -H "Authorization: ${AUTHTOKEN}" "${BASEURL}api/Album::getArchive?albumIDs=${ALBUMID}"   -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' --output "${TMPOUTDIR}/download.zip"

# Unzip album
unzip "${TMPOUTDIR}/download.zip" -d "${TMPOUTDIR}"


# Exit if zip is not complete or broken
[[ $? != 0 ]] && exit 1

# Create photo dir if not existing
mkdir -p ${TARGETDIR}

# Delete current photos
rm ${TARGETDIR}/*

# Move new photos to photodir
mv ${TMPOUTDIR}/${ALBUMNAME}/* ${TARGETDIR}

# Store current md5sum in file
echo ${MD5SUM} > ${LASTMD5SUMFILE}

# Cleanup tmp dir
rm -rf "${TMPOUTDIR}"

# Only restart if impressive is running
pgrep -x impressive &>/dev/null && /home/user/bin/restart.sh

