# База данных «Страны и города мира»:
# 1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
select ctr.title, reg.title, cit.title
  from geodata._cities c
left join geodata._regions r on c.region_id = r.id
left join geodata._countries c on r.country_id = c.id;

# 2. Выбрать все города из Московской области.
select reg.title, cit.title
  from _cities c
  join _regions r on c.region_id = r.id
 where r.title like 'Московская область';

# База данных «Сотрудники»:
USE 
# 1. Выбрать среднюю зарплату по отделам.
select dep.dept_no, dep.dept_name, avg(sal.salary)
  from employees.employees emp
  join employees.salaries sal on emp.emp_no = sal.emp_no
  join employees.dept_emp de on de.emp_no = emp.emp_no
  join employees.departments dep on dep.dept_no = de.dept_no
where sal.from_date <= curdate()
  and sal.to_date > curdate()
group by dep.dept_no, dep.dept_name;

# 2. Выбрать максимальную зарплату у сотрудника.
select emp.emp_no, emp.first_name, emp.last_name, dep.dept_name, max(sal.salary)
  from employees.employees emp
  join employees.salaries sal on emp.emp_no = sal.emp_no
  join employees.dept_emp de on de.emp_no = emp.emp_no
  join employees.departments dep on dep.dept_no = de.dept_no
group by emp.emp_no;

# 3. Удалить одного сотрудника, у которого максимальная зарплата.
delete from employees.employees where emp_no = (
  select s.emp_no
    from employees.salaries s
   where s.from_date <= curdate() and s.to_date > curdate()
  order by s.salary desc
  limit 1
 );

# 4. Посчитать количество сотрудников во всех отделах.
select de.dept_no, dep.dept_name, count(*)
  from employees.employees emp
  join employees.dept_emp de on de.emp_no = emp.emp_no
  join employees.departments dep on dep.dept_no = de.dept_no
where de.from_date <= curdate()
  and de.to_date > curdate()
group by dep.dept_no;

# 5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.
select de.dept_no, dep.dept_name, count(*), sum(sal.salary)
  from employees.employees emp
  join employees.salaries sal on emp.emp_no = sal.emp_no and sal.from_date <= curdate() and sal.to_date > curdate()
  join employees.dept_emp de on de.emp_no = emp.emp_no
  join employees.departments dep on dep.dept_no = de.dept_no
 where de.from_date <= curdate()
   and de.to_date > curdate()
group by dep.dept_no;
