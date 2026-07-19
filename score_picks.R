#!/usr/local/bin/Rscript

library(googlesheets4)
library(googledrive)
library(dplyr)
library(tidyr)
library(readr)
library(purrr)
library(purrr)


# read the data
options(gargle_oauth_email = TRUE)
drive_auth(email = TRUE)

# Calificar la ronda 1
GS1_picks <- read_csv("GS1_picks.csv")

matches <- drive_find(pattern = "matches_wc2026",type = "spreadsheet",n_max=1)$id


matches <- read_sheet(matches) %>%
  filter(complete.cases(.)) %>% 
  mutate(match_score = paste(Goals_Local,Goals_Visitor,sep = "-"),
    GD = abs(Goals_Local - Goals_Visitor))



GS1_picks2 <- select(GS1_picks,-c(1,2))


GS1 <- matches %>%
  filter (Round == "M1") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 

attach(GS1_picks)

match_names <- names(GS1_picks2)[1:length(GS1)] 
  
# temporalmente se dejará asi
GS1_all <- map_dfc(1:length(GS1),~if_else( GS1[.x] == GS1_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)

GS1 <- rowSums(GS1_all)

scores_GS1 <- data.frame(Participant_ID,Name,GS1_all)

# Calificar la ronda 2
GS2_picks <- read_csv("GS2_picks.csv")

matches <- drive_find(pattern = "matches_wc2026",type = "spreadsheet",n_max=1)$id


matches <- read_sheet(matches) %>%
  filter(complete.cases(.)) %>% 
  mutate( Score = paste(Goals_Local,Goals_Visitor,sep = "-"),
    GD = abs(Goals_Local - Goals_Visitor))



GS2_picks2 <- select(GS2_picks,-c(1,2))


GS2 <- matches %>%
  filter (Round == "M2") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 

attach(GS2_picks)

match_names <- names(GS2_picks2)[1:length(GS2)] 

# temporalmente se dejará asi
GS2_all <- map_dfc(1:length(GS2),~if_else( GS2[.x] == GS2_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)

GS2 <- rowSums(GS2_all)

scores_GS2 <- data.frame(Participant_ID,GS2_all)


# Score round 3

GS3_picks <- read_csv("GS3_picks.csv")

matches <- drive_find(pattern = "matches_wc2026",type = "spreadsheet",n_max=1)$id


matches <- read_sheet(matches) %>%
  filter(complete.cases(.)) %>% 
  mutate( Score = paste(Goals_Local,Goals_Visitor,sep = "-"),
    GD = abs(Goals_Local - Goals_Visitor))



GS3_picks2 <- select(GS3_picks,-c(1,2))


GS3 <- matches %>%
  filter (Round == "M3") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 



match_names <- names(GS3_picks2)[1:length(GS3)] 

# temporalmente se dejará asi
GS3_all <- map_dfc(1:length(GS3),~if_else( GS3[.x] == GS3_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)

GS3 <- rowSums(GS3_all)

scores_GS3 <- data.frame(Participant_ID,GS3_all)



# Scores K16 


K16_picks <- read_csv("K16_picks.csv")




K16_picks2 <- select(K16_picks,-c(1,2))


K16 <- matches %>%
  filter (Round == "KO32") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 



match_names <- names(K16_picks2)[1:length(K16)] 

# temporalmente se dejará asi
K16_all <- map_dfc(1:length(K16),~if_else( K16[.x] == K16_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)

K16 <- rowSums(K16_all)

scores_K16 <- data.frame(Participant_ID,K16_all)


# score the goals

K16_real_scores <- matches %>% 
  filter(Round == "KO32") %>% 
  select(Score) %>%
  as_vector() %>% 
  unlist() %>%
  unname()


K16_predicted_scores <- read_csv("K16_predicted_scores.csv") %>% 
  arrange(Participant_ID) %>% 
  select(-Participant_ID) %>% 
  select(1:length(K16_real_scores))

K16_predicted_scores

K16_bonus_full <- map2_df(.x = K16_predicted_scores,K16_real_scores,~if_else(.x ==.y,true = 1,0)) %>% 
  bind_cols(select(scores_K16,Participant_ID),.) %>%
  tibble()



K16_bonus <- K16_bonus_full %>%
  select(-1) %>% 
  rowSums()

# Scores KO8 


KO8_picks <- read_csv("K08_picks.csv")




KO8_picks2 <- select(KO8_picks,-c(1,2))


KO8 <- matches %>%
  filter (Round == "KO16") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 



match_names <- names(KO8_picks2)[1:length(KO8)] 

# temporalmente se dejará asi
KO8_all <- map_dfc(1:length(KO8),~if_else( KO8[.x] == KO8_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)

KO8 <- rowSums(KO8_all,na.rm = T)

scores_KO8 <- data.frame(Participant_ID,KO8_all)


# Scores KO8 


KO8_picks <- read_csv("KO8_picks.csv")

KO8_real_scores <- matches %>% 
  filter(Round == "KO16") %>% 
  select(Score) %>%
  as_vector() %>% 
  unlist() %>%
  unname()

KO8_predicted_scores <- read_csv("K08_predicted_scores.csv") %>% 
  arrange(Participant_ID) %>% 
  select(-Participant_ID) %>% 
  select(1:length(KO8_real_scores))

KO8_predicted_scores

KO8_bonus_full <- map2_df(.x = KO8_predicted_scores,KO8_real_scores,~if_else(.x ==.y,true = 1,0)) %>% 
  bind_cols(select(scores_KO8,Participant_ID),.) %>%
  tibble()



KO8_bonus <- KO8_bonus_full %>%
  select(-1) %>% 
  rowSums(na.rm = T)

# Scores QF 


QF_picks <- read_csv("QF_picks.csv")




QF_picks2 <- select(QF_picks,-c(1,2))


QF <- matches %>%
  filter (Round == "QF") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 



match_names <- names(QF_picks2)[1:length(QF)] 

# temporalmente se dejará asi
QF_all <- map_dfc(1:length(QF),~if_else( QF[.x] == QF_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)

QF <- rowSums(QF_all,na.rm = T)
QF2 <- data.frame(Participant_ID = QF_picks$Participant_ID,QF)
QF <- QF2
rm(QF2)

scores_QF <- data.frame(Participant_ID = QF_picks$Participant_ID,QF_all)


# Scores QF 


QF_picks <- read_csv("QF_picks.csv")

QF_real_scores <- matches %>% 
  filter(Round == "QF") %>% 
  select(Score) %>%
  as_vector() %>% 
  unlist() %>%
  unname()

QF_predicted_scores <- read_csv("QF_predicted_scores.csv") %>% 
  arrange(Participant_ID) %>% 
  select(-Participant_ID) %>% 
  select(1:length(QF_real_scores))

QF_predicted_scores

QF_bonus_full <- map2_df(.x = QF_predicted_scores,QF_real_scores,~if_else(.x ==.y,true = 1,0)) %>% 
  bind_cols(select(scores_QF,Participant_ID),.) %>%
  tibble()



QF_bonus <- QF_bonus_full %>%
  select(-1) %>% 
  rowSums(na.rm = T) %>% 
  bind_cols(select(QF_bonus_full,Participant_ID),.) %>%
  purrr::set_names("Participant_ID","QF_bonus")

QF <- full_join(QF,QF_bonus)

# Scores SF 


SF_picks <- read_csv("SF_picks.csv")




SF_picks2 <- select(SF_picks,-c(1,2))


SF <- matches %>%
  filter (Round == "SF") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 



match_names <- names(SF_picks2)[1:length(SF)] 

# temporalmente se dejará asi
SF_all <- map_dfc(1:length(SF),~if_else( SF[.x] == SF_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)

SF <- rowSums(SF_all,na.rm = T)
SF2 <- data.frame(Participant_ID = SF_picks$Participant_ID,SF)
SF <- SF2
rm(SF2)

scores_SF <- data.frame(Participant_ID = SF_picks$Participant_ID,SF_all)


# Scores SF 


SF_picks <- read_csv("SF_picks.csv")

SF_real_scores <- matches %>% 
  filter(Round == "SF") %>% 
  select(Score) %>%
  as_vector() %>% 
  unlist() %>%
  unname()

SF_predicted_scores <- read_csv("SF_predicted_scores.csv") %>% 
  arrange(Participant_ID) %>% 
  select(-Participant_ID) %>% 
  select(1:length(SF_real_scores))

SF_predicted_scores

SF_bonus_full <- map2_df(.x = SF_predicted_scores,SF_real_scores,~if_else(.x ==.y,true = 1,0)) %>% 
  bind_cols(select(scores_SF,Participant_ID),.) %>%
  tibble()



SF_bonus <- SF_bonus_full %>%
  select(-1) %>% 
  rowSums(na.rm = T) %>% 
  bind_cols(select(SF_bonus_full,Participant_ID),.) %>%
  purrr::set_names("Participant_ID","SF_bonus")

SF <- full_join(SF,SF_bonus)

# Scores F 


F_picks <- read_csv("F_picks.csv")




F_picks2 <- select(F_picks,-c(1,2))


Fr<- matches %>%
  filter (Round == "F") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 



match_names <- names(F_picks2)[1:length(Fr)] 

# temporalmente se dejará asi
F_all <- map_dfc(1:length(Fr),~if_else( Fr[.x] == F_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)

Fr <- rowSums(F_all,na.rm = T)
F2 <- data.frame(Participant_ID = F_picks$Participant_ID,Fr)
Fr <- F2
rm(F2)

scores_F <- data.frame(Participant_ID = F_picks$Participant_ID,F_all)


# Scores F 


F_picks <- read_csv("F_picks.csv")

F_real_scores <- matches %>% 
  filter(Round == "F") %>% 
  select(Score) %>%
  as_vector() %>% 
  unlist() %>%
  unname()

F_predicted_scores <- read_csv("F_predicted_scores.csv") %>% 
  arrange(Participant_ID) %>% 
  select(-Participant_ID) %>% 
  select(1:length(F_real_scores))

F_predicted_scores

F_bonus_full <- map2_df(.x = F_predicted_scores,F_real_scores,~if_else(.x ==.y,true = 1,0)) %>% 
  bind_cols(select(scores_F,Participant_ID),.) %>%
  tibble()



F_bonus <- F_bonus_full %>%
  select(-1) %>% 
  rowSums(na.rm = T) %>% 
  bind_cols(select(F_bonus_full,Participant_ID),.) %>%
  purrr::set_names("Participant_ID","F_bonus")

Fr <- full_join(Fr,F_bonus)

### Escribir el output
scores <- data.frame(Participant_ID,Name, GS1,GS2,GS3,K16,K16_bonus,KO8,KO8_bonus) %>%
  full_join(QF) %>%
  full_join(SF) %>%
  full_join(Fr) %>%
  group_by (Participant_ID)  %>%
  mutate(Total = sum(GS1,GS2,GS3,K16,K16_bonus,KO8,KO8_bonus,QF,QF_bonus,SF,SF_bonus,Fr,F_bonus,na.rm = T)) %>%
  ungroup %>%
  arrange(desc(Total),Participant_ID) 






write.table(scores,"Overall_scores.csv",quote = F,sep=",",row.names = F)

write.table(scores_GS1, "GS1_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )

write.table(scores_GS2, "GS2_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )

write.table(scores_GS3, "GS3_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )



write.table(scores_K16, "K16_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )

