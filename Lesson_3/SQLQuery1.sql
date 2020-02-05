

----1----
SELECT b.BookName as '�������� �����', a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as '�����' 
FROM
Books b, Author a
WHERE b.AuthorId = a.Id and a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName in (SELECT  Top 3
a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as '�����'
FROM
Books b, Author a
WHERE b.AuthorId = a.Id
Group by  a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName
ORDER BY RAND()
)
order by '�����' 



---2----
SELECT b.BookName as '�������� �����', b.PageCount as '���������� �������' 
FROM Books b
where b.PageCount>500 and b.PageCount<650
order by b.PageCount 

----3----
SELECT b.BookName as '�������� �����' 
FROM Books b
where b.BookName like '%[��]%';

---4----
SELECT B.BookName as '�������� �����', J.JanreName as '����', B.�irculation as '�����'
FROM BOOKS B, JANRE J
WHERE j.Id = b.JanreId and J.JanreName != '�������' and b.�irculation>=100000


----5----
SELECT B.BookName as '�������� �����' , b.DateOfPubl as '���� �������', b.Price as '����, $'
FROM Books B
where  YEAR(GETDATE())-year(b.DateOfPubl)<=0 and b.Price <30


---6---
SELECT B.BookName as '�������� �����'
FROM Books B
WHERE B.BookName LIKE '� [^�������]%'

----7----
SELECT B.BookName as '�������� �����', J.JanreName as '����',  b.Price/b.PageCount as '����',
 a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as '�����' 
FROM [Books] B 
JOIN [Janre] J ON j.Id = b.JanreId
JOIN [Author] A ON a.Id = b.AuthorId
WHERE b.Price/b.PageCount<0.06

---8---
SELECT B.BookName as '�������� �����'
From Books b
WHERE b.bookname like '% % % %';

---9---

SELECT B.BookName as '�������� �����',   b.Price as '���� ��� ��������, $', 
 a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as '�����' , s.DateOfsal as '���� �������'
FROM [Sales] S
join [Books] B on b.Id = s.BooksId
join [Author] A  on b.AuthorId=a.Id
Where  s.DateOfSal>'01/01/2018'

 ----10--- 
 Select  B.BookName as '�������� �����', j.JanreName as '����', 
 a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as '�����' , 
 b.Price as '���� ��� ��������, $', sum (s.SaleCount) as '���������� ������',
  sh.ShopName as '�������� ��������', c.CountryName as '������'
 From [Books] b
 join [Janre] j on b.JanreId = j.Id
 join [Author] a on a.Id = b.AuthorId
 join [Sales] s on b.Id = s.BooksId
 join [Shop] sh on sh.SalesId=s.Id
 join [Country] c on c.Id=sh.CountryId
 Where j.JanreName!='�������' and c.CountryName!='�������' and c.CountryName!='������'
  Group by B.BookName , j.JanreName , a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName ,
   b.Price,   sh.ShopName, c.CountryName




 ----11-----
  SELECT COUNT(a.id) as '���������� �������'
into TmpAuthor
from [Author] a;

SELECT * 
from [TmpAuthor] a

---12--

select AVG(s.Price) as AvPrice
into #TmpLocalTable
from [Sales] s;

----13---

SELECT j.JanreName as '����',  avg(b.PageCount) as '������� ����� �������'
FROM [Janre] J
join [Books] b on b.JanreId= j.Id
Group by j.JanreName;

---14---
Select top 3 a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as '�����',
sum(b.Id) as '���������� ����', sum(b.PageCount) '����� �������'
From [Books] b
join [Author] a on b.AuthorId= a.Id
Group by a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName

-----15---
Select b.BookName as '�������� �����', max(b.PageCount) as '���������� ���������� ��������'
From [Janre]j
join [Books] b on b.JanreId = j.Id
where j.JanreName='�������'
Group by b.BookName;


----16---- ����������

Select a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as '�����', 
b.BookName as '�������� �����', b.DateOfPubl as '���� �������'
--into ##GlobTable_16
From [Author] a
join [Books] b on b.AuthorId = a.Id
where b.DateOfPubl in (

)
Group by a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName , b.BookName,b.DateOfPubl

---��� �������� ��� ��� ���� ���������� � �������,��� �������� �����
select min(b.DateOfPubl),a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as '�����'

From [Author] a
join [Books] b on b.AuthorId = a.Id
group by a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName 


---17----

select  avg(b.PageCount) as '������� ���-�� ��� �� ��������', j.JanreName as '����'
from [Janre] j
join [Books] b on b.JanreId= j.Id
group by j.JanreName
having avg(b.PageCount)>400;

-----18----

select  sum(b.PageCount) as '����� �������', j.JanreName as '����'
from [Janre] j
join [Books] b on b.JanreId= j.Id
where j.JanreName in('�������','������ ����������')
group by j.JanreName
having sum(b.PageCount)>300;


---19---
select sum (s.SaleCount) as BookSalCount , s.DateOfSal as DateSale, sh.ShopName as Shop
into #TMPTab_19
from [Sales]s
join [Shop] sh on sh.SalesId = s.Id
where s.DateOfSal>'01/10/2018'
group by s.DateOfSal, sh.ShopName;

select sum (tmp.BookSalCount) as '��-�� ��������� ����', tmp.Shop as '�������'
from [#TMPTab_19]tmp
group by tmp.Shop;
 
 -----20----

  Select  sh.ShopName as '�������� ��������',  B.BookName as '�������� �����', 
  j.JanreName as '����',  a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as '�����' , 
 sum(s.Price) as '�������, $', sum (s.SaleCount) as '���������� ������',
   c.CountryName as '������'
 From [Books] b
 join [Janre] j on b.JanreId = j.Id
 join [Author] a on a.Id = b.AuthorId
 join [Sales] s on b.Id = s.BooksId
 join [Shop] sh on sh.SalesId=s.Id
 join [Country] c on c.Id=sh.CountryId

  Group by sh.ShopName,B.BookName , j.JanreName , a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName ,
       c.CountryName;


----������ 1 ------ �� �3 -----------------------------------------------------------------------------------------------
Select sum(s.SaleCount) as 'SumSalesCount', b.BookName as 'Book name' 
into #TMPTab_1
from [Author] a 
join[books]	b on a.Id = b.AuthorId
join [sales] s on b.Id=s.BooksId and a.AuthorCountry = '���'
 Group by b.bookname
 select max (tmp.SumSalesCount)
from [#TMPTab_1]tmp

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
where tmp2.CountSaleBooks>(select max (tmp.SumSalesCount)from [#TMPTab_1]tmp)


 
