#!/bin/bash
set -e

KODI_TARGET=$1

# check if version bump failed (will be "undefined" according to mathieudutour/github-tag-action@v5.6)
if [[ "$PLUGIN_VERSION" == "undefined" || -z "$PLUGIN_VERSION" ]]; then
    echo "Failed to bump or get version. Abborting build."
    exit 190
fi

# based on the targeting kodi version different adjustments must be made. Further information here: https://kodi.wiki/view/Addon.xml
# xmlstarlet or a python xml wrapper would be more robust than sed
case $KODI_TARGET in
  "Leia")
    echo -n "TODO"
    addon_xml_adjuster.py --plugin-version $PLUGIN_VERSION --xbmc-python "2.26.0"
    build_folder=Leia
    ;;

  "Matrix" | "Nexus")
    addon_xml_adjuster.py --plugin-version $PLUGIN_VERSION --xbmc-python "3.0.0"
    build_folder=Matrix
    ;;
  *)
    echo -n "Unknown kodi version as target. Aborting build."
    exit 191
    ;;
esac

mkdir ../${build_folder}
zip -r ../${build_folder}/plugin.video.sendtokodi-$PLUGIN_VERSION.zip . -x "*.git*" # create zip