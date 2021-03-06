


temp = read.table("temperature.txt", header = TRUE)

## V�rifier le format des donn�es
head(temp)
str(temp)

### Trouver le nombre de r�p�titions dans chaque combinaison
table(temp$Latitude, temp$Precipitation)


### Table anova
temp.anova = aov( Temperature ~ Latitude + Precipitation + Latitude :Precipitation, data = temp)
summary(temp.anova)


#### V�rification de la normalit� des r�sidus
par(mfrow = c(1, 2))
plot(temp.anova)
qqnorm(residuals(temp.anova), main = "Normalit� des r�sidus",
ylab = "Quantiles observ�s",
xlab = "Quantiles th�oriques", cex.lab = 1.2)
qqline(residuals(temp.anova))

plot(residuals(temp.anova) ~ fitted(temp.anova), xlab = "Valeurs pr�dites",
ylab = "R�sidus", cex.lab = 1.2)

### Confirmation de la normalit� des r�sidus
library(nortest)
ad.test(residuals(temp.anova))


### Confirmation de l'homog�n�it� de la variance
library(car)

temp$groupe = c(rep("a",17),rep("b",14),rep("c",17),rep("d",14),rep("e",16),rep("f",15))
leveneTest( Temperature ~ Latitude, data = temp)
leveneTest( Temperature ~ Precipitation, data = temp)
leveneTest( Temperature ~ groupe, data = temp)

### Test de Tukey sur les deux termes
Tukeytest.Latitude = TukeyHSD(temp.anova, which = "Latitude")
Tukeytest.Precipitation = TukeyHSD(temp.anova, which = "Precipitation")



### Moyenne pour groupe
moypre = tapply( X = temp$Temperature, INDEX = temp$Precipitation, FUN = mean)
moylat = tapply( X = temp$Temperature, INDEX = temp$Latitude, FUN = mean)

moypre
moylat

### Graphique pour les differents groupes

### Graphique pour illustrer les diff�rences
library(gplots)


plotmeans(temp$Temperature ~temp$Precipitation, connect = FALSE, n.label = FALSE, 
	ylab = "Temperature moyenne", xlab = "Statut des precipitations", main = "Temperature moyenne par niveau precipitation")

text(x = 1.04, y = 4.58, labels = "a", cex = 1.2)
text(x = 2.04, y = 3.05, labels = "b", cex = 1.2)

plotmeans(temp$Temperature ~temp$Latitude, connect = FALSE, n.label = FALSE, 
	ylab = "Temperature moyenne", xlab = "Latitude", main = "Temperature moyenne par localisation")

text(x = 1.08, y = 3.25, labels = "ab", cex = 1.2)
text(x = 2.05, y = 2.35, labels = "a", cex = 1.2)
text(x = 3.05, y = 5.37, labels = "b", cex = 1.2)





