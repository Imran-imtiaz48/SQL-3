/*
View
������������� (view) � ��� ������ ��, ������� ����� �������
��� �������, �� � ������� �� ��� �� ����� ����� ��������-
��� ������.

create view [�����.] ��������_������������� [(���� [,...n])]
as
< �������� select>
[with check option]



WITH CHECK OPTION � ������� ���������������� ����-
���������, � ������� ���������� ����������� ��-
������� ���������� �������� INSERT ��� DELETE,
���� ��� ���� ���������� �������, �������� � ���-
�������� WHERE.
*/

/*1 ������*/
-- ������ �� ��������� ���������� � ���������,
-- ���������� ��������� ����� 20,
-- � �� �����������.
create view Product_View1 (NameProduct, SupplierCompany, CountInStock)
as
select Products.ProductName, Suppliers.CompanyName, Products.UnitsInStock
from Products,Suppliers
where Products.SupplierID = Suppliers.SupplierID and
Products.UnitsInStock > 20;

select * from Product_View1; 


/*
��������� ��������� ���� �������������:

1. ������� ������������� �� ������ ����������� � ��� ����-
��������� �� ������� ������.

2. ���������������� (�����������) ������������ � ��� ��������-
�����, ������� ������������ ����������� ������

*/

/*������ 2*/
/*������ � �������������� ����*/
select * from Product_View1 order by 1;

create view Sorting_View2
as
select Products.ProductName, Categories.CategoryName, Products.UnitPrice
from Products, Categories
where Products.CategoryID = Categories.CategoryID
order by 1; /**************** ������ ***********************/

/*� ����������� ��������� top*/
create view Sorting_View2
as
select top 1000 Products.ProductName, Categories.CategoryName, Products.UnitPrice
from Products, Categories
where Products.CategoryID = Categories.CategoryID
order by 1;

select * from Sorting_View2;

/*�����������*/
/*1.�������� ���������*/
create view sp_View3
as
exec sp_helpdb;

/*2. select into*/
create view into_View4
as
select * into new_table from Products;

/*3. ��� ���������
������ ������������� �������� ������ �������
������;*/

/*4. ������������� �� ����� ��������� ������, ��� ��
1024 ����*/

/*5. UNION � UNION ALL ����������� ��� �����-
������� �������������*/

/**************************************/
/************ ��������� ������������� *************/
alter view Product_View1 (NameProduct, SupplierCompany, CountInStock)
as
select Products.ProductName, Suppliers.CompanyName, Products.UnitsInStock
from Products,Suppliers
where Products.SupplierID = Suppliers.SupplierID and
Products.UnitsInStock < 20;

select * from Product_View1; 


/*�������� �������������*/
drop view Product_View1;


/**************************************/
/************ ����������� ������������� *************/
/*� ����� �������������� ����� ��������� �������
INSERT, UPDATE � DELETE. ���� metanit*/ 
create view Product_View2 (NameProduct, Price, Storcks)
as
select Products.ProductName, Products.UnitPrice, Products.UnitsInStock
from Products
where
Products.UnitsInStock < 20 with check option;

/*������������� ��� ���������
��������� ��������� ������ ���������� �� �����, ��-
������� ��� �� ������������� �������� ������ ������ */
insert into Product_View2 (NameProduct, Price, Storcks)
values ('Microsoft SQL Server', 230,50);

/* ��������� ������ �� ������� ��������� ���������� �������� �������*/
insert into Product_View2 (NameProduct, Price, Storcks)
values ('Microsoft SQL Server', 230,15);

/*���������...*/
select * from Product_View2;

/* ��� �� ������� ���� �� ����� ���� ��������� ����� �������? */
select * from Products;

