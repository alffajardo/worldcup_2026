#!/bin/bash

# hacer git pull
git pull
# Script para generar mas rapido el Readme.md

# -------------------------Header -----------------------------------------------------------------|
# -------------------------------------------------------------------------------------------------|

echo -e "Last Update: $(date)" > 00.tmp_header.md

echo "# **CANADA-USA-MEXICO FIFA WORLD CUP 2026**

<p align="center">

<img src="media/worldcup_banner.jpeg" alt="worldcup_banner" width="1000"/>

---
# Welcome

![](https://github.com/alffajardo/worldcup_2026/blob/main/flags/matches/matches.gif)

--- 
FIFA World Cup 2026 results
---" >> 00.tmp_header.md

echo " ## Total Scores" >> 00.tmp_header.md

gen_markdowntable.sh --csv <  Overall_scores.csv >> 00.tmp_header.md


#### --------------------------------------------------------------------------------------------------------
## ELIMININATORIAS

# ----------------------------------------------------------------------------------------------------- |
# .-----------------------------------------------------------------------------------------------------|


#########------------------------
##          GS1
####################################

## GROUP stage one

Rscript generate_picks_GS1.R

echo "
 ## <u>**Group Stage 1 (GS1) Picks**</u>
 
 " > 01.tmp_gs1.md


gen_markdowntable.sh --csv <  GS1_picks.csv >> 01.tmp_gs1.md


echo "### Plots

<img src="media/picks_GS1.png" alt="picks" width="400"/> " >> 01.tmp_gs1.md

echo "### Picks Similarities
<img src="media/similarities_GS1.png" alt="similarities" width="600"/> " >> 01.tmp_gs1.md

---

echo "Top 5 players whos position in the table will change the most after this round

" >> 01.tmp_gs1.md

gen_markdowntable.sh --csv <  top_GS1.csv >> 01.tmp_gs1.md

### **Critical Matches in this round**
 
cat 00.tmp_header.md 01.tmp_gs1.md > README.md



 rm *tmp*md

# push to remote

git add .
git add "update_readme.sh"
git commit -m "automatic README update"
git push

exit
