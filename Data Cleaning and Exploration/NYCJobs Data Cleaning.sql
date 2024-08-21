-- VIEW DATA 
select *
from nycjobs;


-- CREATE COPY OF DATASET
create table nycjobs1 (
select *
from nycjobs
);

select *
from nycjobs1;


-- *REMOVE ALL DUPLICATE ROWS*
select count(*)
from nycjobs1; -- 5197 rows returned

select distinct count(*)
from nycjobs1; -- 5197 rows returned. No duplicate rows present.

/* if duplicate rows were present, create a temp table storing all of the distinct rows. Remove all rows (not the actual table itself) from the original dataset and then insert data from temp table into the empty original dataset. Delete temp table.

create temporary table nycjobs_temp (
select distinct *
from nycjobs1
);

delete from nycjobs1;

insert into nycjobs1
select *
from nycjobs_temp;

drop temporary table nycjobs_temp;
*/


-- *MAKE SAME GROUP NAMES CONSISTANT (ex: crypto vs cryptocurrency. N/A vs NULL)*
-- 'Hours/Shift', 'Residency Requirement', 'Job Category', 'Work Location' has same values but different spelling/formatting
-- in my opinion, it's best to create a new column along with the original column for all 4 of these columns we are targeting for comparison purposes and to avoid confusion down the road.

-- Hours/Shift column
-- GROUPS:
-- 35 hours
-- 8 AM - 4 PM
-- 9 AM - 5 PM
-- Monday - Friday (no hours given)
-- Monday - Friday 9 AM - 5 PM
-- Monday - Friday 7:30 AM - 3:30 PM
-- 9 AM - 17 PM (can be converted to 9 to 5)
-- To be determined

select distinct(`Hours/Shift`)
from nycjobs1;


-- Residency Requirement column
-- Not critical but please scroll down to the section where I remove non-english characters (Ã¢Â€Â) from cells within certain columns (Residency Requirement column included). The code used remove these non-english characters from the Residency Requirement is not necessary to run prior to running the code from this section since LIKE is used to target everything similar but I have included it in one of the later sections for viewing purposes anyways.
-- Residency Requirement column groups:
-- City Residency is not required for this position.
-- New York City residency is generally required within 90 days of appointment. However, City Employees in certain titles who have worked for the City for 2 continuous years may also be eligible to reside in Nassau, Suffolk, Putnam, Westchester, Rockland, or Orange County. To determine if the residency requirement applies to you, please discuss with the agency representative at the time of interview.
-- New York State Residency is REQUIRED on first day of employment.
--
--
--
--
--

select distinct(`Residency Requirement`)
from nycjobs1
order by `Residency Requirement`;

-- Job Category column
-- many different sectors within industry. Example: Communications & Intergovernmental Affairs in x y z
-- can create a new individual column with just the industry and keep the original column as is to view specific sector within x industry. No 'duplicates' present within original 'Job Category' column
-- Industry categories: 
-- Administration & Human Resources
-- Building Operations & Maintenance
-- Communications & Intergovernmental Affairs
-- Constituent Services & Community Programs
-- Engineering, Architecture, & Planning
-- Finance, Accounting, & Procurement
-- Green Jobs
-- Health
-- Legal Affairs
-- Policy, Research & Analysis
-- Public Safety
-- Social Services
-- Technology, Data & Innovation

select distinct(`Job Category`)
from nycjobs1
order by `Job Category`;

alter table nycjobs1
add Job_Category_Industry varchar(255);

update nycjobs1
set Job_Category_Industry = 'Administration & Human Resources'
where `Job Category` like '%Administration & Human Resources%'; -- 532 rows affected

update nycjobs1
set Job_Category_Industry = 'Building Operations & Maintenance'
where `Job Category` like '%Building Operations & Maintenance%'; -- 353 rows affected

update nycjobs1
set Job_Category_Industry = 'Communications & Intergovernmental Affairs'
where `Job Category` like '%Communications & Intergovernmental Affairs%'; -- 221 rows affected

update nycjobs1
set Job_Category_Industry = 'Constituent Services & Community Programs'
where `Job Category` like '%Constituent Services & Community Programs%'; -- 653 rows affected

update nycjobs1
set Job_Category_Industry = 'Engineering, Architecture, & Planning'
where `Job Category` like '%Engineering, Architecture, & Planning%'; -- 1345 rows affected

update nycjobs1
set Job_Category_Industry = 'Finance, Accounting, & Procurement'
where `Job Category` like '%Finance, Accounting, & Procurement%'; -- 411 rows affected

update nycjobs1
set Job_Category_Industry = 'Green Jobs'
where `Job Category` like '%Green Jobs%'; -- 81 rows affected

update nycjobs1
set Job_Category_Industry = 'Health'
where `Job Category` like '%Health%'; -- 835 rows affected

update nycjobs1
set Job_Category_Industry = 'Legal Affairs'
where `Job Category` like '%Legal Affairs%'; -- 559 rows affected

update nycjobs1
set Job_Category_Industry = 'Policy, Research & Analysis'
where `Job Category` like '%Policy, Research & Analysis%'; -- 801 rows affected

update nycjobs1
set Job_Category_Industry = 'Public Safety'
where `Job Category` like '%Public Safety%'; -- 866 rows affected

update nycjobs1
set Job_Category_Industry = 'Social Services'
where `Job Category` like '%Social Services%'; -- 596 rows affected

update nycjobs1
set Job_Category_Industry = 'Technology, Data & Innovation'
where `Job Category` like '%Technology, Data & Innovation%'; -- 483 rows affected

-- Work Location column
select distinct(`Work Location`)
from nycjobs1
order by `Work Location`; -- no 'duplicates' present


-- *FORMAT DATES (1/23/2024, January 23, 2024, etc)*
-- Posting Date, Posting Updated, and Process Date all in same mm/dd/yyyy format. Post Until in dd-MONTH-yy format. Convert to mm/dd/yyyy.
select `Posting Date`,`Posting Updated`,`Process Date`,`Post Until`
from nycjobs1;

select date_format(`Post Until`, '%m/%d/%y') -- shows null instead of conversion for some reason
from nycjobs1;

/*
update nycjobs1
set `Post Until` = date_format(`Post Until`, '%m/%d/%y')  
*/


-- *CHECK FOR CORRECT VARIABLE TYPES (names are strings, numbers are integers, dates are dates, add $ in front of currency, etc)*
-- Add $ symbol to 'Salary Range From' and 'Salary Range To'
select `Salary Range From`, `Salary Range To`
from nycjobs1;

select concat('$', `Salary Range From`) as Salary_Range_From
from nycjobs1;

select concat('$', `Salary Range To`) as Salary_Range_To
from nycjobs1;

/*
update nycjobs1 -- Error Code: 1366. Incorrect integer value: '$105746' for column 'Salary Range From' at row 1
set `Salary Range From` = concat('$', `Salary Range From`);

update nycjobs1 -- Error Code: 1366. Incorrect integer value: '$105746' for column 'Salary Range From' at row 1
set `Salary Range To` = concat('$', `Salary Range To`);
*/

-- Possible fix: create new column as data type of STRING. Concat $ symbol and Salary columns into this new column. Optional, can delete original salary columns afterwards.
alter table nycjobs1
add Salary_Range_From varchar(255);

alter table nycjobs1
add Salary_Range_To varchar(255);

update nycjobs1
set Salary_Range_From = concat('$', `Salary Range From`);

update nycjobs1
set Salary_Range_To = concat('$', `Salary Range To`);

-- delete original salary tables if needed
alter table nycjobs1
drop column `Salary Range From`,
drop column `Salary Range To`;

/* -- To view datatypes of columns for SQL Server Management only. Not needed for MySQL since you can just click on a database and have the column types appear on the left hand side.
select COLUMN_NAME, data_type 
from INFORMATION_SCHEMA.COLUMNS
where table_name = 'nycjobs';
*/


-- *REMOVE / FILL IN FOR MISSING VALUES (NULL's, " "). Replace with 0, etc.* Column names of 'Hours/Shift', 'Work Location 1', 'Post Until' have blank cells.
select * 
from nycjobs1
where `Hours/Shift` = '';

select * 
from nycjobs1
where `Work Location 1` = '';

select * 
from nycjobs1
where `Post Until` = '';

update nycjobs1
set `Hours/Shift` = 'N/A'
where `Hours/Shift` = ''; -- 3750 rows affected

update nycjobs1
set `Work Location 1` = 'N/A'
where `Work Location 1` = ''; -- 3489 rows affected

update nycjobs1
set `Post Until` = 'N/A'
where `Post Until` = ''; -- 3576 rows affected


-- *REMOVE EXTRA / UNNECESSARY SPACES (ex: '   John')*
-- no unnecessary spaces found within this dataset. Code is below if wanting to explore however.
select trim(`Work Location 1`) -- 'Work Location 1' can be replaced with any column name to trim any unnecessary spaces from existance.
from nycjobs1;

/*
update nycjobs1
set `Work Location 1` = trim(`Work Location 1`)
*/


-- Delete non english symbols (Ã¢Â€Â™) throughout dataset. These non english symbols appear within multiple columns but some columns were removed due to it not being relevant / important for analysis. Will just be focusing on columns that have these symbols that were not removed. Please scroll down to 'REMOVE ALL IRRELEVANT COLUMNS' to see the columns that were removed from the finalized dataset.
-- 'Division/Work Unit', 'Hours/Shift', and 'Residency Requirement' has:
-- Ã¢Â€Â“
-- Ã‚Â  
-- Ã‚Â Ã‚Â Ã‚Â Ã‚Â Ã‚Â Ã‚Â Ã‚Â Ã‚Â 
-- In this case, would be best to individually target Ã, Â, ¢, €, ™
 
select distinct(`Division/Work Unit`)
from nycjobs1;

update nycjobs1
set `Division/Work Unit` = replace(`Division/Work Unit`,'Ã',''); -- 51 rows affected
update nycjobs1
set `Division/Work Unit` = replace(`Division/Work Unit`,'Â',''); -- 51 rows affected
update nycjobs1
set `Division/Work Unit` = replace(`Division/Work Unit`,'¢',''); -- 6 rows affected
update nycjobs1
set `Division/Work Unit` = replace(`Division/Work Unit`,'€',''); -- 6 rows affected

-- FIA Operations “ Manager (remove “)
select `Division/Work Unit` from nycjobs1
where `Division/Work Unit` = 'FIA Operations  Manager';
-- where `Division/Work Unit` = 'FIA Operations “ Manager';

update nycjobs1 
set `Division/Work Unit` = replace(`Division/Work Unit`,'“','') -- 6 rows affected
where `Division/Work Unit` = 'FIA Operations “ Manager';

-- Environmental Sciences‚ ‚ ‚ ‚ ‚ ‚ ‚ ‚ (remove ,'s)
select `Division/Work Unit` from nycjobs1
where `Division/Work Unit` = 'Environmental Sciences';
-- where `Division/Work Unit` = 'Environmental Sciences‚ ‚ ‚ ‚ ‚ ‚ ‚ ‚ '; 

update nycjobs1 
set `Division/Work Unit` = replace(`Division/Work Unit`,'‚ ‚ ‚ ‚ ‚ ‚ ‚ ‚ ','') -- 20 rows affected
where `Division/Work Unit` = 'Environmental Sciences‚ ‚ ‚ ‚ ‚ ‚ ‚ ‚ ';

select distinct(`Hours/Shift`)
from nycjobs1;

update nycjobs1
set `Hours/Shift` = replace(`Hours/Shift`,'Ã',''); -- 114 rows affected
update nycjobs1
set `Hours/Shift` = replace(`Hours/Shift`,'Â',''); -- 114 rows affected
update nycjobs1
set `Hours/Shift` = replace(`Hours/Shift`,'¢',''); -- 112 rows affected
update nycjobs1
set `Hours/Shift` = replace(`Hours/Shift`,'€',''); -- 112 rows affected

select distinct(`Residency Requirement`)
from nycjobs1;

update nycjobs1
set `Residency Requirement` = replace(`Residency Requirement`,'Ã',''); -- 5 rows updated
update nycjobs1
set `Residency Requirement` = replace(`Residency Requirement`,'Â',''); -- 5 rows updated
update nycjobs1
set `Residency Requirement` = replace(`Residency Requirement`,'¢',''); -- 5 rows updated
update nycjobs1
set `Residency Requirement` = replace(`Residency Requirement`,'€',''); -- 5 rows updated


-- *REMOVE ALL IRRELEVANT COLUMNS*
-- 'Title Code No', 'Job Description', 'Preferred Skills', 'Additional Information', 'To Apply', 'Recruitment Contact', likely not needed for analysis. Content in rows are not repeats across this dataset, too many inconsistancies. 
alter table nycjobs1
drop column `Title Code No`,
drop column `Job Description`,
drop column `Preferred Skills`,
drop column `Additional Information`,
drop column `To Apply`,
drop column `Recruitment Contact`;


-- *Spelling conversions (ex: in to inches, yr to year, etc)*
-- 'Full-Time/Part-Time indicator' = F to FT and P to PT

select `Full-Time/Part-Time indicator`
from nycjobs1;

update nycjobs1
set `Full-Time/Part-Time indicator` = 'FT'
where `Full-Time/Part-Time indicator` = 'F';

update nycjobs1
set `Full-Time/Part-Time indicator` = 'PT'
where `Full-Time/Part-Time indicator` = 'P';


-- 'Business Title' has first letter of each word in cap vs entire title in all caps. Make all consistant.
select upper(`Business Title`)
from nycjobs1;

update nycjobs1
set `Business Title` = upper(`Business Title`);


-- *STANDARDIZE VALUES (Celsius to Fahrenheit, 1 out of 5 -> 20 out of 100, etc)*
-- Some salaries are yearly vs hourly. convert all to hourly
-- find cells with 2 characters (ex: 25) * hours per year = yearly salary
-- not all cells with hourly pay (2 characters) have data in Hours/Shift. Can create a new individual column converting hourly pay * 40 hours a week if data in Hours/Shift is N/A
select Salary_Range_From, Salary_Range_To, `Hours/Shift`
from nycjobs1
where length(Salary_Range_From) <= 3
OR length(Salary_Range_To) <= 3;

 
