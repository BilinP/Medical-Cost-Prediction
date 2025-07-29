# Medical Cost Prediction

A statistical modeling project focused on predicting individual medical expenses using demographic and behavioral data. 

## Project Overview

Insurance companies must forecast medical expenses to set premiums that ensure profitability. This project uses regression modeling on the **Medical Cost Personal Dataset**—a dataset derived from U.S. Census demographic statistics—to predict individual medical charges based on factors like age, BMI, smoking status, and more. [Insurance Dataset on Kaggle](https://www.kaggle.com/datasets/mirichoi0218/insurance)

Approach combines variable selection, data transformation, and model diagnostics to build an accurate and interpretable model.


## Objectives

- Identify key predictors of healthcare costs.
- Use multiple linear regression and variable selection techniques to improve model accuracy.
- Apply transformations and interaction terms to enhance performance and meet regression assumptions.
- Evaluate model performance using RMSE and MAPE.

## Dataset Description

The dataset includes 7 variables:

| Variable     | Description                                                                 |
|--------------|-----------------------------------------------------------------------------|
| `age`        | Age of the primary beneficiary                                              |
| `sex`        | Gender of the beneficiary (converted to binary)                             |
| `bmi`        | Body Mass Index                                                             |
| `children`   | Number of dependents covered by insurance                                   |
| `smoker`     | Smoking status (binary: 1 = smoker, 0 = non-smoker)                         |
| `region`     | Region of residence in the U.S. (one-hot encoded into 4 binary variables)   |
| `charges`    | Annual medical costs billed by health insurance (target variable)           |

## Methodology

1. **Data Preprocessing**
   - One-hot encoding of categorical variables (`region`)
   - Binary transformation of `smoker` and `sex`
   - Train-test split (80/20)

2. **Multiple Linear Regression**
   - Model relationships between `charges` and predictors
   - Validate assumptions: linearity, independence, normality, and homoscedasticity

3. **Variable Selection**
   - Stepwise regression using Adjusted R² and AIC as selection criteria

4. **Transformations**
   - Square root, log, and polynomial transformations
   - Evaluated based on improvement to Adjusted R²

5. **Interaction Terms**
   - Created interactions between `smoker` and other variables to improve fit

6. **Model Evaluation**
   - Based on the Residual Mean Squared Error (RMSE) and overall prediction accuracy
   - Diagnostic plots to assess residuals and model assumptions

## Final Model

The final model used the following formula (with log transformation on the response):

**log_charges ~ age * smoker + bmi * smoker + children + regionsouthwest + regionsoutheast**

This model provided the highest Adjusted R² and the lowest prediction error.

## Results & Insights

- **Smoker status** was the most significant predictor of medical costs.
- **Interactions** between smoking and age/BMI significantly improved model accuracy.
- The final model performed well, though diagnostic plots indicated minor issues with normality and heteroscedasticity.

## Libraries Used

- `caTools`
- `caret`
- `SignifReg`
- `car`

## Conclusion

This project demonstrates the effective use of linear regression, variable selection, and transformations in predicting healthcare costs. The goal was to **leverage the full potential of linear regression** by refining the model through thoughtful variable selection, strategic transformations, and interaction terms. 

The findings offer insights into how demographic and behavioral variables influence medical expenses, with potential applications in insurance pricing and health policy design. While the model showed strong performance metrics, there remains room for future improvement through more advanced techniques or alternative modeling approaches.

*This project was developed collaboratively as part of a team-based coursework assignment for Math 444: Statistical Modeling (Fall 2024).*
