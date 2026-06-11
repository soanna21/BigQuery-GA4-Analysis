SELECT *
FROM project.cohort_events_raw;

SELECT *
FROM project.cohort_users_raw;

select to_date(replace(replace(trim(signup_datetime),'.','-'),'/','-'),'dd-mm-yyyy'),
       to_date(replace(replace(trim(signup_datetime),'.','-'),'/','-'),'dd-mm-yy')
FROM project.cohort_users_raw;

--- Solution
--- Table 1
with users_parsed as(
select u.user_id,
     u.promo_signup_flag,
     to_date(
     lpad(split_part(sd,'-',1),2,'0') || '-'||  --- In the second step, we separate a part of the date, use Lpad to specify how many characters this separated part should contain, and if it's smaller, we add a zero.
     lpad(split_part(sd,'-',2),2,'0') || '-'||
     case when length(split_part(sd,'-',3)) = 2 --- Step three - in case the separated third part consists of two characters. Then we concatenate 20 with the particle
     then '20' || split_part(sd,'-',3)
     else split_part(sd,'-',3)
     end,
     'dd-mm-yyyy') as signup_date  --- the fourth step - converting to a date
from (
    select user_id,
           promo_signup_flag,
           replace(replace(trim(split_part(signup_datetime,' ',1)),'.','-'),'/','-') as sd --- The first step is to clear the date of the time and change the characters to the required ones.
FROM project.cohort_users_raw) as u),
--- Table 2 - the same steps, but for the table with events
events_parsed as(
select e.user_id,
     e.event_type,
     to_date(
     lpad(split_part(sd,'-',1),2,'0') || '-'||
     lpad(split_part(sd,'-',2),2,'0') || '-'||
     case when length(split_part(sd,'-',3)) = 2
     then '20' || split_part(sd,'-',3)
     else split_part(sd,'-',3)
     end,
     'dd-mm-yyyy') as event_date
from (
    select user_id,
           event_type,
           replace(replace(trim(split_part(event_datetime,' ',1)),'.','-'),'/','-') as sd
FROM project.cohort_events_raw) as e),
--- таблиця 3 --- we merge the tables, bring the dates to the task format, find the month_offset, set conditions for event_type, signup_date, event_date.
user_activity as(
select u.user_id,
       u.promo_signup_flag,
       e.event_type,
       date_trunc('month',u.signup_date)::date as cohort_month, --- виводимо з дати реєстрації місяць та рік
       date_trunc('month',e.event_date)::date as event_month, --- виводимо з дати івенту місяць та рік
       date_part('year', age(date_trunc('month',e.event_date),date_trunc('month',u.signup_date)))*12 +
       date_part('month',age(date_trunc('month',e.event_date),date_trunc('month',u.signup_date))) as month_offset --- We find the difference in months between the event and registration. We create a date part to subtract year from year, month from month, because otherwise the result will be in days.
from users_parsed u
left join events_parsed e
on u.user_id = e.user_id
where e.event_type is not null
and e.event_type not like 'test_event'
and u.signup_date is not null
and e.event_date is not null)
--- фінальний запит
select promo_signup_flag,
       cohort_month,
       month_offset,
       count(distinct user_id) as users_total
from user_activity
where event_month between '2025-01-01' and '2025-06-01'
group by 1,2,3
order by 1,2,3;



