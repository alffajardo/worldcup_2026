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

#########------------------------
##          GS2
####################################
Rscript generate_picks_GS2.R

echo "
 ## <u>**Group Stage 2 (GS2) Picks**</u>
 
 " >> 02.tmp_gs2.md


gen_markdowntable.sh --csv <  GS2_picks.csv >> 02.tmp_gs2.md


echo "### Plots
<img src="media/picks_GS2.png" alt="picks" width="400"/> " >> 02.tmp_gs2.md

echo "### Picks Similarities

<img src="media/similarities_GS2.png" alt="similarities" width="600"/> 

---" >> 02.tmp_gs2.md



echo "Noticeable players in this round:

" >> 02.tmp_gs2.md
echo >> 02.tmp_gs2.md

gen_markdowntable.sh --csv <  top_GS2.csv >> 02.tmp_gs2.md

#########------------------------
##          GS1
####################################

## GROUP stage one

Rscript generate_picks_GS1.R

echo "
 ## <u>**Group Stage 1 (GS1) Picks**</u>
 
 " >> 01.tmp_gs1.md


gen_markdowntable.sh --csv <  GS1_picks.csv >> 01.tmp_gs1.md


echo "### Plots
<img src="media/picks_GS1.png" alt="picks" width="400"/> " >> 01.tmp_gs1.md

echo "### Picks Similarities

<img src="media/similarities_GS1.png" alt="similarities" width="600"/> 

---" >> 01.tmp_gs1.md



echo "Noticeable players in this round:

" >> 01.tmp_gs1.md
echo >> 01.tmp_gs1.md

gen_markdowntable.sh --csv <  top_GS1.csv >> 01.tmp_gs1.md

### **Critical Matches in this round**

Rscript score_picks.R

echo " ## Total Scores" >> 00.tmp_header.md

gen_markdowntable.sh --csv <  Overall_scores.csv >> 00.tmp_header.md


#### --------------------------------------------------------------------------------------------------------
## ELIMININATORIAS

# ----------------------------------------------------------------------------------------------------- |
# .-----------------------------------------------------------------------------------------------------|


echo "
Tie-Breaker 1 : Which team will win the world cup?

<img src="media/tiebreak_q1.png" alt="tiebreaker_q1" width="400"/> " >> 00.tmp_header.md


echo "
Tie-Breaker 2: How far will Mexico advance in the tournament?

<img src="media/tiebreak_q2.png" alt="tiebreaker_q2" width="400"/> " >> 00.tmp_header.md


echo "
Tie-Breaker 3: How far will Canada advance in the tournament?

<img src="media/tiebreak_q3.png" alt="tiebreaker_q3" width="400"/> 
" >> 00.tmp_header.md
 
cat 00.tmp_header.md 02.tmp_gs2.md 01.tmp_gs1.md > README.md



 rm *tmp*md

# push to remote

git add .
git add "update_readme.sh"
git commit -m "automatic README update"
git push

exit
