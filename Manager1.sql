CREATE TABLE Role (
    RoleID INT PRIMARY KEY IDENTITY(1, 3),
    RoleName VARCHAR(10) NOT NULL,
    RoleDescription TEXT
);

-- thêm dữ liệu vào bảng Role để có thể tạo Account (nếu ko có tạo account sẽ lỗi vì ràng buộc khóa ngoại)
INSERT INTO [dbo].[Role]
           ([RoleName]
           ,[RoleDescription])
     VALUES
           ('NV', 'Nhan vien cua cua hang'),
		   ('KH', 'Khach hang cua cua hang'),
		   ('AD', 'Admin cua cua hang');


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

--SELECT * FROM Role; coi cái RoleID để điền vào bên dưới nha Cái RoleID chắc chắn sẽ không khớp đâu
INSERT INTO Account
           ([RoleID], [Username], [Password])
     VALUES
			(13, 'nhan321', '9e/OPVJnY0OsDcJ+FTingw=='), --mat khau la "123nhan" day la nick Nhan vien cua Nhan
		   (13, 'thong321', 'VykQbZhSM33xMygiPVA70w=='), --mat khau la "123thong" day la nick Nhan Vien cua Thong
		   (16, 'nhan333', '9e/OPVJnY0OsDcJ+FTingw=='), --mat khau la "123nhan" day la nick Khach hang cua Nhan
		   (16, 'thong333', 'VykQbZhSM33xMygiPVA70w=='), --mat khau la "123thong" day la nick Khach hang cua Thong
           (19, 'nhan123', '9e/OPVJnY0OsDcJ+FTingw=='), --mat khau la "123nhan" day la nick Admin cua Nhan
		   (19, 'thong123', 'VykQbZhSM33xMygiPVA70w=='), --mat khau la "123thong" day la nick Admin cua Thong
		   (19, 'dung123', 'PdbfoiE/UbdvNSZ39jvO8w==') --mat khau la "123dung" day la nick Admin cua cua Co Dung


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

-- SELECT * FROM Account; để coi AccountID tương ứng rồi đổi lại phía bên dưới nha, chắc chắn là không khớp đâu
INSERT INTO EmployeeProfile 
    (AccountID, FirstName, LastName, Gender, Email, PhoneNumber, Address, Position, Salary)
VALUES 
    (31, 'Nhan', 'Dinh', 1, 'nhan321@example.com', '0123456789', '123 ABC Street', 'Nhân viên', 7000000.00),
    (34, 'Thong', 'Tran', 1, 'thong321@example.com', '0987654321', '456 DEF Street', 'Nhân viên', 7200000.00),
    (22, 'Nhan', 'Dinh', 1, 'nhan123@example.com', '0912345678', '789 GHI Street', 'Admin', 10000000.00),
    (25, 'Thong', 'Le', 1, 'thong123@example.com', '0934567890', '321 JKL Street', 'Admin', 10500000.00),
    (28, 'Dung', 'Tran', 0, 'dung123@example.com', '0961122334', '159 MNO Street', 'Admin', 11000000.00);





-- thêm cột ghi chú, ngày vào làm, ngày sinh cho nhân viên
ALTER TABLE EmployeeProfile
ADD 
    Note TEXT,
    DateOfBirth DATE DEFAULT GETDATE(),
    StartDate DATE DEFAULT GETDATE();


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

--SELECT * FROM Account; để coi AccountID tương ứng rồi đổi lại phía bên dưới nha, chắc chắn là không khớp đâu
INSERT INTO CustomerProfile 
    (AccountID, FirstName, LastName, Email, PhoneNumber, Address)
VALUES 
    (37, 'Nhan', 'Dinh', 'nhan333@example.com', '0901234567', '123 Phan Van Tri, Go Vap, TP.HCM'),
    (40, 'Thong', 'Tran', 'thong333@example.com', '0937654321', '456 Le Van Sy, Tan Binh, TP.HCM');


CREATE TABLE Category (
    CategoryID INT PRIMARY KEY, -- co the tu nhap ID loai hang
    Name VARCHAR(255) NOT NULL
);

--thêm dữ liệu vào bảng Category mới thêm được product, mấy cái laptop, ... chỉ là tượng trưng không cần dùng
INSERT INTO [dbo].[Category]
           ([CategoryID]
           ,[Name])
     VALUES
           (1, 'Điện Thoại'),
		   (2, 'Máy Tính Bảng'),
		   (3, 'Laptop'),
		   (4, 'Phụ Kiện')

CREATE TABLE Brand (
    BrandID INT PRIMARY KEY, -- co the tu nhap ID cho brand
    Name VARCHAR(255) NOT NULL
);

--thêm dữ liệu vào bảng Brand để thêm được sản phẩm
INSERT INTO [dbo].[Brand]
           ([BrandID]
           ,[Name])
     VALUES
           (1, 'IPhone'),
		   (2, 'SamSung'),
		   (3, 'Oppo'),
		   (4, 'Realme'),
		   (5, 'Xiaome'),
		   (6, 'Huawei'),
		   (7, 'Nokia')

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

 --xoa cot hinh anh trong bang product -- sua ma contrainst lai nha
 ALTER TABLE Product
DROP CONSTRAINT CK__Product__Price__534D60F1;

 ALTER TABLE Product
DROP CONSTRAINT CK__Product__StockQu__5441852A;

 ALTER TABLE Product
DROP COLUMN [Image], [Price], [StockQuantity];

--them du lieu vao bang product
INSERT INTO [dbo].[Product]
           ([ProductID],[CategoryID],[BrandID],[Name],[Description])
     VALUES
           (1, 1, 'Iphone', 'Iphone 14', 'Dien thoai')



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

-- them bang product detail (chi tiet san pham)
CREATE TABLE ProductDetail (
	ProductDetailID INT PRIMARY KEY IDENTITY(1,3),
	ProductID INT NOT NULL,
	Ram INT NOT NULL CHECK(Ram > 0),
	Rom INT NOT NULL CHECK(Rom > 0),
	Chip VARCHAR(20) NOT NULL,
	ScreenSize FLOAT NOT NULL CHECK(ScreenSize > 0), -- kich thuoc man hinh (inch)
	ScreenParameters VARCHAR(20) NOT NULL, -- thong so man hinh (vd: 1990 x 2000)
	BatteryCapacity FLOAT NOT NULL CHECK(BatteryCapacity > 0), -- dung luong pin (mAh)
	AdditionalAmount DECIMAL(10,2) NOT NULL CHECK(AdditionalAmount > 0), -- so tien cong them khi len nang cap phien ban
	Color VARCHAR(15), -- mau dien thoai
	Image VARCHAR(255), -- hinh anh cua dien thoai (luu ten file anh)
	Description TEXT,
	FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
)

--them cot price va so hang ton kho vao productdetail
ALTER TABLE ProductDetail
ADD 
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0);

-- bo cot AdditionalAmount
ALTER TABLE ProductDetail
DROP CONSTRAINT CK__ProductDe__Addit__06CD04F7;
ALTER TABLE ProductDetail
DROP COLUMN AdditionalAmount;

--them du lieu vao bang productdetail
INSERT INTO ProductDetail (
    ProductID, Ram, Rom, Chip, ScreenSize, ScreenParameters,
    BatteryCapacity, AdditionalAmount, Color, Image, Description,
    Price, StockQuantity
)
VALUES (
    1, 8, 128, 'Snapdragon 8 Gen 2', 6.7, '2400 x 1080',
    5000, 100.00, 'Black', 'phone_black.jpg', 'High-end smartphone with great performance.',
    999.99, 50
);

-- doi het tat ca varchar sang nvarchar de luu tieng viet
-- Table: Role
ALTER TABLE Role ALTER COLUMN RoleName NVARCHAR(10);


-- Table: EmployeeProfile
ALTER TABLE EmployeeProfile ALTER COLUMN FirstName NVARCHAR(255);
ALTER TABLE EmployeeProfile ALTER COLUMN LastName NVARCHAR(255);
ALTER TABLE EmployeeProfile ALTER COLUMN Position NVARCHAR(255);

-- Table: CustomerProfile
ALTER TABLE CustomerProfile ALTER COLUMN FirstName NVARCHAR(255);
ALTER TABLE CustomerProfile ALTER COLUMN LastName NVARCHAR(255);

-- Table: Category
ALTER TABLE Category ALTER COLUMN Name NVARCHAR(255);

-- Table: Brand
ALTER TABLE Brand ALTER COLUMN Name NVARCHAR(255);

-- Table: Product
ALTER TABLE Product ALTER COLUMN Name NVARCHAR(255);

-- Table: ProductDetail
ALTER TABLE ProductDetail ALTER COLUMN Color NVARCHAR(15);

-- Table: Payment
ALTER TABLE Payment ALTER COLUMN PaymentType NVARCHAR(255);

-- Table: Orders
ALTER TABLE Orders ALTER COLUMN Status NVARCHAR(50);



--tạo xong xuôi database rồi mới tạo trigger được
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





