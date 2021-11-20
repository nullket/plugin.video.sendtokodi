#!/bin/bash
set -e
# Publish the addon to the python2/3 kodi repo. 
# This script needs build-addon to be run shortly before (so the repos are cloned and the addons are built)

REPO_URL=$1
REPO_FOLDER=release_repo
# check if action was triggered in a fork and avoid trying to push. FOR TESTING DISABLED
if [[ $GITHUB_REPOSITORY == "firsttris/plugin.video.sendtokodi" || true ]]; then
    # clone repo
    git clone https://$REPO_URL $REPO_FOLDER
    
    # add the created zip file
    mv plugin.video.sendtokodi-$PLUGIN_VERSION.zip $REPO_FOLDER/plugin.video.sendtokodi/

    # Update repository addon xml (not the plugin addon.xml) to include the latest version of sendtokodi
    # use VERSION for envsubst as the addon.template.xml of the publish repo contains it a template variable. TODO change in release repo and here
    VERSION=PLUGIN_VERSION
    cd $REPO_FOLDER
    envsubst < "addon.template.xml" > "addon.xml"  
    md5sum addon.xml > addon.xml.md5
    # Add new addon zip file and repo addon.xml, its md5 hash file then commit and push
    git add .
    git commit -m "CI Update"
    #git push --force --quiet "https://firsttris:$TOKEN@$REPO_URL" master
    echo "TESTING: WOULD PUSH HERE ABBORTING FOR TEST"
    git status
else 
    echo "Not in the main repo, build will not be published."
fi 
