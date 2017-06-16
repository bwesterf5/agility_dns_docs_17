#!/bin/bash
#

git rm -r _build/
git commit -m "rebuilding html"
git push
make html
git add .
git commit -m "rebuilding html"
git push
