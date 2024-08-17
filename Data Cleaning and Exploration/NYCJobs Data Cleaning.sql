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
-- 'Hours/Shift' has same values but different spelling/formatting
select distinct(`Hours/Shift`)
from nycjobs1;

select distinct(`Residency Requirement`)
from nycjobs1;

select distinct(`Job Category`)
from nycjobs1;

select distinct(`Work Location`)
from nycjobs1;

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
-- Delete non english symbols (Ã¢Â€Â™) throughout dataset. These non english symbols appear within multiple columns but some columns were removed due to it not being relevant / important for analysis. Will just be focusing on columns that have these symbols that were not removed.
-- 'Division/Work Unit' and 'Hours/Shift' has:
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

