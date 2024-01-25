drop database if exists demo;
create database if not exists demo;
use demo;
CREATE TABLE product (
    p_id INT PRIMARY KEY AUTO_INCREMENT,
    p_code VARCHAR(45) NOT NULL,
    p_name VARCHAR(45) NOT NULL,
    p_price DOUBLE NOT NULL CHECK (p_price >= 0 AND p_price < 10000000),
    p_amount LONG NOT NULL,
    CHECK (p_amount >= 0),
    p_description VARCHAR(45) NOT NULL,
    p_status VARCHAR(45) NOT NULL
);

insert into product (p_code, p_name, p_price, p_amount, p_description, p_status)
values('A001','Tu lanh', 5, 5, 'Cao 2m','Hiện đại'),
('B002','May giat', 6, 4, 'Cao 1m','Tiện nghi'),
('C003','Lò vi sóng', 3, 7, 'Nặng 2kg','Đời mới');

/*
- Tạo Unique Index trên bảng Products (sử dụng cột productCode để tạo chỉ mục)
- Tạo Composite Index trên bảng Products (sử dụng 2 cột productName và productPrice)
- Sử dụng câu lệnh EXPLAIN để biết được câu lệnh SQL của bạn thực thi như nào
- So sánh câu truy vấn trước và sau khi tạo index
*/
create unique index code_index
on product(p_code);

create index name_price
on product(p_name, p_price);

explain select * from product where p_name='A001' and p_price = 5;

/*
- Tạo view lấy về các thông tin: productCode, productName, productPrice, productStatus từ bảng products.
- Tiến hành sửa đổi view
- Tiến hành xoá view
*/
CREATE VIEW view_product AS
    SELECT 
        p_code, p_name, p_price, p_status
    FROM
        product;

UPDATE view_product 
SET 
    p_price = 40
WHERE
    p_name = 'Tu lanh';

drop view if exists view_product;

/*
- Tạo store procedure lấy tất cả thông tin của tất cả các sản phẩm trong bảng product
- Tạo store procedure thêm một sản phẩm mới
- Tạo store procedure sửa thông tin sản phẩm theo id
- Tạo store procedure xoá sản phẩm theo id
*/
DELIMITER //
create procedure get_all_product()
begin
select * from product;
end;
//delimiter ;

call get_all_product();

delimiter //
create procedure add_product(
in p_code varchar(45),
in p_name varchar(45),
in p_price double, 
in p_amount long,
in p_description varchar(45),
in p_status varchar(45))
begin
insert into product(p_code,p_name,p_price,p_amount,p_description,p_status)
values(p_pd_code,p_pd_name,p_pd_price,p_pd_amount,p_pd_description,p_pd_status);
end;
// delimiter ;

call add_product('D004', 'May suoi', 4.5, 750202, 'Nặng 2kg','vừa nhập');
delimiter //
create procedure edit_products(in input_id int, in new_p_name varchar(50))
begin
set sql_safe_updates = 0;
UPDATE products 
SET 
    p_name = new_p_name
WHERE
    p_id = input_id AND is_delete = 0;
set sql_safe_updates = 1;
end;
// delimiter ;

call edit_products(1, 'aaa');

delimiter // 
create procedure remove_products( in input_id int)
begin
set sql_safe_updates = 0;
UPDATE products 
SET 
    is_delete = 1
WHERE
    p_id = input_id;
set sql_safe_updates = 1;
end;
// delimiter ;

call remove_products(1);

