#!/bin/bash
#

make clean
#git commit -m "rebuilding html"
#git push
make html
git add .
git commit -m "rebuilding html"
git push
