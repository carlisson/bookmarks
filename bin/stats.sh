#!/bin/bash

BPATH="$(realpath "$(dirname ${BASH_SOURCE[0]})/..")"

PAGES=$(ls $BPATH/[a-z]*.md | wc -l)
SECTS=$(grep "^## " $BPATH/[a-z]*.md | wc -l)
LINKS=$(grep http $BPATH/[a-z]*.md | wc -l)
BRALL=$(grep http $BPATH/br-*.md | wc -l)

printf "Bookmarks stats: %s bookmark pages; %s sections; %s links; %s brazilian-portuguese links.\n" $PAGES $SECTS $LINKS $BRALL
