USE HR_Project;

SELECT * FROM hr_attrition;

--Q1. Total employees
SELECT DISTINCT COUNT(*) AS Total_Employees FROM HR_ATTRITION;

--Q2. Overall attrition rate (%)
--Matlab: total employees me se kitne % employees ne company chhod di hain.

--Way-1
SELECT
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hr_attrition) 
    AS Attrition_Rate
FROM hr_attrition
WHERE Attrition = 'Yes';
--Way-2
SELECT
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
    AS attrition_rate_pct
FROM hr_attrition;


-- 4) ATTRITION ANALYSIS 


-- 4.1 Attrition by Department
SELECT
    Department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY Department
ORDER BY attrition_rate_pct DESC;

-- 4.2 Attrition by Job Role
SELECT
    JobRole,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY JobRole
ORDER BY attrition_rate_pct DESC;

-- 4.3 Attrition by Gender
SELECT
    Gender,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY Gender;

-- 4.4 Attrition by Age Group (bucket banaye)
SELECT
    CASE
        WHEN Age < 25 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY 
  CASE
        WHEN Age < 25 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END
ORDER BY age_group;

--Way-2
SELECT
    age_group,
    COUNT(*) AS total_employees,
    SUM(CASE 
            WHEN Attrition = 'Yes' THEN 1 
            ELSE 0 
        END) AS attrition_count,
    ROUND(
        SUM(CASE 
                WHEN Attrition = 'Yes' THEN 1 
                ELSE 0 
            END) * 100.0 / COUNT(*), 
        2
    ) AS attrition_rate_pct
FROM
(
    SELECT
        CASE
            WHEN Age < 25 THEN '18-24'
            WHEN Age BETWEEN 25 AND 34 THEN '25-34'
            WHEN Age BETWEEN 35 AND 44 THEN '35-44'
            WHEN Age BETWEEN 45 AND 54 THEN '45-54'
            ELSE '55+'
        END AS age_group,
        Attrition
    FROM hr_attrition
) AS A
GROUP BY age_group
ORDER BY age_group;

-- 4.5 Attrition by OverTime 
SELECT
    OverTime,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY OverTime;

-- 4.6 Attrition by Marital Status
SELECT
    MaritalStatus,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY MaritalStatus
ORDER BY attrition_rate_pct DESC;



-- 5) SALARY & SATISFACTION INSIGHTS


-- 5.1 Average monthly income by department & job role
SELECT
    Department,
    JobRole,
    ROUND(AVG(MonthlyIncome), 0) AS avg_monthly_income,
    COUNT(*) AS employee_count
FROM hr_attrition
GROUP BY Department, JobRole
ORDER BY avg_monthly_income DESC;

-- 5.2 Average income: employees who left vs stayed
SELECT
    Attrition,
    ROUND(AVG(MonthlyIncome), 0) AS avg_income,
    ROUND(AVG(YearsAtCompany), 1) AS avg_tenure_years,
    ROUND(AVG(JobSatisfaction), 2) AS avg_job_satisfaction
FROM hr_attrition
GROUP BY Attrition;

-- 5.3 Job Satisfaction level vs Attrition
SELECT
    JobSatisfaction,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;


-- 6) TENURE / PROMOTION INSIGHTS


-- 6.1 Years since last promotion vs attrition
SELECT
    YearsSinceLastPromotion,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion;

-- 6.2 Top 10 employees at highest attrition risk (long tenure, low satisfaction, overtime)
SELECT TOP 10
    EmployeeNumber, Department, JobRole, Age, YearsAtCompany,
    JobSatisfaction, OverTime, MonthlyIncome
FROM hr_attrition
WHERE Attrition = 'No'
  AND JobSatisfaction <= 2
  AND OverTime = 'Yes'
ORDER BY YearsAtCompany DESC


-- 6.3 Rank departments by attrition rate using a window function
SELECT
    Department,
    attrition_rate_pct,
    RANK() OVER (ORDER BY attrition_rate_pct DESC) AS attrition_rank
FROM (
    SELECT
        Department,
        ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
    FROM hr_attrition
    GROUP BY Department
) AS dept_summary;

--6.4 Attrition rate % by job role.
SELECT COUNT(*) AS total, 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
WHERE JobRole = 'Sales Representative';
