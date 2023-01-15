--------------------------------Tables Part (create & insert)

--First table "Person"
CREATE TABLE person (
person_ID NUMBER (7) ,
first_name VARCHAR2 (10),
last_name VARCHAR2 (10),
date_of_birth DATE,
age NUMBER (2),
CONSTRAINT person_pk PRIMARY KEY (person_ID));

insert into person(person_ID,first_name,last_name,date_of_birth,age) values(1,'Raghad','Ali','02-Dec-2002',19);
insert into person(person_ID,first_name,last_name,date_of_birth,age) values(2,'Abeer','Almalawi','26-Dec-2001',20);
insert into person(person_ID,first_name,last_name,date_of_birth,age) values(3,'Maram','Alharthi','18-Aug-1999',22);
insert into person(person_ID,first_name,last_name,date_of_birth,age) values(4,'Moudi','Alhazzaz','01-Apr-1996',25);
insert into person(person_ID,first_name,last_name,date_of_birth,age) values(5,'Aneer','Alghamdi','08-Oct-2003',18);

--Second table "Medical history"
CREATE TABLE medical_history (
disease_type VARCHAR2 (15) ,
fk_person NUMBER (7) REFERENCES person (person_ID),
CONSTRAINT medical_pk PRIMARY KEY (disease_type));

insert into medical_history (disease_type,fk_person) values('Pressure',1);
insert into medical_history (disease_type,fk_person) values('Diabetes',3);
insert into medical_history (disease_type,fk_person) values('Asthma',4);
insert into medical_history (disease_type,fk_person) values('Influenza',5);
insert into medical_history (disease_type,fk_person) values('allergy',2);

--Third table "Vaccine"
CREATE TABLE vaccine (
vaccine_name VARCHAR2 (15),
vaccine_type VARCHAR2 (10),
CONSTRAINT vaccine_pk PRIMARY KEY (vaccine_name));

insert into vaccine(vaccine_name,vaccine_type) values('Pfizer','American');
insert into vaccine(vaccine_name,vaccine_type) values('Modrena','American');
insert into vaccine(vaccine_name,vaccine_type) values('SinoVac','Chinese');
insert into vaccine(vaccine_name,vaccine_type) values('SinoPharm','Chinese');
insert into vaccine(vaccine_name,vaccine_type) values('AstraZeneca','British');

--Fourth table "Center"
CREATE TABLE center (
center_no NUMBER (2),
center_name VARCHAR (30),
center_location VARCHAR2 (10),
CONSTRAINT center_pk PRIMARY KEY (center_no),
fk_vaccine VARCHAR2 (15) REFERENCES vaccine (vaccine_name));

insert into center(center_no,center_name,center_location,fk_vaccine) values(01,'KA Airport','Jeddah','Pfizer');
insert into center(center_no,center_name,center_location,fk_vaccine) values(02,'KingAbdullah Hospital','Riyadh','Modrena');
insert into center(center_no,center_name,center_location,fk_vaccine) values(03,'KingFahad Hospital','Jeddah','Modrena');
insert into center(center_no,center_name,center_location,fk_vaccine) values(04,'KingFaisal Hospital','Dammam','Pfizer');
insert into center(center_no,center_name,center_location,fk_vaccine) values(05,'KingAbdullaziz Hospital','Makkah','AstraZeneca');

--Fifth table "Dose"
CREATE TABLE dose (
number_of_doses NUMBER (1),
dose_date DATE,
fk_vaccine VARCHAR2 (15) REFERENCES vaccine (vaccine_name),
fk_person NUMBER (7) REFERENCES person (person_ID),
CONSTRAINT dose_pk PRIMARY KEY (number_of_doses));

insert into dose(number_of_doses,dose_date,fk_vaccine,fk_person) values(4,'09-Oct-2020','SinoPharm',1);
insert into dose(number_of_doses,dose_date,fk_vaccine,fk_person) values(5,'15-Mar-2020','SinoVac',2);
insert into dose(number_of_doses,dose_date,fk_vaccine,fk_person) values(1,'23-Apr-2021','Modrena',3);
insert into dose(number_of_doses,dose_date,fk_vaccine,fk_person) values(3,'18-Nov-2019','Pfizer',4);
insert into dose(number_of_doses,dose_date,fk_vaccine,fk_person) values(2,'10-Dec-2019','AstraZeneca',5);

commit;

--------------------------------Queries Part

--First Query (using where,join, and order by)
select person_ID,first_name,last_name from person p
inner join dose d
on d.fk_person=p.person_id
where p.age >= 20 order by p.age;

--Second Query (using count, and group by)
select vaccine_type,count(vaccine_name) number_of_vaccines from vaccine
group by vaccine_type;

--Third Query (using subquery)
select center_no,center_name from center
where fk_vaccine in (select vaccine_name from vaccine where center_location='Jeddah');

--Fourth Query (using aggregate functions)
select max(number_of_doses),min(number_of_doses),sum(number_of_doses),avg(number_of_doses) from dose;

--------------------------------Procedures part

--First procedure
create or replace procedure person_doses (per_id int)
is
p_id number;
f_name varchar(10);
l_name varchar(10);
age number;
no_of_doses number;
begin
p_id :=null;
f_name :=null;
l_name :=null;
age :=null;
no_of_doses :=null;

    select person_ID,first_name,last_name,age,number_of_doses
    into p_ID,f_name,l_name,age,no_of_doses
    from person p
    inner join dose d
    on d.fk_person=p.person_id
    where p.person_id=per_id;
    
dbms_output.put_line(p_ID ||','|| f_name ||','||l_name||','||age||','||no_of_doses);
end;

execute person_doses(1);

--Second procedure
create or replace procedure person_name(f_name varchar2,p_id int)
is
begin
    UPDATE person SET first_name = f_name where person_id = p_id;
    commit;
end;

execute person_name('Sara',3);

select * from person 