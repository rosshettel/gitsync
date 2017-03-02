#!/bin/bash

while read -r folder && read -r origin && read -r mirror; do
    cd /repos

    if [ ! -d "$folder" ]; then
        echo "## Repo $folder doesn't exist, cloning..."
        git clone -q --mirror $origin $folder
        cd $folder
        git remote add mirror $mirror
    else
        echo "## Pulling latest from origin for $folder"
        cd $folder
        git fetch -q --prune origin
        # check errors
    fi

    echo "## Pushing latest to mirror for $folder"
    git push -q --mirror mirror
    # check errors
done < <(jq -r 'to_entries[] | .key, .value.origin, .value.mirror' </config.json)
