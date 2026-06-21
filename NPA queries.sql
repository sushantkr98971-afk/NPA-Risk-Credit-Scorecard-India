-- Problem 1: NPA Rate by Occupation
-- Purpose: Identify which borrower occupations carry the highest default risk in the portfolio.
-- Finding: Farmers (50.07%) and Daily Wage Workers (47.28%) showed highest NPA rates.


select occupation, 
count(loan_id) as total_loans,
sum(case 
when loan_status = "default / NPA" then 1
else 0
end) as NPA_count,
round(( sum(case 
when loan_status = "default / NPA" then 1
else 0
end)/count(loan_id))*100,2) as NPA_Rate
from bank
group by occupation
order by NPA_rate desc;




- Problem 2: CIBIL Band Analysis
-- Purpose: Examine how creditworthiness (measured by CIBIL score) correlates with default risk
-- Finding: NPA rate declines consistently from 61.19% (300-499 band) to 20.91% (800-900 band)
-- Note: Bands created inline using CASE WHEN since CIBIL_Score exists as raw numeric column

select case
when Cibil_Score between 300 and 499 then "300-499"
when Cibil_Score between 500 and 599 then "500-599"
when Cibil_Score between 600 and 699 then "600-699"
when Cibil_Score between 700 and 799 then "700-799"
else "800-900"
end as Cibil_Band,
count(Loan_id) as Total_loans,
sum(case 
when loan_status = "default / NPA" then 1
else 0
end) as NPA_count,
round(( sum(case 
when loan_status = "default / NPA" then 1
else 0
end)/count(loan_id))*100,2) as NPA_Rate
from Bank
group by Cibil_band
ORDER BY Cibil_band ASC;




-- Problem 3: Macro Environment Impact
-- Purpose: Assess how RBI rate cycles influence default behaviour across the portfolio
-- Finding: Low Rate environments paradoxically produced the highest NPA rate (37.54%) — cheap credit attracted riskier borrowers with looser approval standards
-- Note: Counterintuitive finding — contradicts the assumption that high rates cause most defaults

select Rate_environment,
count(Loan_id) as Total_Loans,
sum(case
when Loan_status = "Default / NPA" then 1
else 0
end) as NPA_Count,
round(( sum(case 
when loan_status = "Default / NPA" then 1
else 0
end)/count(loan_id))*100,2) as NPA_Rate,
round(avg(Loan_amount),2) as Avg_Loan_Amount,
round(avg(Cibil_score),2) as Avg_Cibil_Score
from bank 
group by Rate_Environment
order by NPA_Rate  asc;




-- Problem 4: Asset Rich Defaulters
-- Purpose: Identify borrowers whose assets exceeded their loan value but still defaulted  proving collateral alone is insufficient as a risk mitigation measure
-- Finding: 4,812 borrowers with ALR above 3 defaulted despite assets being triple their loan amount
-- Method: UNION ALL used for overlapping thresholds CASE WHEN cannot handle subset logic correctly
-- Note: ALR (Asset to Loan Ratio) calculated inline as Net_Worth / Loan_Amount since it does not exist as a permanent column


SELECT 'ALR > 1' AS ALR_Threshold,
sum(case
when Loan_status = "Default / NPA" then 1
else 0
end) as NPA_Count,
round(avg(cibil_score),0) as avg_cibil_score,
round(avg(loan_amount),2) as avg_loan_amount
FROM bank
WHERE (Net_Worth / Loan_Amount) > 1
AND Loan_Status = 'Default / NPA'

UNION ALL

SELECT 'ALR > 2' ,
sum(case
when Loan_status = "Default / NPA" then 1
else 0
end) as NPA_Count,
round(avg(cibil_score),0) as avg_cibil_score,
round(avg(loan_amount),2) as avg_loan_amount
FROM bank
WHERE (Net_Worth / Loan_Amount) > 2
AND Loan_Status = 'Default / NPA'

UNION ALL

SELECT 'ALR > 3',
sum(case
when Loan_status = "Default / NPA" then 1
else 0
end) as NPA_Count,
round(avg(cibil_score),0) as avg_cibil_score,
round(avg(loan_amount),2) as avg_loan_amount
FROM bank
WHERE (Net_Worth / Loan_Amount) > 3
AND Loan_Status = 'Default / NPA';




-- Problem 5: Credit Scorecard — Tier Validation
-- Purpose: Build a rule-based credit scorecard combining five risk dimensions into a single score, assign each borrower a risk tier, and validate the model's discriminatory power
-- Finding: Scorecard captured 64.85% of actual NPAs within the High Risk tier using five variables and no machine learning whatsoever
-- Method: Three nested subquery layers required  Layer 1: calculate five individual scores
         Layer 2: sum scores and assign risk tier
         Layer 3: aggregate and compute NPA rate
-- Scoring: Occupation (max 4) + CIBIL (max 5) + Rate Environment (max 3) + ALR (max 4) +  FOIR (max 4) = maximum total score of 20
-- Threshold:>=15 High Risk / >= 10 Medium Risk

SELECT 
    Risk_Tier,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN Loan_Status = 'Default / NPA' THEN 1 ELSE 0 END) AS NPA_Count,
    ROUND(SUM(CASE WHEN Loan_Status = 'Default / NPA' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS NPA_Rate_Pct
FROM bank
GROUP BY Risk_Tier
ORDER BY NPA_Rate_Pct DESC;


QUERY TO FIND RISK_TEIR

Update bank
Set Risk_Tier = Case
    When(
        Case 
        when Occupation = 'Farmer' or Occupation = 'Daily Wage Worker' Then 4
             when Occupation = 'Gig Worker / Freelancer' then 3
             When Occupation = 'Self-Employed Business' or Occupation = 'Self-Employed Professional' Then 2
             else 1 end
        +
        Case 
        When Cibil_Score < 500 Then 5
             When Cibil_Score < 600 Then 4
             When Cibil_Score < 700 Then 3
             When Cibil_Score < 800 Then 2
             Else 1 End
        +
        Case 
        When Rate_Environment = 'Low Rate' then 3
             WHEN Rate_Environment = 'High Rate' then 2
             Else 1 End
        +
        Case
        When (Net_Worth/Loan_Amount) < 0.5 Then 4
             When (Net_Worth/Loan_Amount) < 1 Then 3
             When (Net_Worth/Loan_Amount) < 2 Then 2
             Else 1 end
        +
        Case 
        When (Existing_Debt_PA/12 + Total_Repayment/(Loan_Tenure_Years*12))/(Annual_Income/12) > 0.7 then 4
             When (Existing_Debt_PA/12 + Total_Repayment/(Loan_Tenure_Years*12))/(Annual_Income/12) > 0.5 then 3
             When (Existing_Debt_PA/12 + Total_Repayment/(Loan_Tenure_Years*12))/(Annual_Income/12) > 0.3 then 2
             else 1 end
    ) >= 12 then 'High Risk'
	when(
         Case 
        when Occupation = 'Farmer' or Occupation = 'Daily Wage Worker' Then 4
             when Occupation = 'Gig Worker / Freelancer' then 3
             When Occupation = 'Self-Employed Business' or Occupation = 'Self-Employed Professional' Then 2
             else 1 end
        +
        Case 
        When Cibil_Score < 500 Then 5
             When Cibil_Score < 600 Then 4
             When Cibil_Score < 700 Then 3
             When Cibil_Score < 800 Then 2
             Else 1 End
        +
        Case 
        When Rate_Environment = 'Low Rate' then 3
             WHEN Rate_Environment = 'High Rate' then 2
             Else 1 End
        +
        Case
        When (Net_Worth/Loan_Amount) < 0.5 Then 4
             When (Net_Worth/Loan_Amount) < 1 Then 3
             When (Net_Worth/Loan_Amount) < 2 Then 2
             Else 1 end
        +
        Case 
        When (Existing_Debt_PA/12 + Total_Repayment/(Loan_Tenure_Years*12))/(Annual_Income/12) > 0.7 then 4
             When (Existing_Debt_PA/12 + Total_Repayment/(Loan_Tenure_Years*12))/(Annual_Income/12) > 0.5 then 3
             When (Existing_Debt_PA/12 + Total_Repayment/(Loan_Tenure_Years*12))/(Annual_Income/12) > 0.3 then 2
             else 1 end
    ) >= 8 THEN 'Medium Risk'
    ELSE 'Low Risk'
END;




