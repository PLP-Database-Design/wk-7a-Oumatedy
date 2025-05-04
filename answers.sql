-- Question 1: Achieving 1NF
-- We are transforming the table so that each product in the Products column is stored in its own row, eliminating the repeating group.

create database plpw7db;
use plpw7db;

-- Question 1: Achieving 1NF
-- Create the original unnormalized table
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Insert the data
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Step to convert to 1NF
-- We split the Products column into individual rows using a helper method.
-- Since MySQL does not support SPLIT_STRING natively, we manually unroll the data. 
-- To eliminate repeating groups in the Products column, split the comma-separated values into individual rows:

-- Create the normalized version of the table
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Insert normalized data
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');



-- Question 2: Achieving 2NF
-- To move from 1NF to 2NF, we remove partial dependencies by separating customer data from the order-product relationship.
-- Remove the partial dependency (CustomerName depends only on OrderID, not the full composite key) by splitting the table:
use plpw7db; 

-- Create a separate Customer table (CustomerName depends only on OrderID)
CREATE TABLE Customer (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert unique customer data
INSERT INTO Customer (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Create a new OrderItems table where each non-key attribute depends on the full composite key
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Customer(OrderID)
);

-- Insert normalized order item data
INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);
-- Note: Quantity is added as an example of a non-key attribute that depends on the composite key (OrderID, Product).