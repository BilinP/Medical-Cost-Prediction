#library load
library(SignifReg)
library(caTools)
library(caret)
library(car)

#change plot to look 2x2
par(mfrow = c(2, 2))

#loading data
data<- read.csv("insurance.csv")

#Convert Yes to 1 and No to 0
data$smoker <- ifelse(data$smoker == "yes", 1, 0)

#Convery Male to 1 and Female to 0
data$sex <- ifelse(data$sex == "male", 1, 0)

#one hot encoding for region column 
dummy <- dummyVars(~ region, data = data)
encoded_region <- predict(dummy, newdata = data)
encoded_region <- as.data.frame(encoded_region)

# Combine the encoded region data with the rest of the original data (excluding 'region' column)
final_data <- cbind(data[, setdiff(names(data), "region")], encoded_region)

#split the data into train (80%) and test (20%) 
sample <- sample.split(data$charges, SplitRatio = 0.8)
train  <- subset(final_data, sample == TRUE)
test   <- subset(final_data, sample == FALSE)

#make a full model, then do variable selection with SignifReg w/ criterion (AIC and r-adj)
full_model <- lm(charges ~ age + sex + bmi + children + smoker + regionsouthwest+regionsoutheast +regionnortheast , data = train)
summary(full_model)
SignifReg(full_model, alpha = 0.05, direction = "both", criterion = "r-adj")
SignifReg(full_model, alpha = 0.05, direction = "both", criterion = "AIC")
plot(full_model)


#compare the plotsand summary they both outputted
new_model <- lm(charges ~ age + bmi + children + smoker+regionsouthwest+regionsoutheast, data = train)
plot(new_model)
summary(new_model)

#vif of models
vif(new_model)

#Starting transformations
squarecharges <- train$charges ^ 2
squareage <- train$age ^ 2
squarebmi <- train$bmi ^ 2
squarechildren <- train$children ^ 2
lncharges <- log(train$charges)
lnage <- log(train$age)
lnbmi <- log(train$bmi)
rootcharges <- sqrt(train$charges)
rootage <- sqrt(train$age)
rootbmi <- sqrt(train$bmi)
rootchildren <- sqrt(train$children)
cubedcharges <- train$charges ^ 3
cubedage <- train$age ^ 3
cubedbmi <- train$bmi ^ 3
cubedchildren <- train$children ^ 3
trainbmi30 = ifelse(train$bmi >= 30, 1, 0)



#transformation 
agemodel <- lm(charges ~ squareage + bmi + children + smoker + trainbmi30:smoker+regionsouthwest+regionsoutheast, data = train)
model_1 <- lm(rootcharges ~ age + bmi + children + smoker+regionsouthwest+regionsoutheast, data = train)
model_2 <- lm(squarecharges ~ age + bmi + children + smoker+regionsouthwest+regionsoutheast, data = train)
model_3 <- lm(charges ~ age + bmi + children + smoker + trainbmi30:smoker+regionsouthwest+regionsoutheast, data = train)
model01 <- lm(lncharges ~ age + bmi + smoker + children+regionsouthwest+regionsoutheast, data = train)
model02 <- lm(lncharges ~ lnage + bmi + smoker + children+regionsouthwest+regionsoutheast, data = train)
model03 <- lm(cubedcharges ~ age + bmi + smoker + children+regionsouthwest+regionsoutheast, data = train)
model04 <- lm(cubedcharges ~ age + trainbmi30 + smoker + children+regionsouthwest+regionsoutheast, data = train)
model05 <- lm(cubedcharges ~ age + bmi + trainbmi30 + smoker + children+regionsouthwest+regionsoutheast, data = train)
model06 <- lm(cubedcharges ~ age + bmi + trainbmi30 + smoker + bmi:smoker + children+regionsouthwest+regionsoutheast, data = train)
model07 <- lm(cubedcharges ~ lnage + bmi + trainbmi30 + smoker + bmi:smoker + children+regionsouthwest+regionsoutheast, data = train)
model08 <- lm(rootcharges ~ lnage + bmi + trainbmi30 + smoker + bmi:smoker + children+regionsouthwest+regionsoutheast, data = train) # ***
model09 <- lm(rootcharges ~ lnage + lnbmi + trainbmi30 + smoker + trainbmi30:smoker + children + smoker:age+regionsouthwest+regionsoutheast, data = train)
model10 <- lm(cubedcharges ~ lnage + lnbmi + trainbmi30 + children + trainbmi30:smoker + lnage:smoker + bmi*smoker + lnage*lnbmi + smoker+regionsouthwest+regionsoutheast, data = train)
model11 <- lm(cubedcharges ~ cubedchildren + trainbmi30*smoker + lnage:smoker + lnage*bmi+regionsouthwest+regionsoutheast, data = train)
model12 <- lm(cubedcharges ~ cubedchildren + trainbmi30*smoker + lnage:smoker + lnage*trainbmi30+regionsouthwest+regionsoutheast, data = train)


#SKIP THE BELOW AS FOR OTHER MODELS
#################################################################
# Predict house prices for the test dataset
#predicted_cost <- predict(model_7, newdata = test)
#predicted_cost2 <- predict(model_8, newdata = test)
#test$bmi30 <- test$bmi * (test$smoker == "yes")#add to test
#predicted_cost3 <- predict(project2_model, newdata = test)
#test$squareage <- test$age^2 #add to test
#predicted_cost5 <- predict(trans_interaction05, newdata = test) 
#Only include if need bmi30 on test: test$bmi30 = ifelse(test$bmi >= 30, 1, 0)
#Reversing transformations
#predicted_costs_reverse <- (predicted_cost)^2
#predicted_costs2_reverse <- (predicted_cost2)^1/2
##################################################################



#best model based on r-adj score
train$log_charges <- log(train$charges)
test$log_charges <- log(test$charges)
improved_model <- lm(log_charges ~ age * smoker + bmi * smoker + children+regionsouthwest+regionsoutheast, data = train)
predicted_improve <- predict(improved_model, newdata = test) 
reverse_improve <- exp(predicted_improve)


# Check diagnostics for the improved model
summary(improved_model)
plot(improved_model)


#Computing prediction errors
errors <- test$charges - reverse_improve
mse <- mean(errors^2)
rmse <- sqrt(mse)

precentage_errors<- (abs(errors)/test$charges)*100
mape<-mean(precentage_errors)

cat("MSE:", mse, "\n")
cat("RMSE:", rmse, "\n")
cat("MAPE:", mape, "\n")
