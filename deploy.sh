#! /bin/bash

hexo g
hexo d
git add .
git commit -a -m 'feat: new post'
git push