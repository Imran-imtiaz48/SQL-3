

----������ 1 ------- �������� � �� BookSops

---
select b.NameBook, count (sh.NameShop) as 'Shop count'
into #tmp_1
from [books]b join [sales] s on b.ID_BOOK = s.ID_BOOK
join [Shops] sh on sh.ID_SHOP = s.ID_SHOP
group by b.NameBook ;

select b.NameBook, sh.NameShop
from [books]b join [sales] s on b.ID_BOOK = s.ID_BOOK
join [Shops] sh on sh.ID_SHOP = s.ID_SHOP
where b.NameBook in(
select tmp.NameBook
from [#tmp_1]tmp 
where tmp.[Shop count]>1
)





----������ 2 ------ �� �3  PublishingHouse-----------------------------------------------------------------------------------------------
Select sum(s.SaleCount) as 'SumSalesCount', b.BookName as 'Book name' 
into #TMPTab_1
from [Author] a 
join[books]	b on a.Id = b.AuthorId
join [sales] s on b.Id=s.BooksId and a.AuthorCountry = '���'
 Group by b.bookname;


Select sum(s.SaleCount) as 'CountSaleBooks', a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as 'Author', 
b.BookName as 'BookName', a.AuthorCountry as 'AuthorCountry'
into #TMPTab_2
from [Author] a 
join[books]	b on a.Id = b.AuthorId
join [sales] s on b.Id=s.BooksId and a.AuthorCountry!='���'
Group by  a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName ,b.BookName, a.AuthorCountry;

select tmp2.CountSaleBooks as '���������� �������� ����', tmp2.Author as '�����', tmp2.Bookname as '�������� �����',
tmp2.AuthorCountry as '������ ������'
from [#TMPtab_2]tmp2
where tmp2.CountSaleBooks>(select max (tmp.SumSalesCount)from [#TMPTab_1]tmp);

-----������ �3 ----�� 3
select b.BookName as '�������� �����', a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as 'Author'
from [Author]a
join[books]	b on a.Id = b.AuthorId
where b.IsPublish='Yes';

-----������ �4 ----�� 3
 Select a.AuthorSurName+' '+a.AuthorName+' '+a.AuthorSecName as '�����', 
 a.AuthorCountry as '������ ������', sh.ShopName as '�������', c.CountryName as '������ ��������'
From [Author] a
join [Books]b on a.Id=b.AuthorId
join [Sales]s on b.Id=s.BooksId
join [Shop]sh on s.ShopId=sh.CountryId
join [Country]c on sh.CountryId=c.Id
where  a.AuthorCountry=c.CountryName and a.AuthorCountry in (
Select c.CountryName as '������ ��������'
From [Author] a
join [Books]b on a.Id=b.AuthorId
join [Sales]s on b.Id=s.BooksId
join [Shop]sh on s.ShopId=sh.CountryId
join [Country]c on sh.CountryId=c.Id
where a.AuthorCountry=c.CountryName
group by  c.CountryName
)
group by a.AuthorSurName+' '+a.AuthorName+' '+a.AuthorSecName , a.AuthorCountry , sh.ShopName , c.CountryName
order by 1;

----������ 5------
--------------------------1-� ����� ������� � ����� �������������
Select  top 1 j.JanreName as '����',  sum(b.�irculation) as '��������� �����'
 From [Author]a
 join [Janre]j on a.Id=j.Id
 join [Books]b on a.Id=b.AuthorId
 Group by j.JanreName
 order by 2 desc;
--------------------------2-� ����� ������� � ����� �������������
 Select  j.JanreName as '����',  sum(b.�irculation) as '��������� �����'
 From [Author]a
 join [Janre]j on a.Id=j.Id
 join [Books]b on a.Id=b.AuthorId
 Group by j.JanreName
 order by 2 desc;




----������ �6 ---------------
 Select a.AuthorSurName+' '+a.AuthorName+' '+a.AuthorSecName as '�����', 
 j.JanreName as '����', b.BookName as '�����', b.DateOfPubl '���� ����������'
 From [Author]a
 join [Janre]j on a.Id=j.Id
 join [Books]b on a.Id=b.AuthorId and j.JanreName='�������'
 Union
 Select a.AuthorSurName+' '+a.AuthorName+' '+a.AuthorSecName as '�����', 
 j.JanreName as '����', b.BookName as '�����', b.DateOfPubl '���� ����������'
 From [Author]a
 join [Janre]j on a.Id=j.Id
 join [Books]b on a.Id=b.AuthorId and year(b.DateOfPubl)=2017
 Group by a.AuthorSurName+' '+a.AuthorName+' '+a.AuthorSecName , 
 j.JanreName, b.BookName , b.DateOfPubl
 order by 1
 ---���������� 3 �� ������� 6, �� ���� ��� ��� ��������� � ���� �������.
 Select a.AuthorSurName+' '+a.AuthorName+' '+a.AuthorSecName as '�����', 
  sum(b.�irculation*b.Price) as '��������� ������'
 From [Author]a
 join [Janre]j on a.Id=j.Id
 join [Books]b on a.Id=b.AuthorId
 Group by a.AuthorSurName+' '+a.AuthorName+' '+a.AuthorSecName   
 order by 2 desc;


 ----������ 7 -----
 Select sh.ShopName , sum(sh.BookCount) as 'BookCount'
into #TMP_tabl_7_3
From [Books]b
join [Sales]s on b.Id=s.BooksId
join [Shop]sh on s.Id=sh.SalesId
group by sh.ShopName
order by 2;

select tmp7.ShopName as '�������', tmp7.BookCount as '�������� � ������� ���-�� ����'
from [#TMP_tabl_7_3] tmp7
where tmp7.BookCount=(
select  max(tmp7.BookCount) as '�������� � ������� ���-�� ����'
from [#TMP_tabl_7_3] tmp7)
union
select tmp7.ShopName as '�������',tmp7.BookCount as '�������� � ������� ���-�� ����'
from [#TMP_tabl_7_3] tmp7
where tmp7.BookCount=(
select  min(tmp7.BookCount) as '�������� � ������� ���-�� ����'
from [#TMP_tabl_7_3] tmp7)
order by 2;


----������ 8-----

INSERT into [Author] VALUES 
							('�����','���������','����������','������'),
							('������', '������','����������','�������');
---1-� ������� (� �����������)								
Select a.AuthorSurName+' '+a.AuthorName+' '+a.AuthorSecName as '�����', b.IsPublish
from [Author]a
left join [Books]b on a.Id=b.AuthorId
where a.Id not  in (
select b.AuthorId from [Books]b 
)
---2-� ������� (��� ����������)

Select a.AuthorSurName+' '+a.AuthorName+' '+a.AuthorSecName as '�����', b.IsPublish
from [Author]a	left join [Books]b on a.Id=b.AuthorId
where b.Id is null


-----������ 9 -----

Select a.AuthorName, a.AuthorSurName,count( sh.ShopName) as ShopCount, c.CountryName
into #TMP_9
From [Author]a 
join [Books]b on a.Id=b.AuthorId 
join [Sales] s on b.Id = s.BooksId
join [Shop] sh on sh.Id = s.Id
join [Country] c on sh.CountryId = c.Id
Group by a.AuthorName, a.AuthorSurName, sh.ShopName, c.CountryName;

create table [ShopAuthors]
(
    [Id] int primary key identity not null,
    [AuthorName] nvarchar(100) not null check([AuthorName]!=N''),
	[AuthorSurName] nvarchar(100) not null check([AuthorSurName]!=N''),
	[ShopName] int not null ,
	[CountryName] nvarchar(100) not null 
);
go

INSERT INTO ShopAuthors
select *
from [#TMP_9]  tmp
where tmp.ShopCount>1;


-----������ 10 -----

select b.BookName, b.PageCount
into #tmp_10
from [Books]b;

delete 
from #tmp_10
where PageCount>(
select avg (tmp.PageCount)
from [#tmp_10]tmp)

select * from #tmp_10;

----------------- ������ 11 ---- ���������� �� bookshops------------



Select a.FirstName as Author,b.NameBook as Book
from [Books] b left join [Authors] a on a.ID_AUTHOR= b.ID_AUTHOR;

delete 
from Books
where ID_AUTHOR is null;

 -------------------������ 12 �������� � �� PublishingHouse

 select *
into #tmp_12_1
from [Shop]sh;

delete
from #tmp_12_1
where CountryId in(
Select  c.Id
From [Shop]sh join [Country]c on sh.CountryId=c.Id
where c.CountryName= '������'
group by c.Id );

select * from #tmp_12_1;



------ ������ 13 - -

---��� �������������� �������, ���� ������� ���������.
Select sh.ShopName, b.BookName, s.SaleCount, s.Price, s.DateOfSal
From [Books] b join [Sales]s on b.Id = s.BooksId
join [Shop]sh on sh.SalesId=s.Id 
join [Country] c on sh.CountryId=c.Id
where c.CountryName = '�������' and sh.ShopName='��������';

UPDATE sales
SET price = price * 1.05, SaleCount=SaleCount+10
WHERE shopid IN
(SELECT s.ShopId FROM [Sales]s join [Shop]sh on sh.SalesId=s.Id 
join [Country] c on sh.CountryId=c.Id
where c.CountryName = '�������' and sh.ShopName='��������');


-----������ 14 -------


select top 2 sum(s.SaleCount) as SaleCount , sh.ShopName
into #tmp_14_1
from [Sales] s join [Shop]sh on s.Id=sh.SalesId
group by sh.ShopName
order by 1;


UPDATE Shop
SET BookCount=BookCount*0.85
WHERE ShopName IN
(select tmp.ShopName
from [#tmp_14_1] tmp
)


