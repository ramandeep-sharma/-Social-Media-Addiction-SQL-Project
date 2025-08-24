SELECT * FROM social_media_addiction.addiction_data;

-- 1. Average daily screen time overall and by gender?
select gender, avg(avg_daily_usage_hours) from addiction_data group by gender;
SELECT 
    Gender,
    ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS Avg_Usage_Hours
FROM
    addiction_data
GROUP BY Gender;

-- 2. Top 3 most used platforms among students?
select Most_used_platform , count(*) as users from addiction_data group by Most_used_platform order by users desc limit 3;
SELECT Most_Used_Platform, User_Count
FROM (
    SELECT Most_Used_Platform,
           COUNT(*) AS User_Count,
           ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rn
    FROM addiction_data
    GROUP BY Most_Used_Platform
) AS ranked_platforms
WHERE rn <= 3;

-- 3. Which country has the highest average usage time?
SELECT Country, Avg_Usage
FROM (
    SELECT Country,
           ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS Avg_Usage,
           ROW_NUMBER() OVER (ORDER BY AVG(Avg_Daily_Usage_Hours) DESC) AS rn
    FROM addiction_data
    GROUP BY Country
) AS ranked
WHERE rn = 1;

-- 4.Age-wise pattern of usage — do younger students spend more time?
SELECT 
  CASE 
    WHEN Age BETWEEN 16 AND 18 THEN '16-18'
    WHEN Age BETWEEN 19 AND 21 THEN '19-21'
    ELSE '22-25'
  END AS Age_Group,
  ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS Avg_Usage_Hours,
  COUNT(*) AS Students
FROM addiction_data
GROUP BY Age_Group
ORDER BY Age_Group desc;

-- 5.How many students say social media affects their academics?
select count(*) from addiction_data where Affects_Academic_Performance = 'Yes';

SELECT 
    affects_academic_performance, COUNT(*) AS student_count
FROM
    addiction_data
GROUP BY affects_academic_performance;

-- 6. Avg usage time for students who say "Yes" vs "No" in academic impact?
SELECT 
    affects_academic_performance ,
    ROUND(AVG(avg_daily_usage_hours), 2) AS avg_usage_time
FROM 
    addiction_data
GROUP BY 
    affects_academic_performance;
    
-- 7.Sleep Hours vs Usage Time correlation?
 SELECT 
    CASE 
        WHEN avg_daily_usage_hours < 2 THEN '<2 hrs'
        WHEN avg_daily_usage_hours BETWEEN 2 AND 4 THEN '2-4 hrs'
        WHEN avg_daily_usage_hours BETWEEN 4 AND 6 THEN '4-6 hrs'
        ELSE '>6 hrs'
    END AS usage_group,
    ROUND(AVG(sleep_hours_per_night), 2) AS avg_sleep
FROM 
    addiction_data
GROUP BY 
    usage_group
ORDER BY 
    usage_group;
    
-- 8.Does high usage correlate with lower mental health scores?
SELECT 
    CASE
        WHEN Avg_daily_Usage_hours <= 2 THEN 'low'
        WHEN Avg_daily_Usage_hours <= 5 THEN 'mediam'
        ELSE 'high'
    END AS Usage_category,
    round(avg(mental_health_score),2) AS avg_mental_health_score,
    COUNT(*) AS student_count
FROM
    addiction_data
GROUP BY Usage_category;

-- 9.Average mental health score by  country top 5 
WITH country_avg AS (
  SELECT 
    country, 
    ROUND(AVG(mental_health_score), 2) AS avg_score, 
    COUNT(*) AS student_count 
  FROM addiction_data 
  GROUP BY country
)
SELECT * 
FROM country_avg 
ORDER BY avg_score DESC 
LIMIT 5;


 -- 10. Top 3 platforms linked with low mental health score?
 WITH platform_avg AS (SELECT 
    Most_Used_Platform, ROUND(AVG(mental_health_score), 2) AS avg_score,
    COUNT(*) AS user_count FROM addiction_data
  WHERE mental_health_score IS NOT NULL GROUP BY Most_Used_Platform
),
ranked_platforms AS (
  SELECT most_used_platform,avg_score,
    user_count,RANK() OVER (ORDER BY avg_score ASC) AS rnk
  FROM platform_avg)
SELECT *
FROM ranked_platforms
WHERE rnk <= 3;

 -- 11. Which relationship status reports highest  conflicts over social media?
SELECT 
    relationship_Status,
    ROUND(AVG(conflicts_over_social_media), 2) avg_conflicts,
    COUNT(*) total_people
FROM
    addiction_data
WHERE
    Conflicts_Over_Social_Media IS NOT NULL
GROUP BY Relationship_Status
ORDER BY avg_conflicts DESC
LIMIT 1;

 -- 12. Does being addicted lead to more conflicts in relationships?
 SELECT 
  Addicted_Score,
  ROUND(AVG(conflicts_over_social_media), 2) AS avg_conflict_score,
  COUNT(*) AS people_count
FROM addiction_data
WHERE conflicts_over_social_media IS NOT NULL
GROUP BY Addicted_Score
ORDER BY Addicted_Score;

 -- 13. Conflicts vs Addicted Score correlation
SELECT 
    Addicted_Score,
    ROUND(AVG(conflicts_over_social_media), 2) AS avg_conflict
FROM
    addiction_data
WHERE
    Addicted_Score IS NOT NULL
        AND conflicts_over_social_media IS NOT NULL
GROUP BY Addicted_Score
ORDER BY Addicted_Score;