#!/bin/bash
INPUTLIST="./update-editors-choice-games-inputlist"
DESTFILENAME=../src/app/shared/editors-choice-games.ts

command -v curl >/dev/null 2>&1 || { echo >&2 "This script requires curl but it's not installed.  Aborting."; exit 1; }
command -v jq >/dev/null 2>&1 || { echo >&2 "This script requires jq but it's not installed.  Aborting."; exit 1; }

echo Updating $DESTFILENAME

echo "import { App } from './app.model';"   > $DESTFILENAME
echo                                       >> $DESTFILENAME
echo "export const EDITORSCHOICEGAMES: App[] = [" >> $DESTFILENAME

while read -r line
do
    echo -n "."
    APPID="$line"
    if [ -n "$APPID" ]; then
	
		curl -s https://flathub.org/api/v1/apps/$APPID | jq '.description=""' | jq '.developerName=""' | jq '.projectLicense=""' \
		| jq '.homepageUrl=""'    | jq '.inStoreSinceDate = null' | jq '.currentReleaseDate = null' \
		| jq '.categories = null' | jq 'del(.rating)' | jq 'del(.ratingVotes)' >> $DESTFILENAME

    	echo ","  >> $DESTFILENAME

    fi
done < "$INPUTLIST"

echo "];"     >> $DESTFILENAME

echo
echo File updated successfully

