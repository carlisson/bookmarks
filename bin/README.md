# Scripts for Bookmarks

Every script in this folder is a shellscript in Bash, used in GNU/Linux.

## fixfiles.sh

It ensures that all Markdown pages end with a line break.

Usage: from bookmarks/ directory, run `bin/fixfiles.sh`

## mkhtml.sh

It creates a HTML file that can be imported by Firefox or other web browser (tested only in Firefox).

Usage: from bookmarks/ directory, run `bin/mkhtml.sh > FILE`, replacing **FILE** to desired file name (ex.: bookmarks.html).

## stats.sh

It counts pages and links in Bookmarks project.

Usage: from bookmarks/ directory, run `bin/stats.sh`;