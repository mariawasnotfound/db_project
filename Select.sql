-- 1. Список сотрудников, работающих продавцами, отсортированный по дате принятия на работу
SELECT emp.first_name, emp.last_name, emp.middle_name, pos.name AS position
FROM Employees emp
JOIN Positions pos ON emp.position = pos.position_id
WHERE pos.name IN ('Продавец', 'Главный продавец')
ORDER BY emp.hire_date;

