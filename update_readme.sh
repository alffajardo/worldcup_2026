#!/bin/bash

# hacer git pull
git pull
# Script para generar mas rapido el Readme.md

# -------------------------Header -----------------------------------------------------------------|
# -------------------------------------------------------------------------------------------------|


echo "# **Quiniela Qatar 2022**
<p align="center">

<img src="media/fifa.jpg" alt="Fifa2022" width="1000"/>

---
## Welcome


Este es el repositorio de la quiniela Qatar 2022. Aqui se publicarán las picks y los resultados de la quiniela.

---


" > 00.tmp_header.md

echo -e "Last time upddated: $(date).

" >> 00.tmp_header.md 






echo " 

[Resultados de la fase de Octavos](KO8_complete_scores.csv)

[Marcadores de la fase de Octavos](KO8_complete_bonus.csv)
 
--- "  >> 02.tmp_Resultados.md

echo " 

[Resultados de la fase de Cuartos](KO4_complete_scores.csv)

[Marcadores de la fase de  Cuartos](KO4_complete_bonus.csv)
 
--- "  >> 02.tmp_Resultados.md

echo " 

[Resultados de las Semifinales](KO2_complete_scores.csv)

[Marcadores de las Seminales ](KO2_complete_bonus.csv)
 
--- "  >> 02.tmp_Resultados.md

echo " 

[Resultados de la Final](KOFinal_complete_scores.csv)

[Marcadores de Final ](KOFinal_complete_bonus.csv)
 
--- "  >> 02.tmp_Resultados.md
#### --------------------------------------------------------------------------------------------------------
## ELIMININATORIAS

# ----------------------------------------------------------------------------------------------------- |
# .-----------------------------------------------------------------------------------------------------|
# Gather all the files into the read me

cat 00.tmp_header.md  02.tmp_Resultados.md 02.tmp_Eliminatoria.md 01.tmp_Grupos.md > README.md


 rm *tmp*md

# push to remote

git add .
git add "update_readme.sh"
git commit -m "automatic README update"
git push

exit
