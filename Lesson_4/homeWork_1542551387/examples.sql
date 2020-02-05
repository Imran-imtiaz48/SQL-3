/* ���������� � ��������� � ����������� ���� ������� ����� 20*/
create view Product_view1 (NameProduct, SupplierName, UnitsInStocks)
as
select Products.ProductName, Suppliers.CompanyName, Products.UnitsInStock
from
Products, Suppliers
where Products.SupplierID = Suppliers.SupplierID
and
Products.UnitsInStock>20;

select * from Product_view1;



/* ���������� */
create view Sorted_view2
as
select top 1000 Products.ProductName,Categories.CategoryName,Products.UnitPrice
from Products,Categories
where Products.CategoryID = Categories.CategoryID
order by 1;

select * from Sorted_view2;


/*�����������*/
/*1.  sp_...*/
/*2. into, Union */
create view Sorted_view3
as
select top 1000 Products.ProductName,Categories.CategoryName,Products.UnitPrice into TmpTable
from Products,Categories
where Products.CategoryID = Categories.CategoryID
order by 1;
/*3. ������ �������� � �������� ��������*/
/*4. view < 1024 �����*/

alter view Product_view1
as
select Products.ProductName, Suppliers.CompanyName, Products.UnitsInStock
from
Products, Suppliers
where Products.SupplierID = Suppliers.SupplierID
and
Products.UnitsInStock>20;

select * from Product_view1;

/*��������*/
--drop view Product_view1;



/* ���������������, �����������*/
update Product_view1 set UnitsInStock = (UnitsInStock+15) where ProductName = 'Chai'; 
delete from Product_view1 where ProductName = 'Chai';

/*�������*/
alter view Product_view2
as
select Products.ProductName, Products.UnitsInStock
from Products
where
Products.UnitsInStock>20
with check option;

insert into Product_view2 (ProductName,UnitsInStock)
values ('snickers',55);



select * from Product_view1;