#!/bin/bash

ZPATH="$(realpath "$(dirname ${BASH_SOURCE[0]})/..")"

PAGES="$(cat "$ZPATH/README.md" | grep pages/.*\.md | sed 's/\(.*\)pages\(.*\).md\(.*\)/pages\2.md/g')"

_NOW=$(date +%s)
_LEVEL=0

# @description Returns identation
_tab() {
    printf '\t%.0s' $(seq 1 $_LEVEL)
}

# @description Echo with identation
# @arg $1 string Text to print
techo() {
    _tab
    echo $*
}

# @description Prints a header
# @arg $1 string Text to print
mkhead() {
    techo "<DT><H3 ADD_DATE=\"$_NOW\" LAST_MODIFIED=\"$_NOW\">$*</H3>"
    techo "<DL><p>"
    _LEVEL=$((_LEVEL+1))
}

# @description Prints a subheader
# @arg $1 string Text to print
mkshead() {
    mkhead "$*"
}

# @description Prints a bookmark entry
# @arg $1 string URL
# @arg $2 string Title for bookmark
mkentry() {
    EURL=$1
    shift
    techo "<DT><A HREF=\"$EURL\" ADD_DATE=\"$_NOW\" LAST_MODIFIED=\"$_NOW\" >$*</A>"
}

# @description Close a header or subheader
headend() {
    _LEVEL=$((_LEVEL-1))
    techo "</DL><p>"
}

# @description Close all internal headers
# @arg $1 int Target level. (default=0)
closelevel() {
    local _TL
    if [ $# -eq 1 ]
    then
        _TL=$1
    else
        _TL=0
    fi
    while [ $_LEVEL -gt $_TL ]
    do
        headend
    done
}

# @description Process a markdown page
# @arg $1 string Path page
process_page() {
    
    closelevel
    local PAG="$1"
    local PPH PPL PPLL AU AT P PPLDE PPLDP
    mkhead $(cat "$PAG" | grep "^# " | sed 's/^# //g')
    while IFS= read -r line; do
        PPH=$(echo $line | grep -s "^## ")
        if [ $? -eq 0 ]
        then
            closelevel 1
            line=$(echo $PPH | sed 's/^## //g')
            mkshead "$line"
        fi
        PPL=$(echo $line | grep "^| ")
        if [ $? -eq 0 ]
        then
            echo $PPL | grep -s 'http' > /dev/null
            if [ $? -eq 0 ]
            then
                P=2
                PPLL=$(echo "$PPL" | cut -d\| -f $P)
                echo $PPLL | grep -s 'http' > /dev/null
                if [ $? -gt 0 ]
                then
                    P=3
                    PPLL=$(echo "$PPL" | cut -d\| -f$P)
                fi
                PPLL=$(echo $PPLL | tr '[]' '||')
                AT=$(echo "$PPLL" | cut -d\| -f 2)
                AU=$(echo "$PPLL" | cut -d\| -f 3 | tr '()' '||' | cut -d\| -f 2)
                PPLDE=$(echo "$PPL" | cut -d\| -f$((P+1)))
                PPLDP=$(echo "$PPL" | cut -d\| -f$((P+2)))
                mkentry $AU "$AT"
                echo $PPLL >> /tmp/debug.txt
            fi
        fi
    done < "$PAG"
}

techo "<!DOCTYPE NETSCAPE-Bookmark-file-1>"
techo "<!-- This is an automatically generated file."
techo "     It will be read and overwritten."
techo "     DO NOT EDIT! -->"
techo "<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">"
techo "<meta http-equiv=\"Content-Security-Policy\""
techo "      content=\"default-src 'self'; script-src 'none'; img-src data: *; object-src 'none'\"></meta>"
techo "<TITLE>Bookmarks</TITLE>"
techo "<H1>Bookmarks by cordeis</H1>"
techo "<DL><p>"
techo "    <DT><H3 ADD_DATE=\"$_NOW\" LAST_MODIFIED=\"$_NOW\" PERSONAL_TOOLBAR_FOLDER=\"true\">My Bookmarks</H3>"
techo "    <DL><p>"


pushd $ZPATH > /dev/null
for PAGE in $PAGES
do
    process_page "$PAGE"
done
popd > /dev/null
closelevel

echo '</DL><p>
</DL>'
