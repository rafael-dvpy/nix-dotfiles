#!/usr/bin/env bash
# Fetch weather from wttr.in for a specified location
# Replace 'Tokyo' with your city or use geolocation (e.g., 'curl wttr.in/~Tokyo')
curl -s 'wttr.in/Tokyo?format=%t+%C' | tr -s ' ' | sed 's/+//g'
