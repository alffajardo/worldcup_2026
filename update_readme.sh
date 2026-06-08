#!/bin/bash

# hacer git pull
git pull
# Script para generar mas rapido el Readme.md

# -------------------------Header -----------------------------------------------------------------|
# -------------------------------------------------------------------------------------------------|

echo -e "Last time updated: $(date)" > 00.tmp_header.md

echo "# **CANADA-USA-MEXICO FIFA WORLD  CUP**

<p align="center">

<img src="media/worldcup_banner.jpeg" alt="worldcup_banner" width="1000"/>

---
# Welcome

![](https://github.com/alffajardo/worldcup_2026/blob/main/flags/matches/matches.gif)

Results of the FIFA World Cup 2025
---


" >> 00.tmp_header.md




#### --------------------------------------------------------------------------------------------------------
## ELIMININATORIAS

# ----------------------------------------------------------------------------------------------------- |
# .-----------------------------------------------------------------------------------------------------|
# Gather all the files into the read me

cat 00.tmp_header.md  > README.md


 rm *tmp*md

# push to remote

git add .
git add "update_readme.sh"
git commit -m "automatic README update"
git push

exit
