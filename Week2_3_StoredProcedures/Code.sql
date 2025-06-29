-- DROP TABLES
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Loans;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Customers;

-- CREATE TABLES
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

-- INSERT DATA
INSERT INTO Customers VALUES
(1, 'John Doe', '1985-05-15', 1000.00, FALSE, CURDATE()),
(2, 'Jane Smith', '1960-07-20', 1500.00, FALSE, CURDATE());

INSERT INTO Accounts VALUES
(1, 1, 'Savings', 1000.00, CURDATE()),
(2, 2, 'Checking', 1500.00, CURDATE());

INSERT INTO Transactions VALUES
(1, 1, CURDATE(), 200.00, 'Deposit'),
(2, 2, CURDATE(), 300.00, 'Withdrawal');

INSERT INTO Loans VALUES
(1, 1, 5000.00, 5.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 60 MONTH)),
(2, 2, 3000.00, 4.50, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 10 DAY));
TRUNCATE TABLE Employees;

INSERT INTO Employees VALUES
(1, 'Alice Johnson', 'Manager', 70000.00, 'HR', STR_TO_DATE('2015-06-15', '%Y-%m-%d')),
(2, 'Bob Brown', 'Developer', 60000.00, 'IT', STR_TO_DATE('2017-03-20', '%Y-%m-%d'));


-- DROP PROCEDURES
DROP PROCEDURE IF EXISTS ProcessMonthlyInterest;
DROP PROCEDURE IF EXISTS UpdateEmployeeBonus;
DROP PROCEDURE IF EXISTS TransferFunds;

-- CREATE PROCEDURES
DELIMITER //

CREATE PROCEDURE ProcessMonthlyInterest()
BEGIN
    UPDATE Accounts
    SET Balance = Balance * 1.01
    WHERE AccountType = 'Savings';
END;
//
-- Change delimiter
DELIMITER //

CREATE PROCEDURE UpdateEmployeeBonus(
    IN dept_name VARCHAR(50),
    IN bonus_percent DECIMAL(5,2)
)
BEGIN
    UPDATE Employees
    SET Salary = Salary + (Salary * bonus_percent / 100)
    WHERE Department = dept_name;
END;
//

-- Reset delimiter
DELIMITER ;


-- Set custom delimiter
DELIMITER //

CREATE PROCEDURE TransferFunds(
    IN from_account INT,
    IN to_account INT,
    IN amount DECIMAL(10,2)
)
BEGIN
    DECLARE from_balance DECIMAL(10,2);

    -- Get source account balance
    SELECT Balance INTO from_balance
    FROM Accounts
    WHERE AccountID = from_account;

    -- Check balance
    IF from_balance >= amount THEN
        -- Deduct from source
        UPDATE Accounts
        SET Balance = Balance - amount
        WHERE AccountID = from_account;

        -- Add to destination
        UPDATE Accounts
        SET Balance = Balance + amount
        WHERE AccountID = to_account;
    ELSE
        -- Error: insufficient funds
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient funds in source account';
    END IF;
END;
//

-- Reset delimiter
DELIMITER ;
SET SQL_SAFE_UPDATES = 0;

-- CALL PROCEDURES
CALL ProcessMonthlyInterest();
CALL UpdateEmployeeBonus('IT', 10);
CALL TransferFunds(1, 2, 300.00);

-- VIEW OUTPUT
SELECT * FROM Accounts;
SELECT * FROM Employees;