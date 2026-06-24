#!/usr/local/bin/Rscript

library(googledrive)
library(googlesheets4)
library(corrplot)
library(viridis)
library(png)
library(dplyr)
library(readr)
library(stringr)
library(tidyr)
options(gargle_oauth_email = TRUE)
drive_auth(email = TRUE)

picks_id <- drive_find(type = "spreadsheet",pattern = "WC2026_GS3",
n_max = 1)$id



picks <- read_sheet(picks_id)

picks$Participant_ID <- as.character( as.character(picks$Participant_ID)) %>%
                        str_pad(pad = "0", side = "left", width = 3)

bets <- picks[,c(4,5,6:29)] %>%
tibble() %>%
arrange(Participant_ID)




write.table(bets,"GS2_picks.csv",sep=",",
quote = F,
row.names =F )




# Lets make some stats with the bets

bets2 <- pivot_longer(bets,3:ncol(bets),
                        names_to = "Match",
                        values_to = "Bet") %>%
                        nest(-`Match`)

## Calculate statistics  per game

result_pics <- lapply(1:24,function(x){
    freqs <- bets2$data[[x]]$Bet %>%
    table()
    prop <- prop.table(freqs)
    return(prop)

}) %>%
setNames(bets2$Match)



png("media/picks_GS3.png",width = 20,height = 20,units = "cm",
    res = 196)
par(mfrow = c(6,4),
    mar = c( 3,3,3,3),
    bg = "gray85")




colors <- c("black","tomato3","darkolivegreen")

lapply(1:24, function(x){

    Match <- as.character(x) %>%
        str_pad(side = "left",pad = "0",width = 2) %>%
        paste("flags/matches/Match",.,".png",sep = '')

match_image <- readPNG(Match)
pie(result_pics[[x]],col = colors,
    main = names(result_pics)[x],
   border = "NA",
   cex.main = 1)

}
)
dev.off()

#  veamos quien puede subir of bajar más en la tabla

bets2 <- bets[,3:ncol(bets)]
dims <- dim(bets2)

similarities <- matrix(NA, dims[1],dims[1],
dimnames = list(bets$Participant_ID,bets$Participant_ID))

for (i in 1:nrow(bets2) ){
x <- bets2[i,]
y <- apply(bets2,1,"==",x) %>%
    colSums
similarities[i,] <- y

}


similarities <- similarities / 24 * 100
diag(similarities) <- NA

png(filename = "media/similarities_GS3.png",
    width = 10,height = 10,units = "cm",res = 196)
par = c(bg = "gray85")
corrplot(similarities,
method = "color",
col = plasma(50), diag = F,
addgrid.col = T,tl.col = "Black",
order = "hclust",   main = "Between-players Similarities",
mar = c(1,1,1,1),cex.main = 1,
is.corr = F,
type = "full",
hclust.method = "ward.D",tl.cex = 0.5,
number.digits = 0,cl.cex = 0.5)

dev.off()

delta_participants <- colMeans(similarities,na.rm = T)

bets$delta <- delta_participants

top <- bets %>%
arrange(delta) %>%
select(1:2) %>%
head(n = 5)

write.table(top,"top_GS3.csv", 
    sep = ',', 
    quote = F, 
    row.names = F)



