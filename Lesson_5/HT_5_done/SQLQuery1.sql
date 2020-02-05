/*1. �������� �������������, � ������� ����������
������� �������� ��������� � ��������� �� �����
������������. ��� ���� �������� ������ �������
������� �� ���������� ����� � � ����������� ����
(��������, United States � US).*/
create view View_5_1  (Country,ShopName)
as
select 'Country' = case c.CountryName
	when '�������' then 'Ukraine -UA'
	when '������' then 'Georgia - GR'
	when '������' then 'Russia - RU'
	when '��������' then 'Belarus - BE'	
	when '���������' then 'Kazakhstan - KZ'	
	end,
	sh.ShopName
from [Shop]sh join [Country] c on sh.CountryId=c.Id
go

select * from  view_5_1
group by Country,ShopName
go



/*2. �������� ������, ������� �������� ������ � �����-
�� Books ��������� �������: ���� ����� ���� ��-
���� ����� 2008 ����, ����� �� ����� ��������� ��
1000 ����������, ����� ����� ��������� �� 100 ��.
����������! ��������������� ����������� CASE.*/



declare @value int;
select  @value = case
	when YEAR(b.DateOfPubl)>2017 then 1000
	when YEAR(b.DateOfPubl)<=2017 then 100								
	end
from [Books]b
update books
set �irculation = �irculation+@value
go


select b.BookName, b.DateOfPubl,b.�irculation
from [Books]b
go


/*3. �������� ����������� �������������, ������� ������� ����� ���������� ������ �
 ���� ��������� ���������� ��� ������� ��������.*/


 WITH Virtual(ShopName, SaleCount, DateOfSal) AS
 (select sh.ShopName, sum(s.SaleCount),max (s.DateOfSal)
 from [Shop] sh join [Sales]s on s.Id=sh.SalesId
 Group by sh.ShopName 
 )
 select *
 from Virtual
 go

 /*
 4. ������� �������� ���������, ������� ������� �� ����� ������ ���������, ������� ������� 
 ���� �� ���� ����� ������ ������������. ������� ����� ����������������� (������) ��������. 
 */

 create procedure Less5_task_4
as
 select sh.ShopName, s.SaleCount, c.CountryName
 From [Sales]s join [Shop]sh on s.Id=sh.SalesId
 join [Country] c on sh.CountryId=c.Id
 where s.SaleCount>0
 go

 exec Less5_task_4
 go

 /*5. �������� ���������, ����������� ����������� ��� ����� ������������� ������,
  ��� ���� ��� ��� ���������� ��� ������ */
  
  create procedure Less5_task_5_1  
  @authorName nvarchar(100) , 
  @authorSurName nvarchar(100)
as
select a.AuthorSurName+ ' ' + a.AuthorName as 'Author', b.BookName as 'Book'
from [Author] a join [Books] b on a.Id=b.AuthorId
where a.AuthorName=@authorName and a.AuthorSurName=@authorSurName
go

declare @authorName nvarchar(100) ,   @authorSurName nvarchar(100)
set @authorName = '��������'
set  @authorSurName = '���������'

exec Less5_task_5_1 @authorName, @authorSurName
go

/*6. ������� �������� ���������, ������� ���������� ������������ �� ���� �����.*/
create proc maxAB
@a int,
@b int
as
declare @max int
set @max=@a
if @max<@b 
	set @max=@b
return @max
go

declare @res int
exec @res=maxAB 5,25
select 'max from 5 and 25 is ', @res
go

/*7. �������� ���������, ������� ������� �� ����� ����� � ���� �� ��������� ��������. 
��� ���� ���������� ��������� ����������� ����������: 0 � �� ����, �� �����, 
1 � �� ��������, ����� ������ � ��� ����������.*/

create view View_7  (JanreName,BookName, Price)
as
select j.JanreName, b.BookName, b.Price
from [Books] b join [Janre] j on b.JanreId=j.Id
go

create proc BooksByJanre 
@janreName nvarchar(100) ,
@sort int
as
if @sort=0
	begin
	 select * from view_7 
	 where JanreName=@janreName
	 order by Price
	end
else
	if @sort=1
		begin
			select * from view_7 
			where JanreName=@janreName
			order by Price desc
		end
	else
		begin
			select * from view_7 
			where JanreName=@janreName			
		end
go
		
exec BooksByJanre '�������',2
go 

/*8. �������� ���������, ������� ���������� ������ ��� 
������, ���� �������� ������ ���� ���� ������. */

create proc MaxResAuthor
as
select tmp.Author
from (select top 1 a.AuthorSurName+' '+a.AuthorName+' '+a.AuthorSecName as 'Author', max(b.�irculation) as 'Circulation'
from [Books] b join [Author]a on b.AuthorId=a.Id
group by  a.AuthorSurName+' '+a.AuthorName+' '+a.AuthorSecName
order by 2 desc) as tmp
go

exec  MaxResAuthor
go

/*9. �������� ��������� ��� ������� ���������� �����. */


create proc Factorial
@a int
as
declare @p int, @i int
set @p=1
set @i=1
while @i<=@a
	begin
		set @p*=@i;
		set @i+=1;
	end
return @p
go


declare @res int
exec @res=Factorial 3
select '3! is ', @res
go

/*10.�������� �������� ���������, ������� ��������� ��������� ���� ������������ ������ �����, 
������� ������������� ������� �� 2 ����. ������ ���������� � �������� ��������� � ���������.*/

Select * 
into #TMP_10
from [Books]
go


create proc UpdateTMP_10
@tamplatBookName nvarchar(100)

as
UPDATE [#TMP_10]
SET DateOfPubl=DATEADD(year, 2, DateOfPubl)  
WHERE BookName LIKE @tamplatBookName+'%'
go

exec UpdateTMP_10 '�'
go


select tmp.BookName, tmp.DateOfPubl  as 'Date'
from [#tmp_10] tmp
order by 2
go






/*11.�������� �������� ��������� � �����������, ������������� �������� ��� ������� ����. 
��������� ��������� �������� ������ � ������ ������� ����
�� ��������� ��������: 
� ���� ���� ������� ����� ��������� � ������������ ���������, ����� ����� ����� ��������� 
	� ��� ����, � ���� �� ������� ��������� �� 20%;
� ���� ���� ������� ����� �� ������ � ��������, ����� ����� �������� ��� ���������.

������������� ����� �� ����� ��������������� ��������� �� ������, ���� ������������ ���� ����������, ��� 
�������� ���� ���������� ������ ������, ��� �� ��������� ������ ������� ����.
*/
Select * 
into #TMP_11
from [Books]
go


create proc UpdateTMP_11
@min date,
@max date
as
UPDATE [#TMP_11]
SET �irculation =�irculation  * 2, Price=Price*1.2
WHERE DateOfPubl between @min and @max
go

exec UpdateTMP_11 '2016-02-15','2018-03-16'
go

select tmp.BookName, tmp.DateOfPubl, tmp.Price, tmp.�irculation
from [#tmp_11] tmp
order by 2
go
