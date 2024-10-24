#On utilise deux packages pour nettoyer nos données
library(dplyr) 
library(tidyr) 

# Sales.csv est un peu spécial les données sont mal formatées donc on remet de l'ordre dans ce merdier 
data1 <- read.csv("Sales.csv", sep = "\t", stringsAsFactors = FALSE)

# Les fichiers normaux
data <- read.csv("MediaInvestment.csv", stringsAsFactors = FALSE)
data2 <- read.csv("firstfile.csv", stringsAsFactors = FALSE)
data3 <- read.csv("ProductList.csv", stringsAsFactors = FALSE)
data4 <- read.csv("SpecialSale.csv", stringsAsFactors = FALSE)
data5 <- read.csv("Secondfile.csv", stringsAsFactors = FALSE)
data6 <- read.csv("MonthlyNPSscore.csv", stringsAsFactors = FALSE)

# Afficher les premières lignes pour vérifier que les données sont bien séparées
head(data1)

# Doublons
data <- distinct(data)
data1 <- distinct(data1)
data2 <- distinct(data2)
data3 <- distinct(data3)
data4 <- distinct(data4)
data5 <- distinct(data5)
data6 <- distinct(data6)


data <- replace_na(data, list(
  colonne1 = 0,   # Remplacer 'colonne1' par le nom réel de la colonne
  colonne2 = 0    # Ajouter autant de colonnes que nécessaire
))
data1 <- replace_na(data1, list(
  colonne1 = 0,   # Remplacer 'colonne1' par le nom réel de la colonne
  colonne2 = 0    # Ajouter autant de colonnes que nécessaire
))
data2 <- replace_na(data2, list(
  colonne1 = 0,   # Remplacer 'colonne1' par le nom réel de la colonne
  colonne2 = 0    # Ajouter autant de colonnes que nécessaire
))
data3 <- replace_na(data3, list(
  colonne1 = 0,   # Remplacer 'colonne1' par le nom réel de la colonne
  colonne2 = 0    # Ajouter autant de colonnes que nécessaire
))
data4 <- replace_na(data4, list(
  colonne1 = 0,   # Remplacer 'colonne1' par le nom réel de la colonne
  colonne2 = 0    # Ajouter autant de colonnes que nécessaire
))
data5 <- replace_na(data5, list(
  colonne1 = 0,   # Remplacer 'colonne1' par le nom réel de la colonne
  colonne2 = 0    # Ajouter autant de colonnes que nécessaire
))
data6 <- replace_na(data6, list(
  colonne1 = 0,   # Remplacer 'colonne1' par le nom réel de la colonne
  colonne2 = 0    # Ajouter autant de colonnes que nécessaire
))



# Sauvegarder le CSV nettoyé
write.csv(data, "Media_Investment_Cleaned.csv", row.names = FALSE)
write.csv(data1, "Sales_Cleaned.csv", row.names = FALSE)
write.csv(data2, "firstfile_Cleaned.csv", row.names = FALSE)
write.csv(data3, "ProductList_Cleaned.csv", row.names = FALSE)
write.csv(data4, "SpecialSale_Cleaned.csv", row.names = FALSE)
write.csv(data5, "Secondfile_Cleaned.csv", row.names = FALSE)
write.csv(data6, "MonthlyNPSscore_Cleaned.csv", row.names = FALSE)

