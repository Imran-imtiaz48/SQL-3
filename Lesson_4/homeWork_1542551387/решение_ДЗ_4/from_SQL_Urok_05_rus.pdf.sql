--������� �� SQL_Urok_05_rus.pdf.txt 

--1. � ������� ��������� COMPUTE BY �������� ������, ������� ������� �������� 
--��������� � ��������� ���������� ���������� ��������� ����.

select sh.ShopName, sum(sh.BookCount)
from  [Shop] sh 
group by sh.ShopName

--2. � ������� ��������� COMPUTE ������� ������ � ���,
-- ������� �������� ������������ �� ������� ���� �� ��������� ���.


select sh.ShopName, sum(sh.BookCount*s.Price) as '$'
from  [Shop] sh join [Sales]s on sh.SalesId = s.Id
group by sh.ShopName



--3. � ������� ���������� CUBE � ROLLUP �������� ��� �������, ������� �����
-- ���������� ���������� � ������� ���������� ������� ����  ����������
--  �������������� � ������ � ���������� 01/01/2008 �� 01/09/2008.
--   �������� ������� ���������� ������, ��� �� ������ ������, 
--   ��� � �� ���������� ��������.

select sh.ShopName , c.CountryName, avg(s.SaleCount) as 'Sale books'
from [Sales]s join [Shop] sh on sh.SalesId = s.Id
join [Country] c on sh.CountryId=c.Id
where c.CountryName in ('�������', '������') 
and s.DateOfSal between '2017-01-01' and '2018-12-01'
group by sh.ShopName , c.CountryName
with rollup;

--4. ��������� �������� GROUPING SET �������� ������, ������� ������� 
--������������ ����� ���� �� ���� ������ ������ ������������ � ������� 
--������� � ����� ������� ����.

select b.BookName as '�����', a.AuthorSurName+' '+a.AuthorName as '�����', 
max (b.�irculation) as '�����', b.DateOfPubl as '���� �������'
from [Author]a join [Books]b on a.Id=b.AuthorId
group by grouping sets (b.BookName,a.AuthorSurName+' '+a.AuthorName ,  b.DateOfPubl)


--5. ��������� �������� PIVOT ������� ������� �������, 
--���������� ����������� ���� ������� ���� ���������� ���������� �� ��������� ���.

--������ ��� ���������� �����
select min(b.Price) as '����������� ����', sh.ShopName as '�������'
from [Books]b join [Sales]s on b.Id=s.BooksId 
join [Shop]sh on  sh.SalesId = s.Id
group by sh.ShopName

---������ ��� �����������
select [min], [������], [������� ���� ��������� ������], [������],
 [��������], [������]
 From (select 'Minumum price' as 'min',b.Price, sh.ShopName 
from [Books]b join [Sales]s on b.Id=s.BooksId 
join [Shop]sh on  sh.SalesId = s.Id ) tmp
pivot
(min (Price) for Shopname in ([������], [������� ���� ��������� ������], [������],
 [��������], [������]))pvt;

 --6. ��������� �������� PIVOT, ������� ������������� ������� �������,
  --������� �������� ������ � ���������� ������� ������������� ���� ����
  -- ������� �� ���������� ���� ��������� ���. ������������� ������ �� ���������.
  select x.Year, [4] as '�������',
		 [3]as '�������������� �������',
		 [2]as '������ ����������',
		 [1]as '������� ����������'
  from (
  select JanreName, b.�irculation, year(b.DateOfPubl) as Year
  from [Janre]j join [Books]b on j.Id=b.JanreId
  where year(b.DateOfPubl) between '2017' and '2018'
  )tmp
  pivot	
  (sum(�irculation) for JanreName in ([1],[2],[3],[4])
  ) as x
  order by x.Year;



  