library(ggplot2)
library(bayesplot)
library(corrplot)

heart <- read.csv(file = 'data/heart_failure_clinical_records_dataset.csv')
head(heart)

ggplot(heart, aes(x=age)) + geom_histogram(aes(fill=as.character(sex)), bins = 30) + labs(fill = "Sex")

ggplot(heart, aes(x=age)) + geom_histogram(aes(fill=as.character(DEATH_EVENT)), bins = 30) + labs(fill = "Death")

ggplot(heart, aes(x=creatinine_phosphokinase)) + geom_histogram(aes(fill=as.character(DEATH_EVENT)), bins = 30) + labs(fill = "Death")

ggplot(heart, aes(x=ejection_fraction)) + geom_histogram(aes(fill=as.character(DEATH_EVENT)), bins = 30) + labs(fill = "Death")

ggplot(heart, aes(x=platelets)) + geom_histogram(aes(fill=as.character(DEATH_EVENT)), bins = 30) + labs(fill = "Death")

ggplot(heart, aes(x=serum_creatinine)) + geom_histogram(aes(fill=as.character(DEATH_EVENT)), bins = 30) + labs(fill = "Death")


pred <- c("high_blood_pressure", "age", "sex", "creatinine_phosphokinase", "diabetes", "ejection_fraction", "platelets", "serum_creatinine", "serum_sodium", "smoking", "anaemia") 
target <- c("DEATH_EVENT")
#formula <- paste("DEATH_EVENT ~", paste(pred, collapse = "+"))
p <- length(pred)
n <- nrow(heart)
x = cor(heart[, c(target,pred)]) 
corrplot(x)

model <- lm(DEATH_EVENT~age+ejection_fraction+serum_creatinine+serum_sodium, data = as.data.frame(heart))

## all oveall diagnostic measures and eigenvalues with intercept
od<-omcdiag(model)

## all oveall diagnostic measures and eigenvalues without intercept
omcdiag(model, Inter=FALSE)

## all oveall diagnostic measures and eigenvalues with intercept
## with different determinant and confidence level threshold

omcdiag(model, detr=0.001, conf=0.99)

## returns the determinant of correlation matrix |X'X|
omcdiag(model)[1]

## plot with default threshold of VIF and Eigenvalues with intercept
mc.plot(model, vif=10, ev = 0.1)

#PRIORS ?
# 1 LINEAR MODEL WITH VARIABLE SELECTION
# 2 LINEAR MODEL WITH ALL VARIABLES
# HIERARCHICAL - in the Titanic one a hier. model have been used so we can use that one for reference

# All models with bernoulli outcome (1-0, death or not)
