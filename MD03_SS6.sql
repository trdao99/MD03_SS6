drop database bookstore;

-- Tạo cơ sở dữ liệu
CREATE DATABASE bookstore;

-- Sử dụng cơ sở dữ liệu
USE bookstore;

-- Tạo bảng Category
CREATE TABLE Category
(
    Id     INT PRIMARY KEY AUTO_INCREMENT,
    Name   VARCHAR(100) NOT NULL,
    Status TINYINT DEFAULT 1 CHECK (Status IN (0, 1))
);

-- Tạo bảng Author
CREATE TABLE Author
(
    Id        INT PRIMARY KEY AUTO_INCREMENT,
    Name      VARCHAR(100) NOT NULL,
    TotalBook INT DEFAULT 0
);

-- Tạo bảng Book
CREATE TABLE Book
(
    Id          INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(150) NOT NULL,
    Status      TINYINT DEFAULT 1 CHECK (Status IN (0, 1)),
    Price       FLOAT        NOT NULL CHECK (Price >= 100000),
    CreatedDate DATE    DEFAULT (CURDATE()),
    CategoryId  INT          NOT NULL,
    AuthorId    INT          NOT NULL,
    FOREIGN KEY (CategoryId) REFERENCES Category (Id),
    FOREIGN KEY (AuthorId) REFERENCES Author (Id)
);

-- Tạo bảng Customer
CREATE TABLE Customer
(
    Id          INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(150) NOT NULL,
    Email       VARCHAR(150) NOT NULL UNIQUE CHECK (Email LIKE '%@gmail.com' OR Email LIKE '%@facebook.com' OR
                                                    Email LIKE '%@bachkhoa-aptech.edu.vn'),
    Phone       VARCHAR(50)  NOT NULL UNIQUE,
    Address     VARCHAR(255),
    CreatedDate DATE DEFAULT (CURDATE()),
    Gender      TINYINT      NOT NULL CHECK (Gender IN (0, 1, 2)),
    BirthDay    DATE         NOT NULL
);

-- Tạo bảng Ticket
CREATE TABLE Ticket
(
    Id         INT PRIMARY KEY AUTO_INCREMENT,
    CustomerId INT NOT NULL,
    Status     TINYINT  DEFAULT 1 CHECK (Status IN (0, 1, 2, 3)),
    TicketDate DATETIME DEFAULT (CURDATE()),
    FOREIGN KEY (CustomerId) REFERENCES Customer (Id)
);

-- Tạo bảng TicketDetail
CREATE TABLE TicketDetail
(
    TicketId    INT   NOT NULL,
    BookId      INT   NOT NULL,
    Quantity    INT   NOT NULL CHECK (Quantity > 0),
    DeposiPrice FLOAT NOT NULL,
    RentCost    FLOAT NOT NULL,
    PRIMARY KEY (TicketId, BookId),
    FOREIGN KEY (TicketId) REFERENCES Ticket (Id),
    FOREIGN KEY (BookId) REFERENCES Book (Id)
);
INSERT INTO Category (Name, Status)
VALUES ('Fiction', 1),
       ('Science', 1),
       ('Biography', 1),
       ('Romance', 1),
       ('Mystery', 1);
INSERT INTO Author (Name, TotalBook)
VALUES ('John Doe', 0),
       ('Jane Smith', 0),
       ('Michael Johnson', 0),
       ('Emily Davis', 0),
       ('David Wilson', 0);
INSERT INTO Book (Name, Status, Price, CreatedDate, CategoryId, AuthorId)
VALUES ('Book 1', 1, 150000, '2024-04-25', 1, 1),
       ('Book 2', 1, 200000, '2024-04-25', 2, 2),
       ('Book 3', 1, 180000, '2024-04-25', 1, 3),
       ('Book 4', 1, 120000, '2024-04-25', 3, 4),
       ('Book 5', 1, 250000, '2024-04-25', 2, 5),
       ('Book 6', 1, 170000, '2024-04-25', 1, 1),
       ('Book 7', 1, 220000, '2024-04-25', 2, 2),
       ('Book 8', 1, 190000, '2024-04-25', 1, 3),
       ('Book 9', 1, 130000, '2024-04-25', 3, 4),
       ('Book 10', 1, 270000, '2024-04-25', 2, 5),
       ('Book 11', 1, 160000, '2024-04-25', 1, 1),
       ('Book 12', 1, 240000, '2024-04-25', 2, 2),
       ('Book 13', 1, 200000, '2024-04-25', 1, 3),
       ('Book 14', 1, 140000, '2024-04-25', 3, 4),
       ('Book 15', 1, 300000, '2024-04-25', 4, 2);
INSERT INTO Customer (Name, Email, Phone, Address, CreatedDate, Gender, BirthDay)
VALUES ('John Smith', 'johnsmith@gmail.com', '123456789', '123 Main St', '2024-04-25', 1, '1990-01-01'),
       ('Jane Doe', 'janedoe@gmail.com', '987654321', '456 Elm St', '2024-04-25', 0, '1992-05-10'),
       ('Michael Johnson', 'michaeljohnson@gmail.com', '555555555', '789 Oak St', '2024-04-25', 1, '1988-11-15');
INSERT INTO Ticket (CustomerId, Status, TicketDate)
VALUES (1, 1, NOW()),
       (2, 1, NOW()),
       (3, 1, NOW());
INSERT INTO TicketDetail (TicketId, BookId, Quantity, DeposiPrice, RentCost)
VALUES (1, 1, 2, 150000, 15000),
       (1, 3, 1, 180000, 18000),
       (2, 2, 3, 200000, 20000),
       (2, 4, 2, 120000, 12000),
       (3, 5, 2, 250000, 25000),
       (3, 7, 3, 150000, 15000);
# 1.1	Lấy ra danh sách Book có sắp xếp giảm dần theo Price gồm các cột sau:
# Id, Name, Price, Status, CategoryName, AuthorName, CreatedDate
select Book.Id, Book.Name, Price, Book.Status, C.Name, A.Name, CreatedDate
from book
         join Category C on C.Id = book.CategoryId
         join Author A on A.Id = book.AuthorId
order by Price desc;

# 1.2.	Lấy ra danh sách Category gồm:
# Id, Name, TotalProduct,
# Status (Trong đó cột Status nếu = 0, Ẩn, = 1 là Hiển thị )
select Category.Id, Category.Name, count(b.Id), IF(Category.Status = 0, 'AN', 'HIEN')
from category
         join Book B on category.Id = B.CategoryId
group by Category.Id;

# 1.3.	Truy vấn danh sách Customer gồm:
# Id, Name, Email, Phone, Address, CreatedDate, Gender, BirthDay, Age
# (Age là cột suy ra từ BirthDay, Gender nếu = 0 là Nam, 1 là Nữ,2 là khác )
select Id,
       Name,
       Email,
       Phone,
       Address,
       CreatedDate,
       case
           when Gender = 0 then 'Nam'
           when Gender = 1 then 'Nữ'
           when Gender = 2 then 'khác'
           end as 'gender',
       BirthDay,
       timestampdiff(year, BirthDay, CURDATE())
from customer;


# 1.4.	Truy vấn xóa Author chưa có sách nào
select Author.Id
from author
where id not in ((select distinct Author.Id
                  from author
                           join Book B on author.Id = B.AuthorId));
# 5.	Cập nhật Cột ToalBook trong bảng
# Auhor = Tổng số Book của mỗi Author theo Id của Author
UPDATE Author
SET TotalBook = (SELECT COUNT(*)
                 FROM Book
                 WHERE Book.AuthorId = Author.Id);
# 2.1.	View v_getBookInfo thực hiện lấy ra danh sách các Book
# được mượn nhiều hơn 3 cuốn
create view v_getBookInfo as
select BookId, Name
from ticketdetail
         join Book B on ticketdetail.BookId = B.Id
where Quantity >= 3;
select *
from v_getBookInfo;
#2.2	View v_getTicketList hiển thị danh sách Ticket gồm:
# Id, TicketDate, Status, CusName, Email, Phone,TotalAmount
# (Trong đó TotalAmount là tổng giá trị tiện phải trả, cột Status nếu = 0 thì hiển thị Chưa trả,
# = 1 Đã trả, = 2 Quá hạn, 3 Đã hủy)
create view v_getTicketList as
select Ticket.Id,
       TicketDate,
       case
           when Ticket.Status = 0 then 'Chưa trả'
           when Ticket.Status = 1 then 'Đã trả'
           when Ticket.Status = 2 then 'Quá hạn'
           when Ticket.Status = 3 then 'Đã hủy'
           end,
       C.Name,
       Email,
       Phone,
      sum((B.Price * Quantity)) TotalAmount
from ticket
         join TicketDetail TD on ticket.Id = TD.TicketId
         join Customer C on ticket.CustomerId = C.Id
         join Book B on B.Id = TD.BookId
group by Ticket.Id, TicketId;
select *
from v_getTicketList;

# 3.1.	Thủ tục addBookInfo thực hiện thêm mới Book, khi gọi thủ tục truyền đầy đủ các giá trị của bảng Book ( Trừ cột tự động tăng )
# a.	Thủ tục getTicketByCustomerId hiển thị danh sách đơn hàng của khách hàng theo Id khách hàng gồm:
# Id, TicketDate, Status, TotalAmount (Trong đó cột Status nếu =0 Chưa trả, = 1  Đã trả, = 2 Quá hạn, 3 đã hủy ),
# Khi gọi thủ tục truyền vào id cuả khách hàng

delimiter //
create procedure addBookInfo(
    Name_IN VARCHAR(150),
    Status_IN TINYINT,
    Price_IN FLOAT,
    CreatedDate_IN DATE,
    CategoryId_IN INT,
    AuthorId_IN INT)
begin
    INSERT INTO Book (Name, Status, Price, CreatedDate, CategoryId, AuthorId) value
        (
         Name_IN,
         Status_IN,
         Price_IN,
         CreatedDate_IN,
         CategoryId_IN,
         AuthorId_IN);
end
//

delimiter //
create procedure getTicketByCustomerId(id_IN int)
begin
    select Customer.Id,
           TicketDate,
           case
               when T.Status = 0 then 'Chưa trả'
               when T.Status = 1 then 'Đã trả'
               when T.Status = 2 then 'Quá hạn'
               when T.Status = 3 then 'Đã hủy'
               end,
           sum((price * Quantity)) totalAmount
    from customer
             join Ticket T on customer.Id = T.CustomerId
             join TicketDetail TD on T.Id = TD.TicketId
             join Book B on B.Id = TD.BookId
    where Customer.Id = Id_in
    group by Customer.Id,TicketId;
end
//
call getTicketByCustomerId(1);
delete
from book
where id = 16;
call addBookInfo('Book 16', 1, 150000, '2024-04-25', 1, 1);
# 3.2.	Thủ tục getBookPaginate lấy ra danh sách sản phẩm có phân trang gồm: Id, Name, Price, Sale_price, Khi gọi thủ tuc truyền vào limit và page
delimiter //
create procedure getBookPaginate(page int, size int)
begin
    declare off_set int;
    set off_set = page * size;
    select Id, Name, Price from book limit off_set, size;
end //















