create table if not exists employees
(
  id serial primary key,
  fio varchar(255) not null,
  birthday date,
  startdate date not null,
  post varchar(255) not null,
  levels varchar(255),
  salary int not null,
  department_id smallint,
  driver boolean
  );

create table if not exists department
(
  dp_id serial primary key,
  names varchar(255) not null,
  id_boss int
);

create table if not exists evaluations
(
  id serial primary key,
  emp_id int not null,
  q1 varchar(1) not null,
  q2 varchar(1) not null,
  q3 varchar(1) not null,
  q4 varchar(1) not null
);

create view departments as
with count_department as (
  select department_id, count(id) emp_count
  from employees
  group by department_id
)
select a.names, c.fio, b.emp_count
from department a
left join count_department b on a.dp_id = b.department_id
left join employees c on a.id_boss = c.id ;

insert into department(names, id_boss)
values
('Бухгалтерия', 1),
('IT', 2),
('Охрана', 3),
('HR', 4),
('Маркетинг', 5);

insert into evaluations (emp_id, q1, q2, q3, q4)
values  
(1,'C','C','E','E'),
(2,'E','B','E','D'),
(3,'D','D','B','A'),
(4,'A','B','B','B'),
(5,'C','A','D','E'),
(6,'C','B','C','A'),
(7,'E','A','B','A'),
(8,'C','D','C','C'),
(9,'E','A','C','D'),
(10,'E','A','E','D'),
(11,'A','A','E','D'),
(12,'D','C','C','E'),
(13,'C','D','C','D'),
(14,'C','E','A','E'),
(15,'D','A','E','B'),
(16,'D','B','C','E'),
(17,'A','C','C','A'),
(18,'E','D','C','E'),
(19,'A','B','A','E'),
(20,'A','C','A','C'),
(21,'B','D','D','B'),
(22,'D','B','B','C'),
(23,'A','C','E','D'),
(24,'A','A','C','B'),
(25,'B','B','C','C'),
(26,'E','C','D','D'),
(27,'C','B','E','D'),
(28,'A','D','C','C'),
(29,'A','E','A','E'),
(30,'A','E','D','A'),
(31,'C','A','A','A'),
(32,'B','E','C','D'),
(33,'A','D','D','C'),
(34,'B','B','A','D'),
(35,'A','B','E','C'),
(36,'E','C','D','C'),
(37,'C','A','A','A'),
(38,'A','B','B','A'),
(39,'A','E','E','D'),
(40,'D','D','C','D'),
(41,'D','A','C','C'),
(42,'A','A','A','B'),
(43,'E','E','B','E'),
(44,'B','B','C','D'),
(45,'C','A','D','C'),
(46,'A','E','D','B'),
(47,'C','C','B','D'),
(48,'E','B','D','D'),
(49,'A','D','E','B'),
(50,'A','A','D','E'),
(51,'B','C','A','E'),
(52,'C','B','B','B'),
(53,'B','D','E','E'),
(54,'B','D','C','E'),
(55,'B','D','E','E'),
(56,'E','A','A','D'),
(57,'B','E','E','B'),
(58,'E','D','A','A'),
(59,'C','C','A','B'),
(60,'C','B','E','A'),
(61,'B','B','E','C'),
(62,'B','D','A','D'),
(63,'A','C','C','D'),
(64,'D','D','E','A'),
(65,'A','D','A','B'),
(66,'B','E','A','A'),
(67,'C','C','B','E'),
(68,'B','C','A','D'),
(69,'B','E','D','B'),
(70,'C','D','B','B'),
(71,'A','A','D','E'),
(72,'E','A','B','D'),
(73,'D','E','E','E'),
(74,'A','A','B','D'),
(75,'C','A','B','E'),
(76,'E','C','A','B'),
(77,'D','B','C','A'),
(78,'D','D','C','D'),
(79,'D','D','B','E'),
(80,'B','A','B','E'),
(81,'E','D','B','A'),
(82,'A','A','C','D'),
(83,'D','B','A','D'),
(84,'A','B','C','C'),
(85,'E','D','B','C'),
(86,'A','B','D','E'),
(87,'D','B','C','A'),
(88,'A','E','C','E'),
(89,'D','D','C','E'),
(90,'B','E','B','A'),
(91,'E','A','C','B'),
(92,'E','B','E','E'),
(93,'B','C','B','C'),
(94,'A','D','B','E'),
(95,'A','A','B','E'),
(96,'A','C','A','A'),
(97,'B','A','A','E'),
(98,'C','A','E','E'),
(99,'B','B','C','C'),
(100,'B','B','C','E');

insert into employees(fio, birthday, startdate, post, levels, salary, department_id, driver)
values

('Chantale Watts','1999-07-11','2018-09-19','team_lead','senior',162691,1,false),
('Clinton Curry','2001-06-26','2019-06-29','team_lead','senior',164037,2,true),
('Ulla Stout','1998-01-05','2021-08-05','team_lead','senior',365852,3,false),
('Yuri Mendoza','1997-11-25','2021-04-09','team_lead','senior',232793,4,true),
('Chester Steele','2002-06-02','2020-10-03','team_lead','jun',187597,5,true),
('Davis Wooten','2000-09-14','2019-12-07','DS','senior',288139,2,true),
('Arsenio Holland','1992-06-08','2016-04-15','DE','jun',241867,5,false),
('Orli Warner','1991-11-30','2020-03-07','DA','middle',376273,3,false),
('Matthew Hyde','1995-06-17','2018-11-18','Бухгалтер','senior',104474,1,true),
('Imogene Patel','1995-03-27','2019-01-01','DA','senior',208895,5,false),
('Hilary Owens','1994-09-02','2017-08-29','DA','lead',340682,4,false),
('Jeanette Gray','2001-04-06','2018-07-06','DE','senior',341160,2,true),
('Vaughan Coffey','1994-11-17','2017-11-06','DE','lead',392051,2,true),
('Paki Mcintyre','2000-05-17','2017-12-20','DA','jun',212280,2,true),
('Oren Head','1996-11-27','2018-11-10','Сторож','senior',75291,3,false),
('Kennan Mercado','1993-09-29','2018-11-06','Бухгалтер','jun',112421,1,false),
('Zelda Randolph','2001-05-28','2020-06-02','Биба','jun',117360,4,true),
('Emery Turner','1991-02-26','2021-01-15','Биба','middle',135684,2,false),
('Shafira Nolan','2002-04-16','2016-08-17','DS','lead',128012,5,true),
('Leah Jarvis','2003-05-17','2018-04-29','DE','senior',373353,2,true),
('Evan Norton','2002-09-04','2016-08-31','Биба','lead',393000,1,false),
('Edward Hines','1996-05-26','2019-06-22','Бухгалтер','senior',198387,1,false),
('Cullen Hahn','1995-10-14','2019-09-15','Боба','senior',258562,2,false),
('Porter Welch','2002-04-28','2018-03-16','Бухгалтер','middle',214399,1,true),
('Macaulay Leach','2003-08-14','2017-01-28','Боба','jun',271876,2,false),
('Victoria Knowles','2001-02-12','2020-03-26','Боба','middle',172624,4,false),
('Ryan Powell','1997-02-26','2018-09-19','Сторож','middle',142099,3,true),
('Ingrid Barrett','1998-05-09','2019-05-15','DE','middle',148715,5,false),
('Charde Thornton','1999-11-15','2018-01-29','Биба','jun',74444,5,false),
('Jamal Barrett','1997-02-19','2018-06-27','DA','lead',213300,3,true),
('Latifah Russo','1998-03-10','2020-05-12','Боба','middle',138232,2,true),
('Garth Irwin','1995-11-01','2015-11-09','DE','senior',306741,1,true),
('Clementine Trujillo','1998-04-19','2018-08-16','DA','jun',307967,1,true),
('Vance Mullen','1995-07-12','2017-11-22','Сторож','jun',310679,3,true),
('Arden Quinn','1992-07-12','2015-11-24','Биба','jun',377478,2,false),
('Dalton Roy','1994-09-22','2019-01-22','Бухгалтер','jun',386905,1,true),
('Amena Byers','2003-11-04','2016-09-21','DS','lead',136237,3,true),
('Octavia Rich','2002-06-15','2017-09-19','Сторож','lead',338559,3,false),
('Kellie Fitzgerald','2001-07-12','2016-03-18','Сторож','lead',365091,3,false),
('Erich Moon','1998-06-24','2021-06-17','Боба','lead',77852,2,false),
('April Yates','1995-01-06','2020-03-21','DE','senior',155233,4,true),
('Portia Dale','1993-05-15','2017-05-18','Сторож','lead',103480,3,true),
('Plato Hicks','1995-09-07','2019-01-11','Боба','jun',131256,4,true),
('Magee Buck','1992-08-02','2021-04-24','Бухгалтер','middle',198963,1,false),
('Velma Cortez','1992-03-01','2016-06-18','Боба','jun',99929,2,true),
('Jared Barton','1992-08-12','2019-05-11','Сторож','lead',357119,3,true),
('Hakeem Hodge','1992-09-14','2016-03-01','DE','lead',198513,4,false),
('Paki Ray','2002-03-25','2017-10-19','Сторож','senior',319393,3,true),
('Raymond Schroeder','1995-09-17','2017-12-22','DE','middle',160192,5,false),
('Kyra Hahn','1998-07-18','2016-09-09','DS','middle',292182,2,true),
('Maris Gibbs','1992-11-22','2018-01-28','DS','middle',363604,2,true),
('April Short','1996-09-16','2017-10-21','Биба','lead',192678,4,false),
('Herrod York','1993-07-21','2016-10-04','DA','middle',273891,4,false),
('Summer Dejesus','1997-12-29','2017-11-08','Сторож','jun',106492,3,true),
('Asher Walsh','2003-02-13','2018-03-20','DS','lead',147872,5,false),
('Rhea Park','2002-05-06','2018-12-11','DA','jun',325399,2,false),
('Sigourney Maddox','1993-11-19','2018-02-17','DA','lead',114820,5,false),
('Jin Weber','1999-09-13','2017-06-23','DS','middle',181908,2,false),
('Anastasia Williams','2002-09-19','2021-06-20','Сторож','middle',391488,3,false),
('Davis Navarro','2003-09-21','2016-04-28','DE','lead',290219,4,false),
('Shad Newton','1998-01-24','2019-07-04','Биба','lead',114758,2,true),
('Madison Head','2000-07-16','2021-04-21','Боба','senior',360454,4,false),
('Garth Rosales','2000-07-16','2017-03-17','Боба','middle',210332,2,true),
('Noelani Mayer','1994-07-01','2016-03-17','DE','jun',389227,1,false),
('Rashad Bowen','1998-11-03','2021-08-24','DS','lead',214442,4,true),
('Raven Barker','2000-08-24','2020-01-16','Бухгалтер','jun',118965,1,true),
('Velma Mclean','1996-08-28','2016-05-17','Биба','senior',242327,2,true),
('Neve Hendrix','1995-06-02','2020-02-23','Сторож','lead',270092,3,true),
('Price Benson','1993-04-21','2021-04-29','Боба','middle',108163,2,false),
('Abigail Bush','2001-04-10','2021-05-28','Боба','senior',214344,1,false),
('Jeremy Stephenson','1997-01-28','2021-08-30','DS','lead',238701,2,true),
('Kirk Lowe','2003-07-04','2021-07-07','Сторож','lead',357102,3,true),
('Kiayada Moss','1997-12-19','2016-12-30','DA','jun',366018,2,true),
('Talon Bridges','2002-11-30','2020-11-26','Сторож','middle',391248,3,false),
('Dalton Elliott','1996-11-17','2020-02-16','Сторож','senior',201845,3,true),
('Dana Steele','1997-05-01','2018-04-14','Бухгалтер','senior',145193,1,false),
('Xenos Montoya','1991-04-18','2020-11-17','DS','middle',123550,5,true),
('Geoffrey Wolfe','1999-08-25','2020-12-14','Бухгалтер','senior',240587,1,true),
('Doris Stokes','1991-11-30','2017-10-01','Бухгалтер','senior',227953,1,true),
('Luke Webb','2000-06-05','2018-08-13','Биба','senior',135777,3,true),
('Brett David','2000-06-19','2017-06-11','Бухгалтер','jun',227628,1,true),
('Kalia Medina','1993-06-02','2020-04-20','DE','jun',351086,5,true),
('Libby Kidd','1996-10-09','2016-09-22','Сторож','jun',322725,3,false),
('Aiko Byrd','1996-03-17','2021-09-19','DA','middle',318157,2,true),
('Igor Soto','1999-02-19','2016-02-04','DA','middle',170038,2,true),
('Shelley Harper','2002-07-30','2017-06-16','Боба','jun',118334,3,false),
('Pamela Fletcher','1996-10-06','2020-01-08','Боба','middle',108059,5,true),
('Kirestin Brady','2001-07-11','2016-11-10','Биба','middle',373495,4,true),
('Elton Ortiz','2000-07-01','2016-09-23','Боба','middle',152885,5,true),
('Felicia Wynn','1995-05-10','2015-12-12','DA','jun',108784,1,true),
('Salvador Sharpe','2001-02-07','2017-07-28','Биба','senior',311687,4,false),
('Ulric Daniels','1991-11-15','2020-12-14','DE','middle',316985,2,true),
('Kathleen Sweeney','1993-04-27','2019-10-31','Сторож','middle',307292,3,true),
('Adara Harding','1993-08-24','2017-08-02','DS','lead',163082,4,false),
('Emerson Cardenas','1995-04-20','2020-08-11','DE','middle',289550,4,false),
('Anastasia Hughes','2002-04-09','2020-04-25','Биба','lead',93110,2,false),
('Rae Aguilar','1998-08-27','2019-09-13','DA','jun',339997,3,true),
('Lester Neill','1998-02-13','2021-06-15','DA','middle',180681,3,false),
('Blossom Walters','2003-12-11','2018-04-30','DS','lead',202563,2,false),
('Dahlia English','1997-02-14','2017-10-04','DS','jun',378375,2,true);

-- Задание 5
insert into department(names, id_boss)
values
('AI', 101);

insert into employees(fio, birthday, startdate, post, levels, salary, department_id, driver)
values
('Mollie King', '1950-05-24', '2022-11-17', 'team_lead', 'senior', 500000, 6, true),
('Megan Figueroa', '1995-05-24', '2022-11-17', 'DS', 'senior', 45000, 6, true),
('Joel Cherry', '1994-05-24', '2022-11-17', 'DS', 'middle', 300000, 6, true);

--задание 6.1
select id, fio, age(now(), startdate) as experience
from employees;

--задание 6.2
select id, fio, age(now(), startdate) as experience
from employees
order by experience desc
limit 3;

--задание 6.3
select id
from employees
where driver = true;

--задание 6.4
select emp_id
from evaluations
where q1 in ('D', 'E') or q2 in ('D', 'E') or q3 in ('D', 'E') or q4 in ('D', 'E');

--задание 6.5
select max(salary) max_salary
from employees;

--задание 6.6
select names
from departments
order by emp_count desc
limit 1;

--задание 6.7
select id, age(now(), startdate) as experience
from employees
order by experience desc;

--задание 6.8
select levels, round(avg(salary)) avg_salary
from employees
group by levels;

--задание 6.9
select emp.*,
       1 -
    (case when q1 = 'A' then -0.2 when q1 = 'B' then -0.1 when q1 = 'C' then 0 when q1 = 'D' then 0.1 when q1 = 'E' then 0.2 end) -
    (case when q2 = 'A' then -0.2 when q2 = 'B' then -0.1 when q2 = 'C' then 0 when q2 = 'D' then 0.1 when q2 = 'E' then 0.2 end) -
    (case when q3 = 'A' then -0.2 when q3 = 'B' then -0.1 when q3 = 'C' then 0 when q3 = 'D' then 0.1 when q3 = 'E' then 0.2 end) -
    (case when q4 = 'A' then -0.2 when q4 = 'B' then -0.1 when q4 = 'C' then 0 when q4 = 'D' then 0.1 when q4 = 'E' then 0.2 end)
    as coef
from evaluations ev
left join employees emp on ev.emp_id = emp.id;