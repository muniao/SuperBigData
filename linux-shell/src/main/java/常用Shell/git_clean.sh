#!/bin/bash

git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -5 | awk '{print$1}')"

git filter-branch --force --index-filter 'git rm -rf --cached --ignore-unmatch BIGFILE' --prune-empty --tag-name-filter cat -- --all

git push origin master --force

rm -rf .git/refs/original/

git reflog expire --expire=now --all

git gc --prune=now
