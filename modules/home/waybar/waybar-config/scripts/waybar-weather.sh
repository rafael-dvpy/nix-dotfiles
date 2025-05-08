#!/usr/bin/env bash
CITY="Buzios"
curl -s "wttr.in/$CITY?format=%t+%C" | tr -s ' ' | sed 's/+//g'
