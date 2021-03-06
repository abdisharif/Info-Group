# Setup  ------------------------------------------------------------------
library(dplyr)
library(ggplot2)
library(lintr)
lint("analysis.R")
arrest_information <-
  read.csv("https://raw.githubusercontent.com/mschrier/https-classroom.github.com-a-XrLzm1Hu/main/Arrest_Information.csv")
View(arrest_information)

# arrest_information division by year
arrest_information_2013_all <- filter(arrest_information, X2013 == "2013")
arrest_information_2015_all <- filter(arrest_information, X2013 == "2015")
arrest_information_2017_all <- filter(arrest_information, X2013 == "2017")
arrest_information_2019_all <- filter(arrest_information, X2013 == "2019")
summary(arrest_information_2013_all)
# highest_race_crime_rate_2019
highest_race_crime_rate_2019 <-
  select(arrest_information_2019_all, White, Black.or.African.American,
         American.Indian.or.Alaska.Native,
         Asian, Native.Hawaiian.or.Other.Pacific.Islander)
highest_race_crime_rate_2019 <-
  colnames(highest_race_crime_rate_2019)[
    max.col(highest_race_crime_rate_2019, ties.method = "first")]
highest_race_crime_rate_2019 <-
  highest_race_crime_rate_2019[1]

# highest crime type for African Americans in 2013
arrest_information_2013 <- arrest_information_2013_all[-c(1, 29), ]
highest_crime_afri_amer_2013 <-
  as.vector(
    arrest_information_2013[which.max(
      arrest_information_2013$Black.or.African.American), 1])


#highest crime type for African Americans in 2019
arrest_information_2019 <- arrest_information_2019_all[-c(1, 29), ]
highest_crime_afri_amer_2019 <-
  as.vector(
    arrest_information_2019[which.max(
      arrest_information_2019$Black.or.African.American), 1])

# average criminal total for 2013, 2015,2017, and 2019
average_criminal_total <-
  mean(arrest_information_2013_all$Total[1],
       arrest_information_2015_all$Total[1],
       arrest_information_2017_all$Total[1],
       arrest_information_2019_all$Total[1])

# highest crime type for white in 2013
highest_crime_type_white_2013 <-
  as.vector(
    arrest_information_2013[which.max(arrest_information_2013$White), 1])

# highest crime type for white in 2019
highest_crime_type_white_2019 <-
  as.vector(
    arrest_information_2019[which.max(arrest_information_2019$White), 1])

summary <-
  t(data.frame(highest_race_crime_rate_2019,
               highest_crime_afri_amer_2013,
               highest_crime_afri_amer_2019,
               average_criminal_total, highest_crime_type_white_2013,
               highest_crime_type_white_2019))
View(summary)

# Table -------------------------------------------------------------------

table <- group_by(arrest_information, X2013) %>%
  summarise(total_arrest = max(Total),
            black_arrest = max(Black.or.African.American),
            white_arrests = max(White), American_Indian_or_Alaska_Native_arrest
            = max(American.Indian.or.Alaska.Native),
            asian_arrests = max(Asian),
            Native_Hawaiian_or_Other_Pacific_Islander_arrest =
              max(Native.Hawaiian.or.Other.Pacific.Islander))
colnames(table)[1] <- "year"
colnames(table)[2] <- "total arrest"
colnames(table)[3] <- "black arrest"
colnames(table)[4] <- "white arrest"
colnames(table)[5] <- "american indian or alaska native arrest"
colnames(table)[6] <- "asian arrests"
colnames(table)[7] <- "native hawaiian or other pacific islander arrest"
View(table)

# 1st chart ----------------------------
total_arrest <- c(arrest_information_2013_all$Total[1],
                  arrest_information_2015_all$Total[1],
                  arrest_information_2017_all$Total[1],
                  arrest_information_2019_all$Total[1])
year <- c("arrest 2013", "arrest 2015", "arrest 2017", "arrest 2019")

plot <- data.frame(year, total_arrest)
ggplot(plot, aes(x = year, y = total_arrest, group = 1)) +  geom_line(
  linetype = "dashed", color = "red") + geom_point() +  ggtitle(
    "Arrests per Year") + theme(plot.title = element_text(
      hjust = 0.5)) +  ylab("total arrest")

# 2nd chart -------------------------------
plot_2019 <- arrest_information_2019_all[-c(1), c(1, 2)]
colnames(plot_2019)[1] <- "total_arrest"
ggplot(plot_2019, aes(x = total_arrest, y = Total)) + geom_bar(
  stat = "identity") + ggtitle("Arrests in 2019") + theme(
    plot.title = element_text(hjust = 0.5)) + theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) + xlab(
        "Crimes") + ylab("Total Arrest")
