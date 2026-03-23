#!/bin/bash

while read -r name && read -r origin && read -r mirror; do
    cd /repos

    if [ ! -d "$name" ]; then
        echo "## Repo $name doesn't exist, cloning..."
        git clone -q --mirror "$origin" "$name"
        cd "$name"
        git remote add mirror "$mirror"
    else
        echo "## Pulling latest from origin for $name"
        cd "$name"
        git fetch -q --prune origin
    fi

    echo "## Pushing latest to mirror for $name"
    git push -q --mirror mirror
done < <(jq -r '.repos | to_entries[] | .key, .value.origin, .value.mirror' /config.json)
