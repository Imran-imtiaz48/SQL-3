----������� �� pw_1.txt 

--1. ����� �������, ������� � ��� �������, ��� ���� ���� �� ����
  -- �� ��������� �� ��������������� ����, ���������� � ��.
  --  ��������� ������� ��������� � ��������� �������������.

    create view View_1 (Author, AuthorCountry,ShopName, CountryName)
as
  select a.AuthorName+' '+a.AuthorSurName as '�����', 
  a.AuthorCountry as '������ ������', sh.ShopName as '�������',
  c.CountryName as '������ ��������'
  from [Author]a join [Books] b on a.Id=b.AuthorId
  join [Sales]s on b.Id=s.BooksId
  join [Shop]sh on sh.SalesId=s.Id
  join [Country] c on c.Id = sh.CountryId
  where a.AuthorCountry=c.CountryName
  Group by a.AuthorName+' '+a.AuthorSurName, 
  a.AuthorCountry , sh.ShopName ,
  c.CountryName;

  select * from View_1;


  --2. �������� �������������, ���������� ����� ������� ����� ��������,
  -- ��������, "Web Technologies".
    create view View_2 (BookName, Price , JanreName )
as
  select top 1 b.BookName, b.Price , j.JanreName 
  from [Books] b join [Janre]j  on b.JanreId=j.Id
  where j.JanreName='�������'
  Order by 2 desc
  go
  
  select * from View_2
  go

  --3. �������� �������������, ������� ��������� ������� ��� ����������
   --� ������ ���������. ������������� ������� �� ������� � ������������ 
   --� �� ��������� ��������� � ��������� �������.

    create view View_3_1 (ShopName, CountryName , BookCount )
as
select sh.ShopName, c.CountryName, sh.BookCount
from [Sales]s join [Shop]sh on s.Id= sh.SalesId
join [Country]c on sh.CountryId=c.Id
group by sh.ShopName, c.CountryName, sh.BookCount
go


select * from View_3_1 
order by 2 desc, 1 asc
go


--4. �������� �������������, ������������ ����� ���������� �����.

    create view View_4 (BookName, CountSales )
as

select top 1 b.BookName, sum (s.SaleCount) as 'Count of sales'
from [Books] b join [Sales] s on b.Id=s.BooksId
group by b.BookName
order by 2 desc
go

select * from View_4
go

--5. �������� ���������������� �������������, � ������� ��������������� ���������� �� �������,
-- ����� ������� ���������� � � ��� �.
    create view View_5 (Author)
as
SELECT a.AuthorName+' '+a.AuthorSurName as 'Author' 
FROM [Author] a
where a.AuthorName like '[��]%'
go

select * from view_5
go

--6. �������� �������������, � ������� � ������� ����������� ������� 
--�������� ���������, ������� ��� �� ������� ����� ������ ������������.
create view view_6 (ShopName)
as
select sh.ShopName
from  [Shop] sh 
where sh.BookCount=0
group by sh.ShopName
go

select * from view_6
go
 
