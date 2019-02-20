#!/bin/bash
# Adds the currently playing iTunes track to a text file for an OBS text label.
#
SONG=`osascript ~/bin/twitch-scripts/iTunesSong.scpt`
echo -e $SONG > ~/Documents/twitch/custom-labels/now-playing.txt

