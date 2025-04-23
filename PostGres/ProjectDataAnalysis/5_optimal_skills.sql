/*
What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Anallyst roles
-Concentrates on remote positions with specified salaries
-Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
offering strategic insights for career development in data analysis
*/
With skills_demand as (
    Select
        skills_dim.skill_id, 
        skills_dim.skills,
        Count(skills_job_dim.job_id) as demand_count
    FROM
        job_postings_fact
    Inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    Where
        job_title_short = 'Data Analyst'
        and salary_year_avg is not null
    group by skills_dim.skill_id

), average_salary as ( -- second cte
Select 
    skills_job_dim.skill_id,
    --skills,
    round(avg(salary_year_avg), 0) as avg_salary
FROM
    job_postings_fact
Inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
Where
    job_title_short = 'Data Analyst'
    and salary_year_avg is not null
group by skills_job_dim.skill_id

)

select
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
from 
    skills_demand
Inner join average_salary on skills_demand.skill_id = average_salary.skill_id
where demand_count > 10
order by 
    demand_count DESC,
    avg_salary DESC
limit 25;

--rewrite the same query in a concise way
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) as demand_count,
    round(avg(job_postings_fact.salary_year_avg), 0) as avg_salary
    from job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        and salary_year_avg is not NULL
        and job_work_from_home = TRUE
    group BY
        skills_dim.skill_id
    HAVING
        count(skills_job_dim.job_id) > 10
    order BY
        avg_salary desc,
        demand_count DESC
    limit 25;