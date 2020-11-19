# 1. Создать VIEW на основе запросов, которые вы сделали в ДЗ к уроку 3.
# 1-1. Create View: Выбрать среднюю зарплату по отделам.
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `employees`.`average_salary` AS
    SELECT 
        `dep`.`dept_no` AS `dept_no`,
        `dep`.`dept_name` AS `dept_name`,
        AVG(`sal`.`salary`) AS `AVG(sal.salary)`
    FROM
        (((`employees`.`employees` `emp`
        JOIN `employees`.`salaries` `sal` ON ((`emp`.`emp_no` = `sal`.`emp_no`)))
        JOIN `employees`.`dept_emp` `de` ON ((`de`.`emp_no` = `emp`.`emp_no`)))
        JOIN `employees`.`departments` `dep` ON ((`dep`.`dept_no` = `de`.`dept_no`)))
    WHERE
        ((`sal`.`from_date` <= CURDATE())
            AND (`sal`.`to_date` > CURDATE()))
    GROUP BY `dep`.`dept_no` , `dep`.`dept_name`

# 1-2. Create View: Выбрать максимальную зарплату у сотрудника.
    CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `max_salary` AS
    SELECT 
        `emp`.`emp_no` AS `emp_no`,
        `emp`.`first_name` AS `first_name`,
        `emp`.`last_name` AS `last_name`,
        `dep`.`dept_name` AS `dept_name`,
        MAX(`sal`.`salary`) AS `MAX(sal.salary)`
    FROM
        (((`employees` `emp`
        JOIN `salaries` `sal` ON ((`emp`.`emp_no` = `sal`.`emp_no`)))
        JOIN `dept_emp` `de` ON ((`de`.`emp_no` = `emp`.`emp_no`)))
        JOIN `departments` `dep` ON ((`dep`.`dept_no` = `de`.`dept_no`)))
    GROUP BY `emp`.`emp_no`


# 2. Создать функцию, которая найдет менеджера по имени и фамилии.
CREATE DEFINER=`root`@`localhost` FUNCTION `Search_employees`(firstName VARCHAR(50) CHARACTER SET utf8, lastName VARCHAR(50) CHARACTER SET utf8) RETURNS int
    DETERMINISTIC
BEGIN
 DECLARE emp_no INT;
SELECT 
    employees.emp_no
INTO emp_no FROM
    employees
WHERE
    employees.first_name = firstName
        AND employees.last_name = lastName;
 RETURN emp_no;
 END


# 3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.
 CREATE 
    DEFINER = CURRENT_USER 
    TRIGGER  `employees_AFTER_INSERT`
 AFTER INSERT ON `employees` FOR EACH ROW 
    BEGIN
    INSERT INTO emplyees.salaries (emp_no, salary, from_date)
    VALUES (NEW.emp_no, NEW.salary + 1000, CURDATE());
    END