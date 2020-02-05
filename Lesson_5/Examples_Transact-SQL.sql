/*T-Sql - ����
�� �������� ���������� ����� T-SQL � ��������� ���-
���������� ��� ������ � ��������� ��������� �������,
��������� ��� ���� ������ ���������� ��������*/

 /*��� ���������� ����� T-SQL:
1. ��������� BEGIN..END, ������� ������������ �������-
�� ���������� ������������� �����.
2. ����������, ������� ������ ��� ���������� �����-
������� ������. ��� ����, ����� ������� �������-
���, ����� �� ���������������:
 */

 -- ***** �������� *******
 declare @var_1 varchar(25);

 -- ***** �������� �������� ******
 declare @var_2 varchar(10),@var_3 int;

 -- ***** �������� � ������������� *******
 declare @var_4 int = 78;

 -- ***** �������� c������� � ������������� ********
 declare @var_5 varchar(25) = 'Hello World',
		@var_6 datetime = '28/05/2018';

-- ********* ������������� *********
set @var_1 = 'I am a teacher';
select @var_2 = 'Gosha', @var_3 = 37;


-- ******** ���������� ���������� ���� ***********
-- ������� ���������� ���������� ����
declare @ProductTable table(id int not null, ProductName varchar(255));
-- ��������� ���������� �������
insert @ProductTable select Products.ProductID, Products.ProductName from Products; 
-- ������� �� ����� ������ � ���������� ���� �������
select id, ProductName from @ProductTable order by 1;
 
 -- ******** ����� : ***********
 --select
 select '�������� ���������� @var_4 = '+convert(varchar,@var_4);
 select '@var_1 = '+@var_1+' '+
 ', @var_2 = '+@var_2+', @var3 = '+convert(varchar,@var_3)+
 ', @var_5 = '+@var_5+', @var_6 = '+convert(varchar,@var_6)

 -- print - ������ ������������ �������� ������������
 declare @msg varchar(max) = '@var_1 = '+@var_1+' '+
 ', @var_2 = '+@var_2+', @var3 = '+convert(varchar,@var_3)+
 ', @var_5 = '+@var_5+', @var_6 = '+convert(varchar,@var_6);

print @msg;
print @msg +' - error';
go

-- ******** �������� �������� if.else ***********
if(datename(dw, GetDate())) = 'Monday'
	print '������� �����������';
else 
	print '������� �� �����������';

-- ********* select � �������� ���������� ************
--	��������� ������� ���� ��������� �, ���� ���������� ���� ����� ������
--  50 ���., ����� ������� ��������������� ���������:
if(select avg(UnitPrice) from Products) > 50
	begin 
		print '���������� ��������, ������� ���� ������� ������ 50 ���' 
	end
else 
	begin 
		print '�� ���������� ��������, ������� ���� ������� ������ 50 ���' 
	end
go

if(select avg(UnitPrice) from Products) > 50
	begin 
		print '���������� ��������, ������� ���� ������� ������ 50 ���' 
	end
else 
	begin 
		print '�� ���������� ��������, ������� ���� ������� ������ 50 ���' 
	end
go

/*������� ��� ���������� ��� ������
�������, ���� �������� ��������� � ����������
�� 10 �� 20:*/
if exists(select * from Products where Products.UnitPrice between 10 and 30)
	begin 
		select '���������� ��� ��������'
		select * from Products where Products.UnitPrice between 10 and 30
		return
	end
go


-- ********** �������� ��������� CASE ************
/*����������! � SQL Server CASE �������� ��������, � ��
��������. � ����� � ���� CASE ����� ��������������
������ ��� ����� ��������� SELECT ��� UPDATE, � ��-
����� �� ��������� IF, ������� �������� ��������������.*/

select 'Product', 'Category';

select 'Product' = 'snickers', 'Category' = 'Chocklet';

select 'Product' = Products.ProductName, 'Category' = Categories.CategoryName
from Products, Categories where Products.CategoryID = Categories.CategoryID;

/* ������� �����*/
/*������� ������, ������� ����� �������� ��
����� �������� ��������� � �� ��������� � ��������-
��� ����*/
select 'Product Name' = Products.ProductName,
'Category' = case Categories.CategoryName
	when 'Beverages' then 'This is Beverage Category'
	when 'Condiments' then 'This is Condiments Category'
	else 'This is other Category'
	end
from Products, Categories 
where Products.CategoryID = Categories.CategoryID;	

/*
� �������. � ���� ����� CASE ����� ������� ��-
������ ��������� ��� ������ ����������
WHEN.
*/					 
/*������, � ������� ����� ��������� ���� ��������.
� �������������� ������ ������������ �����-
���, ��������������� ������ ������� true. 
����������� 2 ������� � ����������� when*/
select 'Product title' = Products.ProductName,
'Price' = case
	when Products.UnitPrice<30 then 'Product cheaper than 30'
	when Products.UnitPrice between 30 and 60 then 'Price ranges between 30 and 60'
	else 'Product more expensive than 60'
	end
from Products;

-- ********* �������� �� NULL, ������� coalesce **********
-- � ���������� case
select 'Costomer Name' = Customers.ContactName,
'Region' = case
	when Customers.Region is not null then 'Region is not null'
	else 'Region is null'
	end
from Customers;

-- � �������������� ������� coalesce
select 'Costomer Name' = Customers.ContactName,
'Region' = coalesce(Customers.Region + ' not null', 'Region is null')
from Customers;


-- ************** �������� case ����� ������� NULL,  Nullif ***************
--��� ���������� ��-
--����� �� ����� �������� ��������� � �� �������. ���� ��������
--������� ����� ����, ����� ������� NULL.
-- � ���������� case
select 'Books' = ProductName,
 'Pressrun' = case
 when UnitsInStock = 0 then NULL
 else UnitsInStock
 end
from Products;

-- � �������������� ������� nullif
select 'Books' = ProductName,
 'Pressrun' = NULLIF(UnitsInStock,0)
from Products;

/*���������� ������� ��������� ����� ��������
������� (�� ����).*/
select 'Number of product whith not zero stock' =
count(nullif(UnitsInStock,0)) 
from Products;

-- ************ �������� ������������ �������� GOTO **************
label1: PRINT '�������� �����������'
GOTO label
PRINT '�������� �� �����������'
label: PRINT '����� ����������'

-- ������������ error
label1: PRINT '�������� �����������'
GOTO label2
PRINT '�������� �� �����������'
label2: PRINT '����� ����������'
goto label1

-- *********** ����� WHILE (break, continue, END) ***********
-- ������� ����������
declare @i int;
set @i = 1;
-- ��������� ����
-- �� ����
while @i<10
begin
	print @i
	set @i = @i + 1	
	if @i> 5
		break
end;
-- �� ������
set @i = 1;
while @i<10
begin
	if @i % 2 != 0
		print @i
	set @i = @i + 1	
end;

-- ��������� ������� ���� ���� ���������. ���� ���
-- ������ 35 ���., �� ��� ���� �������� �� 10% �� ��� ���,
-- ���� ������� ���� �� ������ ������ 35 ���.
select avg(UnitPrice) from Products;
while (select avg(UnitPrice) from Products)<35
begin
	update Products set UnitPrice = UnitPrice*1.1
end;
select avg(UnitPrice) from Products;

-- **************** ����� ��������� ��������� (������������ ���������������) ***************

