-- Create a database named BookStore
CREATE DATABASE BookStore;

-- Use the BookStore database
USE BookStore;

-- Book Management
-- Create book_language table
CREATE TABLE book_language (
    language_id INT PRIMARY KEY AUTO_INCREMENT,
    language_code VARCHAR(10) NOT NULL,
    language_name VARCHAR(50) NOT NULL
);

-- Create publisher table
CREATE TABLE publisher (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(255) NOT NULL
);

-- Creaye author table
CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    author_name VARCHAR(255) NOT NULL
);

-- Create book table
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(50) UNIQUE NOT NULL,
    num_pages INT,
    publication_date DATE,
    language_id INT,
    publisher_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

-- Create book_author table
CREATE TABLE book_author (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- User Management
-- Create admin user with all privileges
CREATE USER 'admin'@'localhost' IDENTIFIED BY '1234';

-- Grant all privileges to admin user
GRANT ALL PRIVILEGES ON BookStore.* TO 'admin'@'localhost';

-- Create manager user with limited privileges
CREATE USER 'manager'@'localhost' IDENTIFIED BY '5678';

-- Grant limited privileges to manager user
GRANT SELECT, INSERT, UPDATE ON BookStore.* TO 'manager'@'localhost';

-- Revoke specific privileges from manager user
REVOKE DROP, ALTER, CREATE, TRUNCATE ON BookStore.* FROM 'manager'@'localhost';

-- Create customer user with limited access
CREATE USER 'customer'@'localhost' IDENTIFIED BY '3456';

-- Grant limited privileges to customer user
GRANT SELECT ON BookStore.* TO 'customer'@'localhost';
-- GRANT INSERT, UPDATE ON BookStore.cust_order TO 'customer'@'localhost';

-- Create read-only user for reports
CREATE USER 'eport'@'localhost' IDENTIFIED BY '7890';

-- Grant read-only access to report user
GRANT SELECT ON BookStore.* TO 'bookstore_report'@'localhost';

-- Order Management Tables
-- Shipping Method
CREATE TABLE shipping_method (
    method_id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(100) NOT NULL,
    cost DECIMAL(10,2) NOT NULL
);

-- Order Status
CREATE TABLE order_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_value VARCHAR(20) NOT NULL
);

-- Customer Order
CREATE TABLE cust_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    customer_id INT NOT NULL,
    shipping_address_id INT NOT NULL,
    method_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(address_id),
    FOREIGN KEY (method_id) REFERENCES shipping_method(method_id)
);

-- Order Line
CREATE TABLE order_line (
    line_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Order History
CREATE TABLE order_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    status_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- Customer Management
-- Country
CREATE TABLE country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL
);

-- Address Status
CREATE TABLE address_status(
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_value VARCHAR(20) NOT NULL
);

-- Address
CREATE TABLE address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    street_number VARCHAR(10) NOT NULL,
    street_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state_province VARCHAR(50),
    postal_code VARCHAR(20) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Customer
CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Customer Address
CREATE TABLE customer_address (
    customer_id INT NOT NULL,
    address_id INT NOT NULL,
    status_id INT NOT NULL,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- Indexing

-- Create indexes on specific columns of the book table
CREATE INDEX idx_book_title ON book(title);
CREATE INDEX idx_book_isbn ON book(isbn);
CREATE INDEX idx_book_language ON book(language_id);
CREATE INDEX idx_book_publisher ON book(publisher_id);

-- Create indexes on specific columns of the customer table
CREATE INDEX idx_customer_email ON customer(email);
CREATE INDEX idx_customer_name ON customer(last_name, first_name);

-- Create indexes on specific columns of the order table
CREATE INDEX idx_order_customer ON cust_order(customer_id);
CREATE INDEX idx_order_date ON cust_order(order_date);
CREATE INDEX idx_order_shipping ON cust_order(shipping_address_id);

-- Create indexes on specific columns of the order line table
CREATE INDEX idx_orderline_order ON order_line(order_id);
CREATE INDEX idx_orderline_book ON order_line(book_id);

-- Create indexes on specific columns of the order history table
CREATE INDEX idx_orderhistory_order ON order_history(order_id);
CREATE INDEX idx_orderhistory_status ON order_history(status_id);
