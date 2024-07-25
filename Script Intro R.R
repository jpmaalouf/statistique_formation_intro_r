####  Ceci est mon premier script R

# Je crée un objet a dans lequel je stocke 6.35
a <- 6.35
a

# Je crée un objet b à partir d'une opération sur a
a+7.8
b <- a+7.8
b

# La fonction sqrt() calcule la racine carrée
Resultat <- sqrt(a) -3*b + a^2
Resultat

# Création d'une chaîne de caractère
Toto <- "I love R"
Toto



#### 2.8 Importation d'un jeu de données en data frame
dataScores <- read.csv2("ScoresEleves.csv", na.strings="")



#### 2.9 Caractérisation d'un data frame

# Afficher les dimensions de dataScores
dim(dataScores)

# Afficher les noms des variables
names(dataScores)
colnames(dataScores)

# Afficher les quelques premières lignes
head(dataScores, 5)

# Afficher les quelques dernières lignes
tail(dataScores, 5)



#### 2.10 Accéder aux différentes parties du data frame

## Accès aux éléments du tableau suivant les numéros
## de lignes/colonnes

# Accéder à la ligne 2 et à la colonne 3
dataScores[2 , 3]

# Accéder à la ligne 2, et à toutes les colonnes
dataScores[2, ]

# Accéder aux lignes 1 à 4, colonne 2
dataScores[1:4, 2]

# Accéder aux lignes 1 à 4, toutes les colonnes SAUF 2
dataScores[1:4, -2]

# Accéder aux lignes 2 et 5, colonnes 6 et 4
dataScores[c(2, 5) , c(6, 4)] # La fonction c() permet de combiner des éléments dans R


## Sélectionner des colonnes suivant leurs intitulés
## avec select{dplyr}
mean(dataScores$Score5)

# Chargement du package dplyr
library(dplyr)

# Sélectionner les colonnes Origine et Score5
select(dataScores, Origine, Score5)

# Sélectionner tout sauf Origine et Score5
select(dataScores, -Origine, -Score5)

# Sélectionner toutes les colonnes dont l'intitulé
# renferme la chaîne de caractère Score
select(dataScores, contains("Score"))


## Sélectionner des lignes suivant des conditions 
## avec filter{dplyr}

# Conserver tous les élèves avec Score4 > 90
filter(dataScores, Score4 > 90)

# Conserver les élèves d'origine O1, Score1 > 50
filter(dataScores, Origine == "O1", Score1 > 50)

# Exclure tous les élèves de l'établissement C
filter(dataScores, Etablissement != "C")



#### 2.11 Trier un data frame avec la fonction arrange{dplyr}
library(dplyr)

# Trier le tableau de données par ordre croissant de Score1
arrange(dataScores, Score1)

# Trier le tableau de données par ordre décroissant de Score1
arrange(dataScores, -Score1)

# Trier le tableau par ordre d'établissement suivi d'un ordre
# décroissant de Score3
arrange(dataScores, Etablissement, -Score3)



#### 2.12 Créer de nouvelles colonnes dans le data frame

## Syntaxe classique
# Créer une colonne incluant les moyennes entre Score4 et Score5
dataScores$MoyenneS4S5 <- (dataScores$Score4 + dataScores$Score5)/2

## Fonction mutate{dplyr}
library(dplyr)
mutate(dataScores, MoyenneS4S5 = (Score4+Score5)/2, 
       MoyenneS1S2 = (Score1+Score2)/2)

## Supprimer une colonne (exemple : Score1)
select(dataScores, -Score1)



#### 2.13 Effectuer un calcul sur chaque colonne automatiquement

## Syntaxe classique :

# Calcul de la moyenne des élèves par score
apply(dataScores[ , 5:9 ], MARGIN = 2, mean)

# Calcul de la moyenne des scores pour chaque élève
apply(dataScores[ , 5:9 ], MARGIN = 1, mean)


## Fonction summarise_all{dplyr} :
library(dplyr)

# Calcul de la moyenne des élèves par score
summarise_all(dataScores[, 5:9], mean)

## Extraire les colonnes numériques d'un data frame
dataScoresNum <- select_if(dataScores, is.numeric)

# Calcul de la moyenne des élèves par score
apply(dataScoresNum, MARGIN = 2, mean)



#### 2.14 Effectuer un calcul groupé avec group_by et summarise{dplyr}
library(dplyr)

## Calculer la moyenne de Score1 par origine

# Etape 1 : créer un regroupement autour d'une variable groupe
groupOrigine <- group_by(dataScores, Origine)

# Etape 2 : Calculer la moyenne de Score1 par origine
summarise(groupOrigine, moyS1 = mean(Score1))

# Il est possible d'enchaîner plusieurs calculs groupés
# dans la fonction summarise
summarise(groupOrigine, moyS1 = mean(Score1),
          moyS2 = mean(Score2))

# Exécuter un calcul groupé sur chaque colonne d'un data frame
summarise_all(groupOrigine, mean)

# Calcul de moyennes par établissement et origine
groupEtabOrigine <- group_by(dataScores, Etablissement, Origine)
ResultatMoyennes <- summarise(groupEtabOrigine, moyS1 = mean(Score1),
          moyS2 = mean(Score2))

# Exporter un data frame au format Excel
library(writexl)
write_xlsx(ResultatMoyennes, "Resultats Moyennes.xlsx")



#### 2.15 Graphiques avec ggplot{ggplot2}
library(ggplot2)

# Construction d'une base graphique
ggplot(data=dataScores, mapping=aes(x=Score1, y=Score5, color=Origine))

# On rajoute un premier calque à la base graphique (points)
ggplot(data=dataScores, mapping=aes(x=Score1, y=Score5, color=Origine))+
  geom_point()

# Enchaînement de calques : exemple 1
ggplot(data=dataScores, mapping=aes(x=Score1, y=Score5, color=Origine))+
  geom_point()+
  geom_smooth(method="lm")+
  ggtitle("Test de la fonction ggplot()")+
  xlab("Score obtenu à l'examen 1")+
  ylab("Score obtenu à l'examen 5")+
  theme_bw()

# Enchaînement de calques : exemple 2
ggplot(data=dataScores, mapping=aes(x=Score1, y=Score5, color=Origine))+
  geom_point()+
  facet_wrap(facets=~Etablissement)+
  scale_color_manual(values=c("red", "darkgreen", "#00008B"))
  
