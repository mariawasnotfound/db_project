-- 1. Список сотрудников, работающих продавцами, отсортированный по дате принятия на работу
SELECT emp.first_name, emp.last_name, emp.middle_name, pos.name AS position
FROM Employees emp
JOIN Positions pos ON emp.position = pos.position_id
WHERE pos.name IN ('Продавец', 'Главный продавец')
ORDER BY emp.hire_date;

-- 2. Список сотрудников и количество заказов, выполненных ими, по убыванию 
SELECT emp.first_name, emp.last_name, emp.middle_name, pos.name AS position, COUNT(s.order_) AS orders_count
FROM Employees emp
JOIN Positions pos ON emp.position = pos.position_id
INNER JOIN Sales s ON emp.employee_id = s.seller
GROUP BY emp.employee_id, pos.position_id
ORDER BY orders_count DESC;

-- 3. Топ-5 самых популярных товаров по количеству продаж
SELECT prod.name, COUNT(s.product) AS sales_count
FROM Sales s
JOIN Products prod ON s.product = prod.product_id
GROUP BY prod.name
ORDER BY sales_count DESC
LIMIT 5;

-- 4. Список покупателей, заказавших не менее 3 товаров
SELECT customer_id, first_name, last_name, middle_name
FROM Customers
WHERE customer_id IN (
    SELECT o.customer
    FROM Orders o
    JOIN Sales s ON o.order_id = s.order_
    GROUP BY o.order_id, o.customer
    HAVING COUNT(s.product) >= 3
);

-- 5. Название самого дешевого продукта
SELECT name 
FROM Products 
WHERE price = (
    SELECT MIN(price) 
    FROM Products
);

-- 6. Состав самого дорогого продукта
SELECT p.name as product, i.name, c.amount, i.measure_unit
FROM Compositions c
JOIN Ingredients i ON c.ingredient = i.ingredient_id
join Products p on c.product = p.product_id
WHERE c.product = (
    SELECT product_id 
    FROM Products 
    WHERE category = 1 
    ORDER BY price DESC 
    LIMIT 1
);

-- 7. Пары актуальных продуктов с одинаковой ценой и из одной категории
SELECT p1.name AS product_1, p2.name AS product_2, p1.price
FROM Products p1
JOIN Products p2 ON p1.price = p2.price
WHERE p1.category = p2.category 
  AND p1.product_id != p2.product_id
  AND p1.product_id < p2.product_id
  AND p1.valid_from <= CURRENT_DATE AND p1.valid_to IS NULL
  AND p2.valid_from <= CURRENT_DATE AND p2.valid_to IS NULL
;

-- 8. Средняя цена товара в категории и разница цены товара от средней цены категории (в процентах) по убыванию
SELECT 
    p.name,
    p.price,
    AVG(p.price) OVER (PARTITION BY p.category) AS average_price,
    ROUND((p.price / AVG(p.price) OVER (PARTITION BY p.category) - 1) * 100, 2) AS difference_percent
FROM Products p
WHERE p.valid_to IS NULL
ORDER BY difference_percent DESC;

-- 9. Список акутальных товаров, которые никогда не покупали
SELECT p.name
FROM Products p
LEFT JOIN Sales s ON p.product_id = s.product
WHERE s.product IS NULL AND p.valid_to IS NULL;

-- 10. Список последних заказов покупателей с товарами
SELECT 
    c.first_name, 
    c.last_name, 
    o.date AS last_order_date,
    RANK() OVER (PARTITION BY c.customer_id ORDER BY o.date DESC) AS order_rank,
    STRING_AGG(p.name, ', ') AS products
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer
JOIN Sales s ON o.order_id = s.order_
JOIN Products p ON s.product = p.product_id
WHERE o.date IS NOT NULL
GROUP BY c.customer_id, o.order_id, c.first_name, c.last_name, o.date
ORDER BY c.last_name, date DESC;

-- 11. Количество сотрудников на каждой должности по убыванию
SELECT p.name AS position_name, COUNT(e.employee_id) AS employees_count
FROM Employees e
RIGHT JOIN Positions p ON e.position = p.position_id
GROUP BY p.name
ORDER BY employees_count DESC;

-- 12. Количество продаж каждого продукта по убыванию
SELECT p.name AS product_name, COUNT(s.sale_id) AS sales_count
FROM Products p
FULL JOIN Sales s ON p.product_id = s.product
GROUP BY p.name
ORDER BY sales_count DESC;

-- 13. Список товаров, которые содержат ингредиент 'Шоколад темный 70%'
SELECT name
FROM Products
WHERE product_id = ANY (
    SELECT product
    FROM Compositions
    WHERE ingredient = ANY (
        SELECT ingredient_id
        FROM Ingredients
        WHERE name = 'Шоколад темный 70%'
    )
);

-- 14. Список товаров, цена которых выше всех продуктов из категории "Выпечка" (3)
SELECT name, price, measure_unit
FROM Products
WHERE price > ALL (
    SELECT price 
    FROM Products 
    WHERE category = 3 -- Выпечка
)
AND valid_to IS NULL
ORDER BY price;

-- 15. Список клиентов, сделавших заказ в 2025 году
SELECT c.first_name, c.last_name, c.phone_number
FROM Customers c
WHERE EXISTS (
    SELECT 1 
    FROM Orders o 
    WHERE o.customer = c.customer_id 
    AND o.date >= '2025-01-01'
)
ORDER BY c.last_name;

-- 16.
