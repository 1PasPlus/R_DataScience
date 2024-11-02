# Charger les bibliothèques nécessaires
library(dplyr)
library(ggplot2)
library(lubridate)

# Charger les données
sales <- read.csv("firstfile_Cleaned.csv", stringsAsFactors = FALSE)
specials <- read.csv("SpecialSale_Cleaned.csv", stringsAsFactors = FALSE)


# Renommer la colonne pour la clarté
colnames(specials)[colnames(specials) == "Date"] <- "SaleDate"

# Convertir les colonnes de date en format Date pour le dataset 'specials'
specials$SaleDate <- as.Date(specials$SaleDate, format = "%m-%d-%Y")
# Vérifier que la conversion est bien effectuée
str(specials)
head(specials)

# Conversion de la colonne Date en format Date pour le dataset 'sales'
sales$Date <- as.Date(sales$Date, format = "%Y-%m-%d")
# Vérifier que la conversion est bien effectuée
str(sales)
head(sales)




# Ajouter une colonne pour indiquer si l'achat a eu lieu durant une période de promotion
sales <- sales %>%
  mutate(OnSale = case_when(
    Sales_name == "No Promotion" ~ "No",
    TRUE ~ "Yes"  # Mettre "Yes" pour toute autre valeur dans Sales_name
  ))
# Vérifier la création de la colonne 'OnSale'
head(sales)




# Créer la colonne 'YearMonth' pour agréger les données par mois et année
sales <- sales %>%
  mutate(YearMonth = format(Date, "%Y-%m"))


# Calculer le nombre total d'unités vendues par mois selon les périodes de soldes ou non
monthly_sales_summary <- sales %>%
  group_by(YearMonth, OnSale) %>%
  summarise(Total_Units_Sold = sum(units, na.rm = TRUE), .groups = "drop")
# Créer le graphique
ggplot(monthly_sales_summary, aes(x = YearMonth, y = Total_Units_Sold, color = OnSale, group = OnSale)) +
  geom_line(size = 1) +
  labs(
    title = "Évolution des Unités Vendues au Fil du Temps selon les Promotions",
    x = "Mois",
    y = "Nombre Total d'Unités Vendues",
    color = "Promotion"
  ) +
  theme_minimal() +
  scale_x_discrete(breaks = unique(monthly_sales_summary$YearMonth)) +  # Afficher chaque mois
  theme(axis.text.x = element_text(angle = 45, hjust = 1))





# Créer une colonne YearMonth à partir de la colonne Date
sales <- sales %>%
  mutate(YearMonth = format(Date, "%Y-%m-01"))  # Formate la date au début du mois


# Calculer le chiffre d'affaires total par mois selon les périodes de soldes ou non
monthly_gmv_summary <- sales %>%
  group_by(YearMonth, OnSale) %>%
  summarise(Total_GMV = sum(gmv_new, na.rm = TRUE), .groups = "drop")

# Convertir YearMonth en format Date pour ggplot
monthly_gmv_summary$YearMonth <- as.Date(monthly_gmv_summary$YearMonth)

# Afficher le graphique
ggplot(monthly_gmv_summary, aes(x = YearMonth, y = Total_GMV, color = OnSale, group = OnSale)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  labs(
    title = "Chiffre d'Affaires (GMV) au Fil du Temps selon les Promotions",
    x = "Mois",
    y = "Chiffre d'Affaires (GMV)",
    color = "Période de Soldes"
  ) +
  scale_x_date(date_labels = "%Y-%m", date_breaks = "1 month") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "top"
  )






# Calculer le pourcentage moyen de remise par mois selon les périodes de soldes ou non
monthly_discount_summary <- sales %>%
  mutate(Discount_Percentage = (product_mrp - gmv_new) / product_mrp * 100) %>%  # Calcul du pourcentage de remise
  group_by(YearMonth, OnSale) %>%
  summarise(Avg_Discount = mean(Discount_Percentage, na.rm = TRUE), .groups = "drop") %>%
  mutate(YearMonth = as.Date(YearMonth))  # Convertir YearMonth en format Date

# Afficher le graphique
ggplot(monthly_discount_summary, aes(x = YearMonth, y = Avg_Discount, color = OnSale, group = OnSale)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  labs(
    title = "Pourcentage Moyen de Remise au Fil du Temps selon les Promotions",
    x = "Mois",
    y = "Pourcentage Moyen de Remise",
    color = "Période de Soldes"
  ) +
  scale_x_date(date_labels = "%Y-%m", date_breaks = "1 month") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "top"
  )




