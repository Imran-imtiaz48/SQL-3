
--������� �� pw_2.txt 


--2. �������� ������������� ������� �� ���������� ���������� ��������� � ������ ������
create view view_1 (CountCostoners, City)
as
select count(c.CustomerID) as 'CountCostoners', c.City
from [Customers]c 
group by c.City
go

select * from view_1
go

/*3. �������� ������������� ������� Products, ������� ������ �������� ������ ����
 UnitPrice � UnitsInStocks.  � ������� ����� �������������, ����� ����� ������� 
 ��� �������� ������ ����, �� ������ ��� �������� ����� 10 � 20.*/

 create view view_2 (UnitsInStock, UnitPrice)
as
select p.UnitsInStock,p.UnitPrice
from
[Products] p
where p.UnitsInStock<=20 and p.UnitsInStock>=10 and p.UnitPrice<=20 and p.UnitPrice>=10
go
