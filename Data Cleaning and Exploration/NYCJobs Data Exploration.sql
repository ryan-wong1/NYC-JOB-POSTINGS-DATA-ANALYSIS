-- VIEW ALL
select * 
from nycjobs1;

-- what are the highest and lowest paying jobs per industry?
select `Business Title`, avg(replace(salary_range_from_modified, '$', '')) as salary_range_from, avg(replace(salary_range_to_modified, '$', '')) as salary_range_to
from nycjobs1
group by `Business Title`
order by salary_range_from desc, salary_range_to desc;

select `Civil Service Title`, avg(replace(salary_range_from_modified, '$', '')) as salary_range_from, avg(replace(salary_range_to_modified, '$', '')) as salary_range_to
from nycjobs1
group by `Civil Service Title`
order by salary_range_from desc, salary_range_to desc;

-- what agencies, industries, etc. have the highest number of job openings?
select agency, count(*)
from nycjobs1
group by agency
order by count(*) desc;

select job_category_industry, count(*)
from nycjobs1
group by job_category_industry
order by count(*) desc;

-- what percentage of POSTING TYPES are internal vs external? which of the two has the higher average salary?
select `posting type`, count(*), avg(replace(salary_range_from_modified, '$', '')) as salary_range_from, avg(replace(salary_range_to_modified, '$', '')) as salary_range_to
from nycjobs1
group by `posting type`;

-- what is the distribution of full to part time jobs across agencies?
select agency, `posting type`, count(*)
from nycjobs1
group by agency, `posting type`
order by agency;

-- what is the distribution of number of available positions per career level? what about average salary per career level?
select `Career Level`, count(*), avg(replace(salary_range_from_modified, '$', '')) as salary_range_from, avg(replace(salary_range_to_modified, '$', '')) as salary_range_to
from nycjobs1
group by `Career Level`;

-- what is the trend in number of jobs across time? months, years, etc.
select `Posting Date`, count(*)
from nycjobs1
group by `Posting Date`
order by `Posting Date`;

-- what is the most common shift type (ex: 40 hours per week)
select Hours_Shift_Simplified, count(*)
from nycjobs1
group by Hours_Shift_Simplified
order by count(*) desc; 

-- what job title has the highest number of openings?
select `Civil Service Title`, count(*)
from nycjobs1
group by `Civil Service Title`
order by count(*) desc;

select `Business Title`, count(*)
from nycjobs1
group by `Business Title`
order by count(*) desc;
