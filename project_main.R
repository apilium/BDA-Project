library(ggplot2)
library(bayesplot)
library(corrplot)
library(brms)
library(rstanarm)


heart <- read.csv(file = 'data/heart_failure_clinical_records_dataset.csv')
head(heart)

ggplot(heart, aes(x=age)) + geom_histogram(aes(fill=as.character(sex)), bins = 30) + labs(fill = "Sex")

ggplot(heart, aes(x=age)) + geom_histogram(aes(fill=as.character(DEATH_EVENT)), bins = 30) + labs(fill = "Death")

ggplot(heart, aes(x=creatinine_phosphokinase)) + geom_histogram(aes(fill=as.character(DEATH_EVENT)), bins = 30) + labs(fill = "Death")

ggplot(heart, aes(x=ejection_fraction)) + geom_histogram(aes(fill=as.character(DEATH_EVENT)), bins = 30) + labs(fill = "Death")

ggplot(heart, aes(x=platelets)) + geom_histogram(aes(fill=as.character(DEATH_EVENT)), bins = 30) + labs(fill = "Death")

ggplot(heart, aes(x=serum_creatinine)) + geom_histogram(aes(fill=as.character(DEATH_EVENT)), bins = 30) + labs(fill = "Death")

pair <- c("age", "creatinine_phosphokinase", "ejection_fraction", "platelets", "serum_creatinine", "serum_sodium") 
pairs(heart[,pair])

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
test.size <- 0.3
train.indice <- sample(nrow(heart), nrow(heart)*(1-test.size))
train.data <- heart[train.indice,]
test.data <- heart[-train.indice,]

fit <- brm(formula = DEATH_EVENT ~ age + ejection_fraction + serum_creatinine + serum_sodium,
           data = train.data,
           family = bernoulli(),
           prior = set_prior('normal(0, 1000)'),
           refresh=0
)

preds <- round(predict(fit, newdata = test.data))[1]
pred.corr <- preds == test.data$DEATH_EVENT

acc <- length(pred.corr[pred.corr == TRUE])/nrow(test.data)
acc

fit1 <- brm(formula = DEATH_EVENT ~ age + ejection_fraction + serum_creatinine + serum_sodium + high_blood_pressure + creatinine_phosphokinase + diabetes + smoking + anaemia,
           data = train.data,
           family = bernoulli(),
           prior = set_prior('normal(0, 1000)'),
           refresh=0
)

preds1 <- round(predict(fit1, newdata = test.data))[1]
pred1.corr <- preds1 == test.data$DEATH_EVENT

acc <- length(pred1.corr[pred1.corr == TRUE])/nrow(test.data)
acc

#NON LINEAR 
fit_nl <- stan_gamm4(formula = DEATH_EVENT ~ s(age) + s(ejection_fraction) + s(serum_creatinine) + s(serum_sodium),
           data = train.data,
           family = "gaussian",
           refresh=0
)

preds <- round(predict(fit_nl, newdata = test.data))[1]
pred.corr <- preds == test.data$DEATH_EVENT

acc <- length(pred.corr[pred.corr == TRUE])/nrow(test.data)
acc
