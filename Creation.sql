-- Должности
CREATE TABLE IF NOT EXISTS Positions (
    position_id INT PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE
);

-- Сотрудники
CREATE TABLE IF NOT EXISTS Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(200) NOT NULL,
    last_name VARCHAR(200) NOT NULL,
    middle_name VARCHAR(200),
    position INT NOT NULL REFERENCES Positions(position_id),
    hire_date DATE NOT NULL
);

-- Покупатели
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(200) NOT NULL,
    last_name VARCHAR(200) NOT NULL,
    middle_name VARCHAR(200),
    phone_number VARCHAR(200) NOT NULL,
    email VARCHAR(200)
);

-- Категории
CREATE TABLE IF NOT EXISTS Categories (
    category_id INT PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE
);

-- Продукты
CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category INT NOT NULL REFERENCES Categories(category_id),
    measure_unit VARCHAR(20) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE DEFAULT NULL
);

-- Заказы
CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY,
    customer INT NOT NULL REFERENCES Customers(customer_id),
    date DATE NOT NULL
);

-- Продажа товара
CREATE TABLE IF NOT EXISTS Sales (
    sale_id INT PRIMARY KEY,
    order_ INT NOT NULL REFERENCES Orders(order_id),
    product INT NOT NULL REFERENCES Products(product_id),
    amount DECIMAL(10,2) NOT NULL,
    seller INT NOT NULL REFERENCES Employees(employee_id)
);

-- Ингредиенты
CREATE TABLE IF NOT EXISTS Ingredients (
    ingredient_id INT PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE
);

-- Состав товара
CREATE TABLE IF NOT EXISTS Compositions (
    composition_id INT PRIMARY KEY,
    product INT NOT NULL REFERENCES Products(product_id),
    ingredient INT NOT NULL REFERENCES Ingredients(ingredient_id),
    amount DECIMAL(10,2) NOT NULL
);
