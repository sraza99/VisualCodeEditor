/* Question: What are the most in-demand skills for data analysts?
-Join job postings to inner join table similar to query 2
- Identify the top 5 in-damand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieve the top 5 skills with the highest demand in the job market,
providing insights into the most valuable skills for job seekers. */

with remote_job_skills as (
    Select 
       skill_id,
       Count(*) as skill_count
    from
        skills_job_dim as skills_to_job
    inner join job_postings_fact as job_postings on job_postings.job_id = skills_to_job.job_id
    where 
        job_postings.job_work_from_home = true
    Group BY
        skill_id
)
select -- here we do another inner join with skills_dim to get name of skills
skills.skill_id,
skills as skill_name,
skill_count
from remote_job_skills
inner join skills_dim as skills on skills.skill_id = remote_job_skills.skill_id
order by skill_count desc
limit 5;

-- shorter and efficient way of achieving similar results.
Select 
    skills,
    Count(skills_job_dim.job_id) as demand_count
FROM
    job_postings_fact
Inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
Where
    job_title_short = 'Data Analyst'
group by skills
order by demand_count desc
limit 5
