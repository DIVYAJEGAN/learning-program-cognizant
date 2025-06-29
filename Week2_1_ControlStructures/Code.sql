-- Drop tables in safe order
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Loans;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Customers;

-- Create tables
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    DOB DATE,
    Balance DECIMAL(10,2),
    IsVIP BOOLEAN DEFAULT FALSE,
    LastModified DATE
);

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountType VARCHAR(20),
    Balance DECIMAL(10,2),
    LastModified DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionDate DATE,
    Amount DECIMAL(10,2),
    TransactionType VARCHAR(10),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY,
    CustomerID INT,
    LoanAmount DECIMAL(10,2),
    InterestRate DECIMAL(5,2),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Position VARCHAR(50),
    Salary DECIMAL(10,2),
    Department VARCHAR(50),
    HireDate DATE
);

-- Insert sample customer data
INSERT INTO Customers VALUES
(1, 'John Doe', '1985-05-15', 1000.00, FALSE, CURDATE()),
(2, 'Jane Smith', '1960-07-20', 1500.00, FALSE, CURDATE());

-- Insert account data
INSERT INTO Accounts VALUES
(1, 1, 'Savings', 1000.00, CURDATE()),
(2, 2, 'Checking', 1500.00, CURDATE());

-- Insert transaction data
INSERT INTO Transactions VALUES
(1, 1, CURDATE(), 200.00, 'Deposit'),
(2, 2, CURDATE(), 300.00, 'Withdrawal');

-- Insert loans
INSERT INTO Loans VALUES
(1, 1, 5000.00, 5.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 60 MONTH));

-- Add a loan for Jane that ends in 10 days (for reminder output)
INSERT INTO Loans VALUES
(2, 2, 3000.00, 4.50, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 10 DAY));

-- Insert employee data
INSERT INTO Employees VALUES
(1, 'Alice Johnson', 'Manager', 70000.00, 'HR', '2015-06-15'),
(2, 'Bob Brown', 'Developer', 60000.00, 'IT', '2017-03-20');

-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Scenario 1: Apply 1% interest discount to customers over 60 years old
UPDATE Loans l
JOIN Customers c ON l.CustomerID = c.CustomerID
SET l.InterestRate = l.InterestRate - 1
WHERE TIMESTAMPDIFF(YEAR, c.DOB, CURDATE()) > 60;

-- Scenario 2: Promote customers to VIP if balance > 10000
UPDATE Customers
SET IsVIP = TRUE
WHERE Balance > 10000;

-- Scenario 3: Display reminder messages for loans due in next 30 days
SELECT CONCAT('Reminder: Loan #', l.LoanID, ' for customer ', c.Name, 
              ' is due on ', DATE_FORMAT(l.EndDate, '%Y-%m-%d')) AS Reminder_Message
FROM Loans l
JOIN Customers c ON l.CustomerID = c.CustomerID
WHERE l.EndDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);
