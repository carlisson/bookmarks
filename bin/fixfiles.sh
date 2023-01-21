#!/bin/bash

ZPATH="$(realpath "$(dirname ${BASH_SOURCE[0]})/..")"

PAGES="$(cat "$ZPATH/README.md" | grep pages/.*\.md | sed 's/\(.*\)pages\(.*\).md\(.*\)/pages\2.md/g')"

pushd $ZPATH > /dev/null
for PAGE in $PAGES
do
    LC=$(tail -c 1 $PAGE)
    printf "Latest char in %s: %s.\n" $PAGE $LC
    if [ ! -z "$LC" ]
    then
        printf "\n" >> $PAGE
    fi
done
popd > /dev/null

