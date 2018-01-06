#!/bin/bash


function die()
{
  echo "$*"
  exit 1
}


VERSION=$(sed -n '/"version"/s/^.*: *"\([^"]*\)".*$/\1/p' <info.json)
test -z "$VERSION" && die "No \"version\" entry found in info.json"

NAME=$(sed -n '/"name"/s/^.*: *"\([^"]*\)".*$/\1/p' <info.json)
test -z "$NAME" && die "No \"name\" entry found in info.json"

echo "Creating release $VERSION for mod $NAME"

RELEASE_NAME="${NAME}_${VERSION}"
RELEASE_DIR="/tmp/$RELEASE_NAME"
test -d "$RELEASE_DIR" && (rm -rf "$RELEASE_DIR" || die "Cannot remove old temp release dir $RELEASE_DIR")
mkdir "$RELEASE_DIR" || die "Cannot create temp release dir $RELEASE_DIR"

echo "Copying files into temp release dir $RELEASE_DIR"
find . -name '*.lua' -o -name '*.jpg' -o -name '*.png' -o -name '*.json' -o -name '*.cfg' \
  -o -name 'LICENSE' | cpio -pvd "$RELEASE_DIR" || die "Cannot copy files into $RELEASE_DIR"

RELEASE_ARCHIVE="${NAME}_${VERSION}.zip"
ABS_RELEASE_ARCHIVE="$PWD/$RELEASE_ARCHIVE"

cd /tmp || die "Cannot chdir into /tmp"

echo "Creating zip archive $RELEASE_ARCHIVE"
zip -r "$ABS_RELEASE_ARCHIVE" "$RELEASE_NAME" || die "Cannot create zip archive $ABS_RELEASE_ARCHIVE"

rm -r "$RELEASE_DIR"
echo "done"

