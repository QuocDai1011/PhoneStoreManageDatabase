CREATE TABLE Role (
    RoleID INT PRIMARY KEY IDENTITY(1, 3),
    RoleName VARCHAR(10) NOT NULL,
    RoleDescription TEXT
);

CREATE TABLE Account (
    AccountID INT PRIMARY KEY IDENTITY(1,3),
    RoleID INT REFERENCES Role(RoleID),
    Username VARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL CHECK (
        LEN(Password) >= 8                     -- Độ dài tối thiểu 8 ký tự
        AND PATINDEX('%[A-Za-z]%', Password) > 0  -- Có ít nhất 1 chữ cái
        AND PATINDEX('%[0-9]%', Password) > 0     -- Có ít nhất 1 số
    ),
    CreateAt DATE DEFAULT GETDATE(),
    UpdateAt DATE DEFAULT GETDATE()
);

CREATE TABLE EmployeeProfile (
    EmployeeID INT PRIMARY KEY IDENTITY(1,3),
    AccountID INT REFERENCES Account(AccountID),
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
	Gender bit NOT NULL CHECK(Gender = 0 OR Gender = 1),
    Email VARCHAR(255) UNIQUE,
    PhoneNumber VARCHAR(20) NOT NULL CHECK(PhoneNumber LIKE '0%' AND LEN(PhoneNumber) = 10 AND PhoneNumber NOT LIKE '%[^0-9]%'),
    Address TEXT,
    Position VARCHAR(255),
    Salary DECIMAL(10,2) CHECK(Salary > 0),
    CreateAt DATE DEFAULT GETDATE(),
    UpdateAt DATE DEFAULT GETDATE()
);

CREATE TABLE CustomerProfile (
    CustomerID INT PRIMARY KEY IDENTITY(1,3),
    AccountID INT REFERENCES Account(AccountID),
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    PhoneNumber VARCHAR(20) NOT NULL CHECK(PhoneNumber LIKE '0%' AND LEN(PhoneNumber) = 10 AND PhoneNumber NOT LIKE '%[^0-9]%'),
    Address TEXT,
    CreateAt DATE DEFAULT GETDATE(),
    UpdateAt DATE DEFAULT GETDATE()

);

CREATE TABLE Category (
    CategoryID INT PRIMARY KEY, -- co the tu nhap ID loai hang
    Name VARCHAR(255) NOT NULL
);

CREATE TABLE Brand (
    BrandID INT PRIMARY KEY, -- co the tu nhap ID cho brand
    Name VARCHAR(255) NOT NULL
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY, -- co the tu nhap ID cho san pham
    CategoryID INT,
    BrandID INT,
    Name VARCHAR(255) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK(Price > 0),
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0),
    Description TEXT,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    FOREIGN KEY (BrandID) REFERENCES Brand(BrandID)
);

CREATE TABLE Cart (
    CartID INT PRIMARY KEY IDENTITY(1,3),  -- Tự tăng
    AccountID INT NOT NULL,                 -- Giỏ hàng của ai?
    CreateAt DATETIME DEFAULT GETDATE(),    -- Thời gian tạo giỏ hàng
    UpdateAt DATETIME DEFAULT GETDATE(),    -- Thời gian cập nhật giỏ hàng
    
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE CartDetail (
    CartDetailID INT PRIMARY KEY IDENTITY(1,3),     -- Khóa chính tự tăng
    CartID INT NOT NULL,                            -- Tham chiếu đến Cart
    ProductID INT NOT NULL,                         -- Sản phẩm nào?
    Quantity INT NOT NULL CHECK (Quantity > 0),     -- Số lượng sản phẩm
    TotalCost DECIMAL(10,2) NOT NULL CHECK (TotalCost > 0), -- Tổng tiền của sản phẩm này (Quantity * đơn giá)
    
    FOREIGN KEY (CartID) REFERENCES Cart(CartID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY IDENTITY(1,3),
    PaymentType VARCHAR(255) NOT NULL,
    PaymentDescription TEXT
);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,3),
    AccountID INT NOT NULL,
    PaymentID INT NOT NULL,
    CartID INT NOT NULL,
    OrderDate DATE DEFAULT GETDATE(),
    TotalPrice DECIMAL(10,2) NOT NULL CHECK (TotalPrice >= 0),
    Status VARCHAR(50) NOT NULL, -- Ví dụ: 'Pending', 'Completed'
    
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID),
    FOREIGN KEY (CartID) REFERENCES Cart(CartID)
);

CREATE TRIGGER trg_UpdateTotalCost_CartDetail
ON CartDetail
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Cập nhật lại TotalCost cho các bản ghi vừa được thêm hoặc sửa
    UPDATE cd
    SET cd.TotalCost = cd.Quantity * p.Price
    FROM CartDetail cd
    INNER JOIN inserted i ON cd.CartDetailID = i.CartDetailID
    INNER JOIN Product p ON cd.ProductID = p.ProductID
END;

ALTER TABLE [dbo].[Product] ADD Image VARCHAR(255);





