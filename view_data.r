# Chargement des packages pour le nettoyage des données
install.packages("dplyr")
library(dplyr)
install.packages("tidyr")
library(tidyr)
install.packages("ggplot2")
library(ggplot2)
install.packages("lubridate")
library(lubridate)

# Chargement des données (vérifiez que les chemins des fichiers sont corrects)
data <- read.csv("Data_cleaned/Media_Investment_Cleaned.csv", stringsAsFactors = FALSE)
data1 <- read.csv("Data_cleaned/Sales_Cleaned.csv", stringsAsFactors = FALSE)
data2 <- read.csv("Data_cleaned/firstfile_Cleaned.csv", stringsAsFactors = FALSE)
data3 <- read.csv("Data_cleaned/ProductList_Cleaned.csv", stringsAsFactors = FALSE)
data4 <- read.csv("Data_cleaned/SpecialSale_Cleaned.csv", stringsAsFactors = FALSE)
data5 <- read.csv("Data_cleaned/Secondfile_Cleaned.csv", stringsAsFactors = FALSE)
data6 <- read.csv("Data_cleaned/MonthlyNPSscore_Cleaned.csv", stringsAsFactors = FALSE)


# Premier graphique : Investissement total au fil du temps
ggplot(data, aes(x = interaction(Year, Month, sep = "-"), y = Total.Investment, group = 1)) +
  geom_line() +
  labs(title = "Investissement total au fil du temps", x = "Année-Mois", y = "Investissement total") +
  theme_minimal()

# Agrégation des investissements par mois et catégorie
monthly_investments <- data %>%
  group_by(Year, Month) %>%
  summarise(
    TV = sum(TV, na.rm = TRUE),
    Digital = sum(Digital, na.rm = TRUE),
    Sponsorship = sum(Sponsorship, na.rm = TRUE),
    Content.Marketing = sum(Content.Marketing, na.rm = TRUE),
    Online.marketing = sum(Online.marketing, na.rm = TRUE),
    Affiliates = sum(Affiliates, na.rm = TRUE),
    SEM = sum(SEM, na.rm = TRUE),
    Radio = sum(Radio, na.rm = TRUE),
    .groups = "drop"
  )

# Transformation des données pour une visualisation plus simple
monthly_investments_long <- pivot_longer(
  monthly_investments,
  cols = c(TV, Digital, Sponsorship, Content.Marketing, Online.marketing, Affiliates, SEM, Radio),
  names_to = "Category",
  values_to = "Investment"
)

# Création de la colonne YearMonth pour l'affichage
monthly_investments_long <- monthly_investments_long %>%
  mutate(YearMonth = paste(Year, Month, sep = "-"))

# Graphique de l'évolution des investissements par catégorie au fil du temps
ggplot(monthly_investments_long, aes(x = YearMonth, y = Investment, color = Category, group = Category)) +
  geom_line() +
  labs(title = "Évolution des Investissements par Catégorie au Fil du Temps", 
       x = "Année-Mois", 
       y = "Investissement Total") +
  theme_minimal() +
  scale_x_discrete(breaks = unique(monthly_investments_long$YearMonth))

# Modèle de régression simple pour prédire le total_gmv en fonction des investissements
marketing_model <- lm(total_gmv ~ TV + Digital + Sponsorship + Content.Marketing + SEM, data = data5)
summary(marketing_model)


# Transformation des dates et calcul de la moyenne du NPS par mois
monthly_nps <- data6 %>%
  mutate(Date = as.Date(Date, format = "%m/%d/%Y"),
         Year = year(Date),
         Month = month(Date)) %>%
  group_by(Year, Month) %>%
  summarise(NPS = mean(NPS, na.rm = TRUE), .groups = "drop")

# Création de la colonne YearMonth
monthly_nps <- monthly_nps %>%
  mutate(YearMonth = paste(Year, Month, sep = "-"))

# Modèle linéaire pour prédire l'équité de marque en fonction des investissements
brand_equity_model <- lm(NPS ~ TV + Digital + Sponsorship, data = data5)
summary(brand_equity_model)

# Sauvegarde des données d'investissement mensuelles
write.csv(monthly_investments, "monthly_investments.csv", row.names = FALSE)

# Graphique de l'évolution du NPS au fil du temps
ggplot(monthly_nps, aes(x = YearMonth, y = NPS, group = 1)) +
  geom_line(color = "blue") +
  labs(title = "Évolution du NPS au fil du temps", x = "Année-Mois", y = "NPS") +
  theme_minimal() +
  scale_x_discrete(breaks = monthly_nps$YearMonth)

