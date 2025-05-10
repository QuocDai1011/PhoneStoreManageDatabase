-- tao tat ca cac bang truoc va o cuoi file co doi tu varchar sang nvarchar de su dung tieng viet
-- tao tung bang va chay lenh them xoa column ngay phia duoi lenh tao bang


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





--them du lieu vao bang product
INSERT INTO [dbo].[Product]
           ([ProductID],[CategoryID],[BrandID],[Name],[Description])
     VALUES
		(34, 1, 4, 'Samsung S25 Ultra', 'Dien thoai'),
           (1, 1, 1, 'Iphone 14', 'Dien thoai'),
		   (2, 1, 1, 'Iphone 14 Plus', 'Dien thoai'),
		   (3, 1, 1, 'Iphone 14 Pro', 'Dien thoai'),
		   (4, 1, 1, 'Iphone 14 Pro Max', 'Dien thoai'),
		   (5, 1, 1, 'Iphone 15', 'Dien thoai'),
		   (6, 1, 1, 'Iphone 15 Plus', 'Dien thoai'),
		   (7, 1, 1, 'Iphone 15 Pro', 'Dien thoai'),
		   (8, 1, 1, 'Iphone 15 Pro Max', 'Dien thoai'),
		   (9, 1, 1, 'Iphone 16', 'Dien thoai'),
		   (10, 1, 1, 'Iphone 16 Plus', 'Dien thoai'),
		   (11, 1, 1, 'Iphone 16 Pro', 'Dien thoai'),
		   (12, 1, 1, 'Iphone 16 Pro Max', 'Dien thoai'),
		   (13, 1, 2, 'Samsung Galaxy A06', 'Dien thoai'),
		   (14, 1, 2, 'Samsung Galaxy A16', 'Dien thoai'),
		   (15, 1, 2, 'Samsung Galaxy A36', 'Dien thoai'),
		   (16, 1, 2, 'Samsung Galaxy A56', 'Dien thoai'),
		   (17, 1, 2, 'Samsung Galaxy S24 Ultra', 'Dien thoai'),
		   (18, 1, 2, 'Samsung Galaxy S25', 'Dien thoai'),
		   (19, 1, 2, 'Samsung Galaxy S25 Plus', 'Dien thoai'),
		   (20, 1, 2, 'Samsung Galaxy Z Flip 6', 'Dien thoai'),
		   (21, 1, 3, 'Oppo A18', 'Dien thoai'),
		   (22, 1, 3, 'Oppo A38', 'Dien thoai'),
		   (23, 1, 3, 'Oppo A58', 'Dien thoai'),
		   (24, 1, 3, 'Oppo A79', 'Dien thoai'),
		   (25, 1, 3, 'Oppo Find N5', 'Dien thoai'),
		   (26, 1, 3, 'Oppo Find X8', 'Dien thoai'),
		   (27, 1, 3, 'Oppo Renno 12', 'Dien thoai'),
		   (28, 1, 3, 'Oppo Renno 13F', 'Dien thoai'),
		   (29, 1, 4, 'Realme 11 Pro', 'Dien thoai'),
		   (30, 1, 4, 'Realme 13 Plus', 'Dien thoai'),
		   (31, 1, 4, 'Realme C60', 'Dien thoai'),
		   (32, 1, 4, 'Realme C65', 'Dien thoai'),
		   (33, 1, 4, 'Realme Note 60', 'Dien thoai'),
		   



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
	Chip NVARCHAR(100) NOT NULL,
	ScreenSize FLOAT NOT NULL CHECK(ScreenSize > 0), -- kich thuoc man hinh (inch)
	ScreenParameters VARCHAR(20) NOT NULL, -- thong so man hinh (vd: 1990 x 2000) (pixels)
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
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0),
	CameraFront VARCHAR(20) NOT NULL, -- camera truoc (MP - MegaPixels)
	CameraRear NVARCHAR(50) NOT NULL, -- camera sau (MP - MegaPixels)
	ScreenTechnology NVARCHAR(50) NOT NULL, -- Cong nghe man hinh- Oled, Full HD
	ScanFrequency VARCHAR(20) NOT NULL -- tan so quet (HZ)


-- bo cot AdditionalAmount
ALTER TABLE ProductDetail
DROP CONSTRAINT CK__ProductDe__Addit__71D1E811;
ALTER TABLE ProductDetail
DROP COLUMN AdditionalAmount;

--them du lieu vao bang productdetail lan 1
INSERT INTO [dbo].[ProductDetail]
           ([ProductID], [Ram], [Rom], [Chip], [ScreenSize], [ScreenParameters], [BatteryCapacity],
		   [ColorID], [Image], [Description], [Price], [StockQuantity], [CameraRear], [CameraFront], [ScreenTechnology], [ScanFrequency])
     VALUES
			--Iphone 14 6GB Ram 128GB Rom 
           (1, 6, 128, N'Apple A15 Bionic 6 nhân', 6.1, '2532 x 1170', 3279,
		   1,N'Iphone/Iphone14-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		   12890000, 137, 'Rộng: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (1, 6, 128, N'Apple A15 Bionic 6 nhân', 6.1, '2532 x 1170', 3279,
		   7, N'Iphone/Iphone14-Blue.jpg', N'Điện thoại của nhãn hàng Iphone',
		   12890000, 137, N'Rộng: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (1, 6, 128, N'Apple A15 Bionic 6 nhân', 6.1, '2532 x 1170', 3279,
		   4, N'Iphone/Iphone14-White.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   12890000, 126, N'Rộng: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		    (1, 6, 128, N'Apple A15 Bionic 6 nhân', 6.1, '2532 x 1170', 3279,
		   10, N'Iphone/Iphone14-Red.jpeg', N'Điện thoại của nhãn hàng Iphone', 
		   12890000, 123, N'Rộng: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (1, 6, 128, N'Apple A15 Bionic 6 nhân', 6.1, '2532 x 1170', 3279,
		   13, N'Iphone/Iphone14-Purple.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   12890000, 118, N'Rộng: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (1, 6, 128, N'Apple A15 Bionic 6 nhân', 6.1, '2532 x 1170', 3279,
		   16, N'Iphone/Iphone14-Yellow.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   12890000, 127, N'Rộng: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   --Iphone 14 6GB Ram 256GB Rom
		   (1, 6, 256, N'Apple A15 Bionic 6 nhân', 6.1, '2532 x 1170', 3279,
		   1, N'Iphone/Iphone14-Black.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   15990000, 134, N'Rộng: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (1, 6, 256, N'Apple A15 Bionic 6 nhân', 6.1, '2532 x 1170', 3279,
		   7, N'Iphone/Iphone14-Blue.jpg', N'Điện thoại của nhãn hàng Iphone',
		   15990000, 149, N'Rộng: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (1, 6, 256, N'Apple A15 Bionic 6 nhân', 6.1, '2532 x 1170', 3279,
		   4, N'Iphone/Iphone14-White.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   15990000, 126, N'Rộng: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		    (1, 6, 256, N'Apple A15 Bionic 6 nhân', 6.1, '2532 x 1170', 3279,
		   10, N'Iphone/Iphone14-Red.jpeg', N'Điện thoại của nhãn hàng Iphone', 
		   15990000, 120, N'Rộng: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (1, 6, 256, 'Apple A15 Bionic 6 nhân', 6.1, '2532 x 1170', 3279,
		   13, 'Iphone/Iphone14-Purple.jpg', 'Điện thoại của nhãn hàng Iphone', 
		   15990000, 121, 'Rộng: 12MP, Siêu rộng: 12MP', '12MP', 'Super Retina XDR OLED', '60Hz'),
		   (1, 6, 256, N'Apple A15 Bionic 6 nhân', 6.1, '2532 x 1170', 3279,
		   16, 'Iphone/Iphone14-Yellow.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   15990000, 142, N'Rộng: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   --Iphone 14 Plus 6GB Ram 128GB Rom
		   (2, 6, 128, N'Apple A15 Bionic 6 nhân', 6.7, '2770 x 1284', 4325,
		   1, 'Iphone/Iphone14Plus-Black.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   17990000, 133, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (2, 6, 128, N'Apple A15 Bionic 6 nhân', 6.7, '2770 x 1284', 4325,
		   7, 'Iphone/Iphone14Plus-Blue.jpg', 'Điện thoại của nhãn hàng Iphone', 
		   17990000, 116, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (2, 6, 128, N'Apple A15 Bionic 6 nhân', 6.7, '2770 x 1284', 4325,
		   4, 'Iphone/Iphone14Plus-White.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   17990000, 110, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		    (2, 6, 128, N'Apple A15 Bionic 6 nhân', 6.7, '2770 x 1284', 4325,
		   10, 'Iphone/Iphone14Plus-Red.jpeg', N'Điện thoại của nhãn hàng Iphone', 
		   17990000, 136, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (2, 6, 128, N'Apple A15 Bionic 6 nhân', 6.7, '2770 x 1284', 4325,
		   13, 'Iphone/Iphone14Plus-Purple.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   17990000, 128, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (2, 6, 128, N'Apple A15 Bionic 6 nhân', 6.7, '2770 x 1284', 4325,
		   16, 'Iphone/Iphone14Plus-Yellow.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   17990000, 149, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   --Iphone 14 Plus 6GB Ram 256GB Rom
		   (2, 6, 256, N'Apple A15 Bionic 6 nhân', 6.7, '2770 x 1284', 4325,
		   1, 'Iphone/Iphone14-Black.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   19490000, 133, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (2, 6, 256, N'Apple A15 Bionic 6 nhân', 6.7, '2770 x 1284', 4325,
		   7, 'Iphone/Iphone14-Blue.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   19490000, 116, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (2, 6, 256, N'Apple A15 Bionic 6 nhân', 6.7, '2770 x 1284', 4325,
		   4, 'Iphone/Iphone14-White.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   19490000, 110, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		    (2, 6, 256, N'Apple A15 Bionic 6 nhân', 6.7, '2770 x 1284', 4325,
		   10, 'Iphone/Iphone14-Red.jpeg', N'Điện thoại của nhãn hàng Iphone', 
		   19490000, 136, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (2, 6, 256, N'Apple A15 Bionic 6 nhân', 6.7, '2770 x 1284', 4325,
		   13, 'Iphone/Iphone14-Purple.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   19490000, 128, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (2, 6, 256, N'Apple A15 Bionic 6 nhân', 6.7, '2770 x 1284', 4325,
		   16, N'Iphone/Iphone14-Yellow.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   19490000, 149, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   --Iphone 14 Pro 6GB Ram 128GB Rom
		   (3, 6, 128, N'Apple A15 Bionic 6 nhân', 6.1, '2770 x 1284', 4325,
		   1, 'Iphone/Iphone14Pro-Black.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   22990000, 133, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (3, 6, 128, N'Apple A15 Bionic 6 nhân', 6.1, '2770 x 1284', 4325,
		   4, 'Iphone/Iphone14Pro-Silver.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   22990000, 110, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (3, 6, 128, N'Apple A15 Bionic 6 nhân', 6.1, '2770 x 1284', 4325,
		   13, 'Iphone/Iphone14Pro-Purple.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   22990000, 128, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (3, 6, 128, N'Apple A15 Bionic 6 nhân', 6.1, '2770 x 1284', 4325,
		   16, 'Iphone/Iphone14Pro-Yellow.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   22990000, 149, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   --Iphone 14 Pro 6GB Ram 512GB Rom
		   (3, 6, 512, N'Apple A15 Bionic 6 nhân', 6.1, '2770 x 1284', 4325,
		   1, 'Iphone/Iphone14Pro-Black.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   28990000, 133, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (3, 6, 512, N'Apple A15 Bionic 6 nhân', 6.1, '2770 x 1284', 4325,
		   4, 'Iphone/Iphone14Pro-Silver.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   28990000, 110, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (3, 6, 512, N'Apple A15 Bionic 6 nhân', 6.1, '2770 x 1284', 4325,
		   13, 'Iphone/Iphone14Pro-Purple.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   28990000, 128, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (3, 6, 512, N'Apple A15 Bionic 6 nhân', 6.1, '2770 x 1284', 4325,
		   16, 'Iphone/Iphone14Pro-Yellow.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   28990000, 149, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   --Iphone 14 ProMax 6GB Ram 128Gb Rom
		   (4, 6, 128, N'Apple A16 Bionic 6 nhân', 6.7, '2790 x 1290', 4325,
		   1, 'Iphone/Iphone14ProMax-Black.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   25590000, 133, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (4, 6, 128, N'Apple A16 Bionic 6 nhân', 6.7, '2790 x 1290', 4325,
		   4, 'Iphone/Iphone14ProMax-Silver.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   25590000, 110, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (4, 6, 128, N'Apple A16 Bionic 6 nhân', 6.7, '2790 x 1290', 4325,
		   13, 'Iphone/Iphone14ProMax-Purple.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   25590000, 128, N'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (4, 6, 128, N'Apple A16 Bionic 6 nhân', 6.7, '2790 x 1290', 4325,
		   16, 'Iphone/Iphone14ProMax-Yellow.jpg', N'Điện thoại của nhãn hàng Iphone', 
		   25590000, 149, 'Chính: 12MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   -- Oppo Find X8 16GB Ram 512GB Rom
		   (26, 16, 512, N'MediaTek Dimensity 9400', 6.59, '720 x 1612', 5000,
		   4, 'Oppo/OppoFindX8-White.png', N'Điện thoại của nhãn hàng Oppo', 
		   16990000, 133, N'Chính: 50MP, rộng: 50MP, chân dung: 50MP', '32MP', N'AMOLED', '120Hz'),
		   (26, 16, 512, N'MediaTek Dimensity 9400', 6.59, '720 x 1612', 5000,
		   1, 'Oppo/OppoFindX8-Black.jpg', N'Điện thoại của nhãn hàng Oppo', 
		   16990000, 133, N'Chính: 50MP, rộng: 50MP, chân dung: 50MP', '32MP', N'AMOLED', '120Hz'),
		   -- Oppo A38 6GB Ram 128GB Rom
		   (22, 6, 128, N'MediaTek Helio G85 8 nhân', 6.56, '720 x 1612', 5000,
		   16, 'Oppo/OppoA38-Yellow.jpg', N'Điện thoại của nhãn hàng Oppo', 
		   3990000, 133, N'Chính: 50MP, phụ: 2MP', '5MP', N'HD+', '90Hz'),
		   (22, 6, 128, N'MediaTek Helio G85 8 nhân', 6.56, '720 x 1612', 5000,
		   1, 'Oppo/OppoA38-Black.jpg', N'Điện thoại của nhãn hàng Oppo', 
		   3990000, 133, N'Chính: 50MP, phụ: 2MP', '5MP', N'HD+', '90Hz'),
		   -- Realme 11 pro 8gb ram 256gb rom
		   (29, 8, 256, N'Mediatek Dimensity 7050 5G', 6.7, '1080 x 2412', 5000,
		   4, 'Realme/Realme11Pro-White.jpg', N'Điện thoại của nhãn hàng Realme', 
		   5190000, 133, N'Rộng: 100MP, sâu: 2MP', '16MP', N'AMOLED', '120Hz'),
		   (29, 8, 256, N'Mediatek Dimensity 7050 5G', 6.7, '1080 x 2412', 5000,
		   19, 'Realme/Realme11Pro-Green.jpg', N'Điện thoại của nhãn hàng Realme', 
		   5190000, 133, N'Rộng: 100MP, sâu: 2MP', '16MP', N'AMOLED', '120Hz'),
		   -- SamSung S25 Ultra 12gb ram 256 gb rom
		   (34, 12, 256, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.9, '3120 x 1440', 5000,
		   4, 'SamSung/SamSungS25Ultra-White.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   28990000, 133, N'Rộng: 200MP, siêu rộng: 50MP', '12MP', N'Quad HD+', '120Hz'),
		   (34, 12, 256, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.9, '3120 x 1440', 5000,
		   1, 'SamSung/SamSungS25Ultra-Black.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   28990000, 133, N'Rộng: 200MP, siêu rộng: 50MP', '12MP', N'Quad HD+', '120Hz'),
		   --Samsung galaxy a06 4gb ram 128gb rom
		   (13, 4, 128, N'MediaTek Helio G85', 6.7, '720 x 1600', 5000,
		   1, 'SamSung/SamSungGalaxyA06-Black.png', N'Điện thoại của nhãn hàng Samsung', 
		   3125000, 133, N'Chính: 50MP, phụ: 2MP', '8MP', N'PLS LCD', '60Hz')

--them du lieu vao bang productdetail lan 2
INSERT INTO [dbo].[ProductDetail]
           ([ProductID], [Ram], [Rom], [Chip], [ScreenSize], [ScreenParameters], [BatteryCapacity],
		   [ColorID], [Image], [Description], [Price], [StockQuantity], [CameraRear], [CameraFront], [ScreenTechnology], [ScanFrequency])
     VALUES
			--Iphone 15 6GB Ram 128GB Rom 
           (5, 6, 128, N'Apple A16 Bionic 6 nhân', 6.1, N'2556 x 1179', 3349,
		1, N'Iphone/Iphone15-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		15890000, 137, N'Chính: 48MP & Phụ: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
		(5, 6, 128, N'Apple A16 Bionic 6 nhân', 6.1, N'2556 x 1179', 3349,
		22, N'Iphone/Iphone15-Pink.jpg', N'Điện thoại của nhãn hàng Iphone',
		15890000, 137, N'Chính: 48MP & Phụ: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
		(5, 6, 128, N'Apple A16 Bionic 6 nhân', 6.1, N'2556 x 1179', 3349,
		7, N'Iphone/Iphone15-Blue.jpg', N'Điện thoại của nhãn hàng Iphone',
		15890000, 137, N'Chính: 48MP & Phụ: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
		   --Iphone 15gb ram 256gb rom 
		   (5, 6, 256, N'Apple A16 Bionic 6 nhân', 6.1, N'2556 x 1179', 3349,
		1, N'Iphone/Iphone15-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		18890000, 137, N'Chính: 48MP & Phụ: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
		(5, 6, 256, N'Apple A16 Bionic 6 nhân', 6.1, N'2556 x 1179', 3349,
		22, N'Iphone/Iphone15-Pink.jpg', N'Điện thoại của nhãn hàng Iphone',
		18890000, 137, N'Chính: 48MP & Phụ: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
		(5, 6, 256, N'Apple A16 Bionic 6 nhân', 6.1, N'2556 x 1179', 3349,
		7, N'Iphone/Iphone15-Blue.jpg', N'Điện thoại của nhãn hàng Iphone',
		18890000, 137, N'Chính: 48MP & Phụ: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
		   --Iphone 15 Plus 6gb ram 128gb rom
		   (6, 6, 128, N'Apple A16 Bionic 6 nhân', 6.7, N'2796 x 1290', 4383,
		1, N'Iphone/Iphone15Plus-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		19490000, 17, N'Chính: 48MP & Phụ: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
		(6, 6, 128, N'Apple A16 Bionic 6 nhân', 6.7, N'2796 x 1290', 4383,
		22, N'Iphone/Iphone15Plus-Pink.jpg', N'Điện thoại của nhãn hàng Iphone',
		19490000, 13, N'Chính: 48MP & Phụ: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
		(6, 6, 128, N'Apple A16 Bionic 6 nhân', 6.7, N'2796 x 1290', 4383,
		7, N'Iphone/Iphone15Plus-Blue.jpg', N'Điện thoại của nhãn hàng Iphone',
		19490000, 7, N'Chính: 48MP & Phụ: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
		   --Iphone 15 Plus 6gb ram 256gb rom
			   (6, 6, 256, N'Apple A16 Bionic 6 nhân', 6.7, N'2796 x 1290', 4383,
		1, N'Iphone/Iphone15Plus-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		22790000, 17, N'Chính: 48MP & Phụ: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
		(6, 6, 256, N'Apple A16 Bionic 6 nhân', 6.7, N'2796 x 1290', 4383,
		22, N'Iphone/Iphone15Plus-Pink.jpg', N'Điện thoại của nhãn hàng Iphone',
		22790000, 13, N'Chính: 48MP & Phụ: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
		(6, 6, 256, N'Apple A16 Bionic 6 nhân', 6.7, N'2796 x 1290', 4383,
		7, N'Iphone/Iphone15Plus-Blue.jpg', N'Điện thoại của nhãn hàng Iphone',
		22790000, 7, N'Chính: 48MP & Phụ: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
	-- iPhone 15 Pro 8GB Ram 128GB Rom
		(7, 8, 128, N'Apple A17 Pro 6 nhân', 6.1, N'2556 x 1179', 3274,
		1, N'Iphone/Iphone15Pro-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		23990000, 17, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
		(7, 8, 128, N'Apple A17 Pro 6 nhân', 6.1, N'2556 x 1179', 3274,
		4, N'Iphone/Iphone15Pro-White.png', N'Điện thoại của nhãn hàng Iphone',
		23990000, 12, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz'),
		(7, 8, 128, N'Apple A17 Pro 6 nhân', 6.1, N'2556 x 1179', 3274,
		7, N'Iphone/Iphone15Pro-Blue.png', N'Điện thoại của nhãn hàng Iphone',
		23990000, 19, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', N'12MP', N'Super Retina XDR OLED', N'60Hz');

-- them du lieu lan 3
INSERT INTO [dbo].[ProductDetail]
           ([ProductID], [Ram], [Rom], [Chip], [ScreenSize], [ScreenParameters], [BatteryCapacity],
		   [ColorID], [Image], [Description], [Price], [StockQuantity], [CameraRear], [CameraFront], [ScreenTechnology], [ScanFrequency])
     VALUES
		   --Iphone 15 Pro 8gb ram 256gb rom
		   (7, 8, 256, N'Apple A17 Pro 6 nhân', 6.1, '2556 x 1179', 3274,
		   1, 'Iphone/Iphone15Pro-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		   27490000, 13, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (7, 8, 256, N'Apple A17 Pro 6 nhân', 6.1, '2556 x 1179', 3274,
		   4, 'Iphone/Iphone15Pro-White.png', N'Điện thoại của nhãn hàng Iphone',
		   27490000, 11, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (7, 8, 256, N'Apple A17 Pro 6 nhân', 6.1, '2556 x 1179', 3274,
		   7, N'Iphone/Iphone15Pro-Blue.png', N'Điện thoại của nhãn hàng Iphone',
		   27490000, 14, 'NChính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   --Iphone 15 ProMax 8gb ram 256gb rom
		    (7, 8, 256, N'Apple A17 Pro 6 nhân', 6.7, '2796 x 1290', 4422,
		   1, N'Iphone/Iphone15Pro-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		   27990000, 13, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		   (7, 8, 256, N'Apple A17 Pro 6 nhân', 6.7, '2796 x 1290', 4422,
		   4, 'Iphone/Iphone15Pro-White.png', N'Điện thoại của nhãn hàng Iphone',
		   27990000, 11, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		   (8, 8, 256, N'Apple A17 Pro 6 nhân', 6.7, '2796 x 1290', 4422,
		   7, 'Iphone/Iphone15Pro-Blue.png', N'Điện thoại của nhãn hàng Iphone',
		   27990000, 14, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz');

-- them du lieu lan 4
INSERT INTO [dbo].[ProductDetail]
           ([ProductID], [Ram], [Rom], [Chip], [ScreenSize], [ScreenParameters], [BatteryCapacity],
		   [ColorID], [Image], [Description], [Price], [StockQuantity], [CameraRear], [CameraFront], [ScreenTechnology], [ScanFrequency])
     VALUES
		   --Iphone 15 ProMax 8gb ram 512gb rom
		   (7, 8, 512, N'Apple A17 Pro 6 nhân', 6.7, '2796 x 1290', 4422,
		   1, 'Iphone/Iphone15Pro-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		   31990000, 13, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		   (7, 8, 512, N'Apple A17 Pro 6 nhân', 6.7, '2796 x 1290', 4422,
		   4, 'Iphone/Iphone15Pro-White.png', N'Điện thoại của nhãn hàng Iphone',
		   31990000, 11, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		   (8, 8, 512, N'Apple A17 Pro 6 nhân', 6.7, '2796 x 1290', 4422,
		   7, 'Iphone/Iphone15Pro-Blue.png', N'Điện thoại của nhãn hàng Iphone',
		   31990000, 14, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		   --Iphone 16 6gb ram 128gb rom
		   (9, 6, 128, N'Apple A18', 6.1, '2556 x 1179', 3561,
		   4, 'Iphone/Iphone16-White.jpg', N'Điện thoại của nhãn hàng Iphone',
		   19190000, 8, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (9, 6, 128, N'Apple A18', 6.1, '2556 x 1179', 3561,
		   1, 'Iphone/Iphone16-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		   19190000, 13, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (9, 6, 128, N'Apple A18', 6.1, '2556 x 1179', 3561,
		  22, 'Iphone/Iphone16-Pink.jpg', N'Điện thoại của nhãn hàng Iphone',
		   19190000, 10, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (9, 6, 128, N'Apple A18', 6.1, '2556 x 1179', 3561,
		   7, 'Iphone/Iphone16-Blue.jpg', N'Điện thoại của nhãn hàng Iphone',
		   19190000, 3, 'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz');

-- them du lieu lan 5
INSERT INTO [dbo].[ProductDetail]
           ([ProductID], [Ram], [Rom], [Chip], [ScreenSize], [ScreenParameters], [BatteryCapacity],
		   [ColorID], [Image], [Description], [Price], [StockQuantity], [CameraRear], [CameraFront], [ScreenTechnology], [ScanFrequency])
     VALUES
		   --Iphone 16 6gb ram 256gb rom
		   (9, 6, 256, N'Apple A18', 6.1, '2556 x 1179', 3561,
		   4, 'Iphone/Iphone16-White.jpg', N'Điện thoại của nhãn hàng Iphone',
		   22490000, 7, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (9, 6, 256, N'Apple A18', 6.1, '2556 x 1179', 3561,
		   1, N'Iphone/Iphone16-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		   22490000, 3, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (9, 6, 256, N'Apple A18', 6.1, '2556 x 1179', 3561,
		   22, 'Iphone/Iphone16-Pink.jpg', N'Điện thoại của nhãn hàng Iphone',
		   22490000, 5, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (9, 6, 256, N'Apple A18', 6.1, '2556 x 1179', 3561,
		   7, 'Iphone/Iphone16-Blue.jpg', N'Điện thoại của nhãn hàng Iphone',
		   22490000, 9, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   --Iphone 16 6gb ram 512gb rom
		   (9, 6, 512, N'Apple A18', 6.1, '2556 x 1179', 3561,
		   4, 'Iphone/Iphone16-White.jpg', N'Điện thoại của nhãn hàng Iphone',
		   27990000, 7, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (9, 6, 512, N'Apple A18', 6.1, '2556 x 1179', 3561,
		   1, 'Iphone/Iphone16-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		   27990000, 3, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (9, 6, 512, N'Apple A18', 6.1, '2556 x 1179', 3561,
		   22, 'Iphone/Iphone16-Pink.jpg', N'Điện thoại của nhãn hàng Iphone',
		   27990000, 5, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (9, 6, 512, N'Apple A18', 6.1, '2556 x 1179', 3561,
		   7, 'Iphone/Iphone16-Blue.jpg', N'Điện thoại của nhãn hàng Iphone',
		   27990000, 9, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
			--Iphone 16 Plus 8gb ram 128gb rom
			(10, 8, 128, N'Apple A18', 6.7, '2796 x 1290', 4671,
		   4, 'Iphone/Iphone16Plus-White.jpg', N'Điện thoại của nhãn hàng Iphone',
		   22290000, 7, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (10, 8, 128, N'Apple A18', 6.7, '2796 x 1290', 4671,
		   1, 'Iphone/Iphone16Plus-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		   22290000, 3, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (10, 8, 128, N'Apple A18', 6.7, '2796 x 1290', 4671,
		   22, 'Iphone/Iphone16Plus-Pink.jpg', N'Điện thoại của nhãn hàng Iphone',
		   22290000, 5, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (10, 8, 128, N'Apple A18', 6.7, '2796 x 1290', 4671,
		   7, 'Iphone/Iphone16Plus-Blue.jpg', N'Điện thoại của nhãn hàng Iphone',
		   22290000, 9, 'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   --Iphone 16 Plus 8gb ram 256gb rom
			(10, 8, 256, N'Apple A18', 6.7, '2796 x 1290', 4671,
		   4, 'Iphone/Iphone16Plus-White.jpg', N'Điện thoại của nhãn hàng Iphone',
		   25790000, 7, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (10, 8, 256, N'Apple A18', 6.7, '2796 x 1290', 4671,
		   1, 'Iphone/Iphone16Plus-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		   25790000, 3, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (10, 8, 256, N'Apple A18', 6.7, '2796 x 1290', 4671,
		   22, 'Iphone/Iphone16Plus-Pink.jpg', N'Điện thoại của nhãn hàng Iphone',
		   25790000, 5, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (10, 8, 256, N'Apple A18', 6.7, '2796 x 1290', 4671,
		   7, 'Iphone/Iphone16Plus-Blue.jpg', N'Điện thoại của nhãn hàng Iphone',
		   25790000, 9, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz');

-- them du lieu lan 6
INSERT INTO [dbo].[ProductDetail]
           ([ProductID], [Ram], [Rom], [Chip], [ScreenSize], [ScreenParameters], [BatteryCapacity],
		   [ColorID], [Image], [Description], [Price], [StockQuantity], [CameraRear], [CameraFront], [ScreenTechnology], [ScanFrequency])
     VALUES
		    --Iphone 16 Plus 8gb ram 512gb rom
			(10, 8, 512, N'Apple A18', 6.7, '2796 x 1290', 4671,
		  4, 'Iphone/Iphone16Plus-White.jpg', N'Điện thoại của nhãn hàng Iphone',
		   29490000, 7, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (10, 8, 512, N'Apple A18', 6.7, '2796 x 1290', 4671,
		   1, 'Iphone/Iphone16Plus-Black.jpg', N'Điện thoại của nhãn hàng Iphone',
		   29490000, 3, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (10, 8, 512, N'Apple A18', 6.7, '2796 x 1290', 4671,
		   22, 'Iphone/Iphone16Plus-Pink.jpg', N'Điện thoại của nhãn hàng Iphone',
		   29490000, 5, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   (10, 8, 512, N'Apple A18', 6.7, '2796 x 1290', 4671,
		   7, 'Iphone/Iphone16Plus-Blue.jpg', N'Điện thoại của nhãn hàng Iphone',
		   29490000, 9, N'Chính: 48MP, Siêu rộng: 12MP', '12MP', N'Super Retina XDR OLED', '60Hz'),
		   --Iphone 16 Pro 8gb ram 128gb rom
		   (11, 8, 128, N'Apple A18 Pro', 6.3, '2622 x 1206', 3355,
		   28, N'Iphone/Iphone16Pro-Black.jpeg', N'Điện thoại của nhãn hàng Iphone',
		   25290000, 13, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		   (11, 8, 128, N'Apple A18 Pro', 6.3, '2622 x 1206', 3355,
		   25, 'Iphone/Iphone16Pro-Yellow.png', N'Điện thoại của nhãn hàng Iphone',
		   25290000, 11, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		   --Iphone 16 Pro 8gb ram 256gb rom
		   (11, 8, 256, N'Apple A18 Pro', 6.3, '2622 x 1206', 3355,
		   28, 'Iphone/Iphone16Pro-Black.jpeg', N'Điện thoại của nhãn hàng Iphone',
		   28490000, 13, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		   (11, 8, 256, N'Apple A18 Pro', 6.3, '2622 x 1206', 3355,
		   25, 'Iphone/Iphone16Pro-Yellow.png', N'Điện thoại của nhãn hàng Iphone',
		   28490000, 11, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		   --Iphone 16 Pro 8gb ram 512gb rom
		   (11, 8, 512, N'Apple A18 Pro', 6.3, '2622 x 1206', 3355,
		   28, 'Iphone/Iphone16Pro-Black.jpeg', N'Điện thoại của nhãn hàng Iphone',
		   34690000, 13, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		   (11, 8, 512, N'Apple A18 Pro', 6.3, '2622 x 1206', 3355,
		   25, 'Iphone/Iphone16Pro-Yellow.png', N'Điện thoại của nhãn hàng Iphone',
		   34690000, 11, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		   --Iphone 16 ProMax 8gb ram 256gb rom
		   (12, 8, 256, N'Apple A18 Pro', 6.9, '2868 x 1320', 4676,
		   28, 'Iphone/Iphone16ProMax-Black.jpeg', N'Điện thoại của nhãn hàng Iphone',
		   30990000, 13, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		   (12, 8, 256, N'Apple A18 Pro', 6.9, '2868 x 1320', 4676,
		   25, 'Iphone/Iphone16ProMax-White.png', N'Điện thoại của nhãn hàng Iphone',
		   30990000, 11, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		    --Iphone 16 ProMax 8gb ram 512gb rom
		   (12, 8, 512, N'Apple A18 Pro', 6.9, '2868 x 1320', 4676,
		   28, 'Iphone/Iphone16ProMax-Black.jpeg', N'Điện thoại của nhãn hàng Iphone',
		   37490000, 13, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz'),
		   (12, 8, 512, N'Apple A18 Pro', 6.9, '2868 x 1320', 4676,
		   25, 'Iphone/Iphone16ProMax-White.png', N'Điện thoại của nhãn hàng Iphone',
		   37490000, 11, N'Chính: 48MP, Siêu rộng: 12MP & Tele3x: 12MP', '12MP', N'Super Retina XDR OLED', '120Hz');

-- them du lieu lan 7
INSERT INTO [dbo].[ProductDetail]
           ([ProductID], [Ram], [Rom], [Chip], [ScreenSize], [ScreenParameters], [BatteryCapacity],
		   [ColorID], [Image], [Description], [Price], [StockQuantity], [CameraRear], [CameraFront], [ScreenTechnology], [ScanFrequency])
     VALUES
		   -- SamSung S25 Ultra 12gb ram 512gb rom
		   (34, 12, 512, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.9, '3120 x 1440', 5100,
		   4, 'SamSung/SamSungS25Ultra-White.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   32090000, 13, N'Rộng: 200MP, siêu rộng: 50MP', '12MP', N'Quad HD+', '120Hz'),
		   (34, 12, 512, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.9, '3120 x 1440', 5100,
		   1, 'SamSung/SamSungS25Ultra-Black.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   32090000, 3, N'Rộng: 200MP, siêu rộng: 50MP', '12MP', N'Quad HD+', '120Hz'),
		   -- SamSung Galaxy a16 8gb ram 128gb rom
		   (14, 8, 128, N'MediaTek Dimensity 6300(6nm)', 6.7, '1080 x 2340', 4900,
		   1, 'SamSung/SamSungGalaxyA16-Black.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   6090000, 13, N'Rộng: 50MP, siêu rộng: 5MP, Macro: 2MP', '13MP', N'Full HD+', '90Hz'),
		   -- SamSung Galaxy a36 8gb ram 128gb rom
		   (15, 8, 128, N'Snapdragon 6 Gen 3', 6.7, '1080 x 2340', 5000,
		   1, 'SamSung/SamSungGalaxyA36-Black.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   7690000, 7, 'Rộng: 50MP, siêu rộng: 8MP, Macro: 5MP', '12MP', N'Super AMOLED', '120Hz'),
		   (15, 8, 128, N'Snapdragon 6 Gen 3', 6.7, '1080 x 2340', 5000,
		   13, 'SamSung/SamSungGalaxyA36-Purple.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   7690000, 10, N'Rộng: 50MP, siêu rộng: 8MP, Macro: 5MP', '12MP', N'Super AMOLED', '120Hz'),
		    -- SamSung Galaxy a56 8gb ram 128gb rom
		   (16, 8, 128, N'Exynos 1580', 6.7, '1080 x 2340', 5000,
		   1, 'SamSung/SamSungGalaxyA56-Black.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   9490000, 7, N'Rộng: 50MP, siêu rộng: 12MP, Macro: 5MP', '12MP', N'Super AMOLED', '120Hz'),
		   (16, 8, 128, N'Exynos 1580', 6.7, '1080 x 2340', 5000,
		   31, 'SamSung/SamSungGalaxyA56-Grey.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   9490000, 5, N'Rộng: 50MP, siêu rộng: 12MP, Macro: 5MP', '12MP', N'Super AMOLED', '120Hz'),
		   -- SamSung Galaxy s24 ultra 12gb ram 256gb rom
		   (17, 12, 256, N'Exynos 1580', 6.8, '1440 x 3120', 5000,
		   1, 'SamSung/SamSungS24Ultra-Black.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   23890000, 7, 'Rộng: 200MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (17, 12, 256, N'Exynos 1580', 6.8, '1440 x 3120', 5000,
		   31, 'SamSung/SamSungS24Ultra-Grey.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   23890000, 5, N'Rộng: 200MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (17, 12, 256, N'Exynos 1580', 6.8, '1440 x 3120', 5000,
		   13, 'SamSung/SamSungS24Ultra-Purple.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   23890000, 5, N'Rộng: 200MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   -- SamSung Galaxy s24 ultra 12gb ram 512gb rom
		   (17, 12, 512, N'Exynos 1580', 6.8, '1440 x 3120', 5000,
		   1, 'SamSung/SamSungS24Ultra-Black.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   25990000, 7, N'Rộng: 200MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (17, 12, 512, N'Exynos 1580', 6.8, '1440 x 3120', 5000,
		   31, 'SamSung/SamSungS24Ultra-Grey.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   25990000, 5, N'Rộng: 200MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (17, 12, 512, N'Exynos 1580', 6.8, '1440 x 3120', 5000,
		   13, 'SamSung/SamSungS24Ultra-Purple.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   25990000, 5, N'Rộng: 200MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz');

-- them du lieu lan 8
INSERT INTO [dbo].[ProductDetail]
           ([ProductID], [Ram], [Rom], [Chip], [ScreenSize], [ScreenParameters], [BatteryCapacity],
		   [ColorID], [Image], [Description], [Price], [StockQuantity], [CameraRear], [CameraFront], [ScreenTechnology], [ScanFrequency])
     VALUES
		   -- SamSung Galaxy s25 12gb ram 128gb rom
		   (18, 12, 128, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.2, '2340 x 1080', 4000,
		   4, 'SamSung/SamSungS25-White.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   19290000, 7, N'Rộng: 50MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (18, 12, 128, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.2, '2340 x 1080', 4000,
		   34, 'SamSung/SamSungS25-BlueNavy.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   19290000, 5, N'Rộng: 50MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (18, 12, 128, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.2, '2340 x 1080', 4000,
		   19, 'SamSung/SamSungS25-Green.jpg', 'Điện thoại của nhãn hàng Samsung', 
		   19290000, 5, N'Rộng: 50MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   -- SamSung Galaxy s25 12gb ram 512gb rom
		   (18, 12, 512, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.2, '2340 x 1080', 4000,
		   4, 'SamSung/SamSungS25-White.jpg', 'Điện thoại của nhãn hàng Samsung', 
		   25790000, 7, N'Rộng: 50MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (18, 12, 512, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.2, '2340 x 1080', 4000,
		   34, 'SamSung/SamSungS25-BlueNavy.jpg', 'Điện thoại của nhãn hàng Samsung', 
		   25790000, 5, N'Rộng: 50MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (18, 12, 512, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.2, '2340 x 1080', 4000,
		   19, 'SamSung/SamSungS25-Green.jpg', 'Điện thoại của nhãn hàng Samsung', 
		   25790000, 5, N'Rộng: 50MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   -- SamSung Galaxy s25Plus 12gb ram 256gb rom
		   (19, 12, 256, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.7, '3120 x 1440', 4900,
		   4, 'SamSung/SamSungS25Plus-White.jpg', 'Điện thoại của nhãn hàng Samsung', 
		   22790000, 7, N'Rộng: 50MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (19, 12, 256, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.7, '3120 x 1440', 4900,
		   34, 'SamSung/SamSungS25Plus-BlueNavy.jpg', 'Điện thoại của nhãn hàng Samsung', 
		   22790000, 5, N'Rộng: 50MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (19, 12, 256, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.7, '3120 x 1440', 4900,
		   19, 'SamSung/SamSungS25Plus-Green.jpg', 'Điện thoại của nhãn hàng Samsung', 
		   22790000, 5, N'Rộng: 50MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   -- SamSung Galaxy s25Plus 12gb ram 512gb rom
		   (19, 12, 512, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.7, '3120 x 1440', 4900,
		   4, 'SamSung/SamSungS25Plus-White.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   25790000, 7, N'Rộng: 50MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (19, 12, 512, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.7, '3120 x 1440', 4900,
		   34, 'SamSung/SamSungS25Plus-BlueNavy.jpg', 'Điện thoại của nhãn hàng Samsung', 
		   25790000, 5, N'Rộng: 50MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (19, 12, 512, N'Snapdragon 8 Elite dành cho Galaxy (3nm)', 6.7, '3120 x 1440', 4900,
		   19, 'SamSung/SamSungS25Plus-Green.jpg', 'Điện thoại của nhãn hàng Samsung', 
		   25790000, 5, N'Rộng: 50MP, siêu rộng: 12MP, tele: 10MP', '12MP', N'Dynamic AMOLED 2X', '120Hz'),
		   -- SamSung Galaxy ZFlip6 12gb ram 256gb rom
		   (20, 12, 256, N'Snapdragon 8 Gen 3 for Galaxy Tăng lên 42% AI', 6.7, '1080 x 2640', 4000,
		   1, 'SamSung/SamSungZFlip6-Black.jpg', 'Điện thoại của nhãn hàng Samsung', 
		   19490000, 7, N'Rộng: 50MP, siêu rộng: 12MP', '10MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (20, 12, 256, N'Snapdragon 8 Gen 3 for Galaxy Tăng lên 42% AI', 6.7, '1080 x 2640', 4000,
		   31, 'SamSung/SamSungZFlip6-Grey.jpg', N'Điện thoại của nhãn hàng Samsung', 
		   19490000, 5, N'Rộng: 50MP, siêu rộng: 12MP', '10MP', N'Dynamic AMOLED 2X', '120Hz'),
		   -- SamSung Galaxy ZFlip6 12gb ram 512gb rom
		   (20, 12, 512, N'Snapdragon 8 Gen 3 for Galaxy Tăng lên 42% AI', 6.7, '1080 x 2640', 4000,
		   1, 'SamSung/SamSungZFlip6-Black.jpg', 'Điện thoại của nhãn hàng Samsung', 
		   23990000, 7, N'Rộng: 50MP, siêu rộng: 12MP', '10MP', N'Dynamic AMOLED 2X', '120Hz'),
		   (20, 12, 512, N'Snapdragon 8 Gen 3 for Galaxy Tăng lên 42% AI', 6.7, '1080 x 2640', 4000,
		   31, 'SamSung/SamSungZFlip6-Grey.jpg', 'Điện thoại của nhãn hàng Samsung', 
		   23990000, 5, N'Rộng: 50MP, siêu rộng: 12MP', '10MP', N'Dynamic AMOLED 2X', '120Hz');

-- them du lieu lan 9
INSERT INTO [dbo].[ProductDetail]
           ([ProductID], [Ram], [Rom], [Chip], [ScreenSize], [ScreenParameters], [BatteryCapacity],
		   [ColorID], [Image], [Description], [Price], [StockQuantity], [CameraRear], [CameraFront], [ScreenTechnology], [ScanFrequency])
     VALUES
		   --Oppo a18 4gb ram 64 gb rom
		   (21, 4, 64, N'MediaTek Helio G85 8 nhân', 6.56, '720 x 1612', 4000,
		   1, 'SamSung/OppoA18-Black.jpg', 'Điện thoại của nhãn hàng Oppo', 
		   2890000, 7, N'Chính: 8MP, xóa phông: 2MP', '5MP', 'IPS LCD', '60Hz'),
		   (21, 4, 64, N'MediaTek Helio G85 8 nhân', 6.56, '720 x 1612', 4000,
		   7, 'SamSung/OppoA18-Blue.jpg', 'Điện thoại của nhãn hàng Oppo', 
		   2890000, 5, N'Chính: 8MP, xóa phông: 2MP', '5MP', 'IPS LCD', '60Hz'),
		    --Oppo a18 4gb ram 128gb rom
		   (21, 4, 128, N'MediaTek Helio G85 8 nhân', 6.56, '720 x 1612', 4000,
		   1, 'SamSung/OppoA18-Black.jpg', 'Điện thoại của nhãn hàng Oppo', 
		   3190000, 7, N'Chính: 8MP, xóa phông: 2MP', '5MP', 'IPS LCD', '60Hz'),
		   (21, 4, 128, N'MediaTek Helio G85 8 nhân', 6.56, '720 x 1612', 4000,
		   7, 'SamSung/OppoA18-Blue.jpg', 'Điện thoại của nhãn hàng Oppo', 
		   3190000, 5, N'Chính: 8MP, xóa phông: 2MP', '5MP', 'IPS LCD', '60Hz'),
		    --Oppo a58 6gb ram 128gb rom
		   (23, 6, 128, N'MediaTek Helio G85 8 nhân', 6.72, '1080 x 2412', 5000,
		   1, 'SamSung/OppoA58-Black.png', 'Điện thoại của nhãn hàng Oppo', 
		   4290000, 7, N'Chính: 50MP & Phụ: 2MP', '8MP', 'IPS LCD', '60Hz'),
		   --Oppo a58 8gb ram 128gb rom
		   (23, 8, 128, N'MediaTek Helio G85 8 nhân', 6.72, '1080 x 2400', 5000,
		   1, 'SamSung/OppoA58-Black.png', 'Điện thoại của nhãn hàng Oppo', 
		   4590000, 7, N'Chính: 50MP & Phụ: 2MP', '8MP', 'IPS LCD', '60Hz'),
		   --Oppo a79 8gb ram 256gb rom
		   (24, 8, 256, N'MediaTek Dimensity 6020 5G 8 nhân', 6.72, '1080 x 2400', 5000,
		   1, 'SamSung/OppoA79-Black.jpg', 'Điện thoại của nhãn hàng Oppo', 
		   6990000, 7, N'Chính: 50MP & Phụ: 2MP', '8MP', 'IPS LCD', '90Hz'),
		    (24, 8, 256, N'MediaTek Dimensity 6020 5G 8 nhân', 6.72, '1080 x 2400', 5000,
		   13, 'SamSung/OppoA79-Purple.jpg', 'Điện thoại của nhãn hàng Oppo', 
		   6990000, 5, N'Chính: 50MP & Phụ: 2MP', '8MP', 'IPS LCD', '90Hz'),
		    --Oppo FindN5 16gb ram 512gb rom
		   (25, 16, 512, N'Qualcomm Snapdragon® 8 Elite', 8.12, '2.480 x 2.248', 5000,
		   1, 'SamSung/OppoFindN5-Black.png', 'Điện thoại của nhãn hàng Oppo', 
		   44990000, 7, N'Chính: 50MP & Phụ: 2MP', '8MP', 'AMOLED', '120Hz'),
		    (25, 16, 512, N'Qualcomm Snapdragon® 8 Elite', 8.12, '2.480 x 2.248', 5000,
		   4, 'SamSung/OppoFindN5-White.jpg', 'Điện thoại của nhãn hàng Oppo', 
		   44990000, 5, N'Chính: 50MP, rộng: 50MP, tele: 8MP', '8MP', 'AMOLED', '120Hz'),
		   --Oppo Renno12 12gb ram 256gb rom
		   (27, 12, 256, N'MediaTek Dimensity 7300', 6.7, '2.480 x 2.248', 5000,
		   37, 'SamSung/OppoRenno12-Silver.png', 'Điện thoại của nhãn hàng Oppo', 
		   9190000, 7, N'Chính: 50MP, rộng: 8MP', '32MP', 'AMOLED', '120Hz'),
		    (27, 12, 256, N'MediaTek Dimensity 7300', 6.7, '2.480 x 2.248', 5000,
		   40, 'SamSung/OppoRenno12-Brown.png', 'Điện thoại của nhãn hàng Oppo', 
		   9190000, 5, N'Chính: 50MP, rộng: 8MP', '32MP', 'AMOLED', '120Hz'),
		   --Oppo Renno13F 12gb ram 256gb rom
		   (28, 12, 256, N'MediaTek Helio G100, tối đa 2.2GHz', 6.67, '1080 x 2400', 5800,
		   37, 'SamSung/OppoRenno13F-Grey.jpg', 'Điện thoại của nhãn hàng Oppo', 
		   10390000, 7, N'Chính: 50MP, rộng: 8MP', '32MP', 'AMOLED', '120Hz'),
		    (28, 12, 256, N'MediaTek Helio G100, tối đa 2.2GHz', 6.67, '1080 x 2400', 5800,
		   13, 'SamSung/OppoRenno13F-Purple.jpg', 'Điện thoại của nhãn hàng Oppo', 
		   10390000, 5, N'Chính: 50MP, rộng: 8MP', '32MP', 'AMOLED', '120Hz'),
		   --Realme 13Plus 8gb ram 256gb rom
		   (30, 8, 256, N'Dimensity 7300 Energy 5G', 6.67, '1080 x 2400', 5000,
		   13, 'Realme/Realme13Plus-Purple.jpg', 'Điện thoại của nhãn hàng Realme', 
		   7390000, 7, N'Chính: 50MP, rộng: 2MP', '16MP', 'OLED', '120Hz'),
		    (30, 8, 256, N'Dimensity 7300 Energy 5G', 6.67, '1080 x 2400', 5000,
		   16, N'Realme/Realme13Plus-Yellow.jpg', 'Điện thoại của nhãn hàng Realme', 
		   7390000, 5, 'Chính: 50MP, rộng: 2MP', '16MP', 'OLED', '120Hz'),
		   --Realme c65 8gb ram 256gb rom
		   (32, 8, 256, N'MediaTek Helio G85 8 nhân', 6.67, '1080 x 2400', 5000,
		   13, 'Realme/RealmeC65-Purple.jpg', 'Điện thoại của nhãn hàng Realme', 
		   3750000, 7, N'Chính: 50MP, rộng: 2MP', '16MP', 'IPC LCD', '90Hz'),
		    (32, 8, 256, N'MediaTek Helio G85 8 nhân', 6.67, '1080 x 2400', 5000,
		   1, 'Realme/RealmeC65-Black.jpg', 'Điện thoại của nhãn hàng Realme', 
		   3750000, 5, N'Chính: 50MP, rộng: 2MP', '16MP', 'IPC LCD', '90Hz'),
		   --Realme c65 4gb ram 64gb rom
		   (33, 4, 64, N'UNISOC T612', 6.74, '1600 x 720', 5000,
		   7, 'Realme/RealmeNote60-Blue.jpg', 'Điện thoại của nhãn hàng Realme', 
		   2790000, 7, N'Chính: 32MP, rộng: 2MP', '5MP', 'IPC LCD', '90Hz'),
		    (33, 4, 64, N'UNISOC T612', 6.74, '1600 x 720', 5000,
		   1, 'Realme/RealmeNote60-Black.jpg', 'Điện thoại của nhãn hàng Realme', 
		   2790000, 5, N'Chính: 30MP, rộng: 2MP', '5MP', 'IPC LCD', '90Hz');

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
ALTER TABLE ProductDetail ALTER COLUMN Color NVARCHAR(50);

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


SELECT *
FROM ProductDetail pd
JOIN Product as p ON pd.ProductID = p.ProductID
WHERE p.Name LIKE '%asdfsf%';





--xoa rang buoc truoc khi xoa cot categoryID
ALTER TABLE [dbo].[Product]
DROP CONSTRAINT FK__Product__Categor__5535A963;

-- xoa cot categoryid trong bang product
ALTER TABLE Product DROP COLUMN CategoryID;

--xoa bang category
DROP TABLE [dbo].[Category];

--tao bang color
CREATE TABLE ColorOfProduct (
	ColorOfProductID INT PRIMARY KEY IDENTITY(1,3),
	NameColor NVARCHAR(150) NOT NULL
);

-- them du lieu vao bang color
INSERT INTO [dbo].[ColorOfProduct]
           ([NameColor])
     VALUES
           (N'Đen'),
		   (N'Trắng'),
		   (N'Xanh da trời'),
		   (N'Đỏ'),
		   (N'Tím'),
		   (N'Vàng'),
		   (N'Xanh lá'),
		   (N'Hồng'),
		   (N'Titan sa mạc'),
		   (N'Titan tự nhiên'),
		   (N'Xám'),
		   (N'Xanh navy'),
		   (N'Bạc'),
		   (N'Nâu đồng')

-- xoa toan bo du lieu bang ProductDetail
TRUNCATE TABLE [dbo].[ProductDetail];

--tao cot colorID trong productdetail
ALTER TABLE ProductDetail ADD ColorID INT;

--Xóa cột Color cũ (kiểu NVARCHAR)
ALTER TABLE ProductDetail DROP COLUMN Color;

--thiet lap khoa ngoai cho cot color
ALTER TABLE ProductDetail
ADD CONSTRAINT FK_ProductDetail_Color
FOREIGN KEY (ColorID) REFERENCES ColorOfProduct(ColorOfProductID);

--Tới đây bạn kéo lên phần thêm dữ liệu ProductDetail và thêm tất cả dữ liệu vô như hồi trước nha

-- xoa bang Payment (Phuong thuc thanh toan)
-- chay cau lenh xoa cot sau day de lay ma rang buoc roi copy paste xuong cau lenh phia duoi de xoa rang buoc truoc moi xoa cot duoc
ALTER TABLE [dbo].[Orders] DROP COLUMN PaymentID;

-- xoa rang buoc cua bang Order
ALTER TABLE [dbo].[Orders]
DROP CONSTRAINT FK__Orders__PaymentI__68487DD7;

-- xoa bang Payment (Phuong thuc thanh toan)
DROP TABLE [dbo].[Payment];

-- xoa bang Orders (lam tuong tu nhu phia tren)
-- chay cau lenh xoa cot sau day de lay ma rang buoc roi copy paste xuong cau lenh phia duoi de xoa rang buoc truoc moi xoa cot duoc
ALTER TABLE [dbo].[Orders] DROP COLUMN CartID;

-- xoa rang buoc cua bang Order
ALTER TABLE [dbo].[Orders]
DROP CONSTRAINT FK__Orders__CartID__693CA210;

-- xoa bang Order 
DROP TABLE [dbo].[Orders];


-- xoa bang CartDetail (lam tuong tu nhu phia tren)
-- chay cau lenh xoa cot sau day de lay ma rang buoc roi copy paste xuong cau lenh phia duoi de xoa rang buoc truoc moi xoa cot duoc
ALTER TABLE [dbo].[CartDetail] DROP COLUMN [CartID];

-- xoa rang buoc cua bang CartDetail
ALTER TABLE [dbo].[CartDetail]
DROP CONSTRAINT FK__CartDetai__CartI__5FB337D6;

-- xoa bang CartDetail
DROP TABLE [dbo].[CartDetail];


-- xoa bang Cart (lam tuong tu nhu phia tren)
-- chay cau lenh xoa cot sau day de lay ma rang buoc roi copy paste xuong cau lenh phia duoi de xoa rang buoc truoc moi xoa cot duoc
ALTER TABLE [dbo].[Cart] DROP COLUMN [AccountID];

-- xoa rang buoc cua bang Cart
ALTER TABLE [dbo].[Cart]
DROP CONSTRAINT FK__Cart__AccountID__5AEE82B9;

-- xoa bang Cart
DROP TABLE [dbo].[Cart];


--Tao bang Order
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,3),
    CustomerID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(18, 2) NOT NULL, -- tong gia tien hoa don
    Status BIT CHECK (Status = 0 OR Status = 1), -- 0: Chua thanh toan 1: Da thanh toan
    ShippingAddress NVARCHAR(255),
    Note NVARCHAR(255),
    FOREIGN KEY (CustomerID) REFERENCES CustomerProfile(CustomerID),

);

-- tao bang OrderDetail
CREATE TABLE OrderDetail (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,3),
    OrderID INT NOT NULL,
    ProductDetailID INT NOT NULL,
    Quantity INT NOT NULL CHECK(Quantity > 0),
    UnitPrice DECIMAL(18, 2) NOT NULL CHECK(UnitPrice > 0), --Don gia cua san pham
	FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
	FOREIGN KEY (ProductDetailID) REFERENCES [dbo].[ProductDetail]([ProductDetailID])
);




