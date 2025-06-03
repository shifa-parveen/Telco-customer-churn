create database telco;
use telco;
select * from telco_customer_churn;

-- Total Customers & Churn Rate 
select count(*) as total_customers,
sum(case when Churn = 'Yes'  then 1 else 0 end) as churned_customers,
round(sum(case when Churn = 'Yes'  then 1 else 0 end) * 100.0 / count(*) , 2) as churn_rate
from telco_customer_churn;

-- Churn Rate by Contract Type
select Contract, count(*) as total_customers,
sum(case when Churn = 'Yes'  then 1 else 0 end) as churned_customers,
round(sum(case when Churn = 'Yes'  then 1 else 0 end) * 100.0 / count(*) , 2) as churn_rate
from telco_customer_churn
group by Contract
order by churn_rate desc;

-- Revenue Loss Due to Churn
select sum(TotalCharges) as total_revenue,
sum(case when Churn = 'Yes' then TotalCharges else 0 end) as lost_revenue,
round(sum(case when Churn = 'Yes' then TotalCharges else 0 end) * 100.0 / sum(TotalCharges), 2) as lost_revenue_percent
from telco_customer_churn;

-- Churn Rate by Internet Service Type
select InternetService, count(*) as total_customers,
sum(case when Churn = 'Yes' then 1 else 0 end) as churned_customers,
round(sum(case when Churn = 'Yes' then 1 else 0 end) * 100.0 / count(*), 2) as churn_rate
from telco_customer_churn
group by InternetService
order by churn_rate desc;

-- Churn by Payment Method
select PaymentMethod, count(*) as total_customers,
sum(case when Churn = 'Yes' then 1 else 0 end) as churned_customers,
round(sum(case when Churn = 'Yes' then 1 else 0 end) * 100.0 / count(*), 2) as churn_rate
from telco_customer_churn
group by PaymentMethod
order by churn_rate desc;

-- Monthly Charges vs. Churn
select case 
when MonthlyCharges < 30 then 'low(<$30)'
when MonthlyCharges between 30 and 70 then 'Mediun($30-$70)'
else 'high(>$70)'
end as charge_category,
count(*) as total_customers,
sum(case when Churn = 'Yes' then 1 else 0 end) as churned_customers,
round(sum(case when Churn = 'Yes' then 1 else 0 end ) * 100.0 / count(*) , 2) as churn_rate
from telco_customer_churn
group by charge_category
order by churn_rate desc;

-- Churn Rate by Senior Citizens
select SeniorCitizen,  count(*) as total_customers,
sum(case when Churn = 'Yes'  then 1 else 0 end) as churned_customers,
round(sum(case when Churn = 'Yes'  then 1 else 0 end) * 100.0 / count(*) , 2) as churn_rate
from telco_customer_churn
group by SeniorCitizen
order by churn_rate;

-- Churn Rate by Tenure Group
select
 case
    when tenure <= 12 then'0-12 Months'
    when tenure between 13 and 24 then '13-24 Months'
    when tenure between 25 and 48 then '25-48 Months'
    else '49+ Months'
end as tenure_group,
count(*) as total_customers,
sum(case when Churn = 'Yes'  then 1 else 0 end) as churned_customers,
round(sum(case when Churn = 'Yes'  then 1 else 0 end) * 100.0 / count(*) , 2) as churn_rate
from telco_customer_churn
group by tenure_group
order by churn_rate desc;

-- Customers Likely to Churn (High-Risk Customers)
select customerID, Contract, MonthlyCharges, TotalCharges, tenure, PaymentMethod
from telco_customer_churn
where Churn = 'No' 
and MonthlyCharges > 80 
and tenure < 12
and Contract = 'Month-to-month';

 -- Churn Breakdown by Gender & Senior Citizen
select gender, SeniorCitizen, count(*) as total_customers,
sum(case when Churn = 'Yes'  then 1 else 0 end) as churned_customers,
round(sum(case when Churn = 'Yes'  then 1 else 0 end) * 100.0 / count(*) , 2) as churn_rate
from telco_customer_churn
group by gender, SeniorCitizen
order by churn_rate;

-- Impact of Tech Support on Churn
select TechSupport,
count(*) as total_customers,
sum(case when Churn = 'Yes'  then 1 else 0 end) as churned_customers,
round(sum(case when Churn = 'Yes'  then 1 else 0 end) * 100.0 / count(*) , 2) as churn_rate
from telco_customer_churn
group by TechSupport
order by churn_rate;

-- Does Streaming Services Impact Churn?
select StreamingTV, StreamingMovies,
count(*) as total_customers,
sum(case when Churn = 'Yes'  then 1 else 0 end) as churned_customers,
round(sum(case when Churn = 'Yes'  then 1 else 0 end) * 100.0 / count(*) , 2) as churn_rate
from telco_customer_churn
group by StreamingTV,StreamingMovies
order by churn_rate;

 -- Retention Rate by Contract Type
select Contract, count(*) as total_customers,
sum(case when Churn = 'No'  then 1 else 0 end) as churned_customers,
round(sum(case when Churn = 'No'  then 1 else 0 end) * 100.0 / count(*) , 2) as retention_rate
from telco_customer_churn
group by Contract
order by retention_rate;

-- Average Monthly and Total Charges vs Churn
select Churn,
round(avg(MonthlyCharges),2) as avg_monthly_charges,
round(avg(TotalCharges),2) as avg_total_charges
from telco_customer_churn
group by Churn;

--  Customer Segmentation: High, Medium & Low Value Customers
select customerID,MonthlyCharges,TotalCharges,tenure,
case
   when tenure>=48 and TotalCharges>3000 then 'high value'
   when tenure between 24 and 47 then 'medium value'
   else 'low value'
   end as customer_segment
   from telco_customer_churn
   order by TotalCharges desc;
   
-- Churn Rate Over Time (Tenure Groups)
select 
case 
    when tenure<=12 then '0-12months'
    when tenure between 13 and 24 then '13-24months'
    when tenure between 25 and 48 then '25-48months'
    else '49+months'
    end as tenure_group,
count(*) as total_customers,
sum(case when Churn = 'Yes'  then 1 else 0 end) as churned_customers,
round(sum(case when Churn = 'Yes'  then 1 else 0 end) * 100.0 / count(*) , 2) as churn_rate
from telco_customer_churn
group by tenure_group
order by churn_rate desc;

-- Churn Probability Based on Multiple Factor
select gender,InternetService,Contract,count(*) as total_customers,
sum(case when Churn = 'Yes' then 1 else 0 end) as churned_customers,
round(sum(case when Churn = 'Yes' then 1 else 0 end) * 100.0 / count(*), 2) as churn_rate
from telco_customer_churn
group by gender,Contract,InternetService
order by churn_rate desc;

-- Identify At-Risk Customers for Retention Efforts
select customerID, MonthlyCharges, TotalCharges, tenure, Contract, InternetService,PaymentMethod
from telco_customer_churn
where Churn = 'No' and MonthlyCharges > 80 and tenure < 12 and Contract = 'Month-to-month';

-- Monthly Revenue Breakdown
select Contract,
    round(sum(MonthlyCharges), 2) as total_monthly_revenue,
    round(avg(MonthlyCharges), 2) as avg_monthly_revenue
from telco_customer_churn
group by Contract
order by  total_monthly_revenue desc;

   










