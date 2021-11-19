#!/bin/bash
set -e

KODI_VERSION=$1


# check if version bump failed (will be "undefined" according to mathieudutour/github-tag-action@v5.6)
if [[ "$VERSION" == "undefined" ]]; then
    echo "Failed to bump version. Abborting build."
    exit 190
fi

# based on the targeting kodi version different adjustments must be made. Further information here: https://kodi.wiki/view/Addon.xml
case $KODI_VERSION in
  "Leia")
    echo -n "TODO"
    ;;

  "Matrix" | "Nexus")
    echo -n "TODO"
    ;;

  *)
    echo -n "Unknown kodi version as traget. Aborting."
    exit 191
    ;;
esac



# package addon
envsubst < "$REPO_NAME/$ADDON_NAME/addon.template.xml" > "$REPO_NAME/$ADDON_NAME/addon.xml" # addon.xml
cp $REPO_NAME/$ADDON_NAME/addon.xml $ADDON_NAME # copy addon.xml to addon folder
zip -r $REPO_NAME/$ADDON_NAME/$ADDON_NAME-$VERSION.zip $ADDON_NAME -x "*.git*" # create zip