#!/bin/bash

while read -r org && read -r repo; do
    cd ~/Code/git-sync

    echo "# $org/$repo"

    echo "### Creating repo on gogs"
    json="{\"name\": \"$repo\", \"private\": true}"
    if [[ $org == "rosshettel" ]]; then
        url="https://git.nasa.rosshettel.com/api/v1/user/repos"
    else
        url="https://git.nasa.rosshettel.com/api/v1/org/$org/repos"
    fi
    curl -H "Content-Type: application/json" \
         -H "Authorization: token 4c19089a3e62660981a343e304c6372abd56b9da" \
         -X POST -d "$json" $url

    echo "### Cloning from gitlab"
    git clone -q --mirror gitlab:$org/$repo
    cd $repo.git
    git remote add mirror git:$org/$repo

    echo "### Pushing to gogs"
    git push -q --mirror mirror

done < <(jq -r 'to_entries[] | .key + "\n" + .value[]' <./config.json)
