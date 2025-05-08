#!/usr/bin/env bash
# Fetch weather from wttr.in
CITY="Buzios"
curl -s "wttr.in/$CITY?format=%t+%C" | tr -s ' ' | sed 's/+//g'
