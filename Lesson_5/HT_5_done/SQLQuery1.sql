/* 1. Create a view to display country names with corresponding shop names. */
CREATE VIEW View_5_1 (Country, ShopName) AS
SELECT 
    CASE c.CountryName
        WHEN 'Óêðàèíà' THEN 'Ukraine - UA'
        WHEN 'Ãðóçèÿ' THEN 'Georgia - GR'
        WHEN 'Ðîññèÿ' THEN 'Russia - RU'
        WHEN 'Áåëàðóñü' THEN 'Belarus - BE'
        WHEN 'Êàçàõñòàí' THEN 'Kazakhstan - KZ'
        ELSE 'Unknown Country' -- Fallback for any unmatched cases
    END AS Country,
    sh.ShopName
FROM 
    [Shop] sh 
JOIN 
    [Country] c ON sh.CountryId = c.Id;
GO

SELECT * FROM View_5_1;
GO

/* 2. Update the circulation of books based on their publication year. */
DECLARE @value INT;

SELECT @value = CASE 
    WHEN YEAR(b.DateOfPubl) > 2017 THEN 1000 
    ELSE 100 
END
FROM [Books] b;

UPDATE [Books]
SET Circulation = Circulation + @value;
GO

SELECT b.BookName, b.DateOfPubl, b.Circulation
FROM [Books] b;
GO

/* 3. Create a Common Table Expression (CTE) to summarize sales. */
WITH Virtual(ShopName, SaleCount, DateOfSal) AS (
    SELECT 
        sh.ShopName, 
        SUM(s.SaleCount) AS SaleCount,
        MAX(s.DateOfSal) AS DateOfSal
    FROM 
        [Shop] sh 
    JOIN 
        [Sales] s ON s.Id = sh.SalesId
    GROUP BY 
        sh.ShopName 
)
SELECT * FROM Virtual;
GO

/* 4. Create a stored procedure to list shops with sales greater than 0. */
CREATE PROCEDURE Less5_task_4 AS
BEGIN
    SELECT 
        sh.ShopName, 
        s.SaleCount, 
        c.CountryName
    FROM 
        [Sales] s 
    JOIN 
        [Shop] sh ON s.Id = sh.SalesId
    JOIN 
        [Country] c ON sh.CountryId = c.Id
    WHERE 
        s.SaleCount > 0;
END;
GO

EXEC Less5_task_4;
GO

/* 5. Create a stored procedure to find books by a specific author. */
CREATE PROCEDURE Less5_task_5_1  
    @authorName NVARCHAR(100), 
    @authorSurName NVARCHAR(100)
AS
BEGIN
    SELECT 
        CONCAT(a.AuthorSurName, ' ', a.AuthorName) AS Author, 
        b.BookName AS Book
    FROM 
        [Author] a 
    JOIN 
        [Books] b ON a.Id = b.AuthorId
    WHERE 
        a.AuthorName = @authorName 
        AND a.AuthorSurName = @authorSurName;
END;
GO

DECLARE @authorName NVARCHAR(100) = 'Âëàäèìèð';
DECLARE @authorSurName NVARCHAR(100) = 'Ïîñåëÿãèí';

EXEC Less5_task_5_1 @authorName, @authorSurName;
GO

/* 6. Create a stored procedure to find the maximum of two integers. */
CREATE PROCEDURE MaxAB
    @a INT,
    @b INT
AS
BEGIN
    DECLARE @max INT = @a;
    IF @b > @max 
        SET @max = @b;

    RETURN @max; -- Return the maximum value
END;
GO

DECLARE @res INT;
EXEC @res = MaxAB 5, 25;
SELECT 'Max from 5 and 25 is ', @res;
GO

/* 7. Create a view for books sorted by genre and price. */
CREATE VIEW View_7 (JanreName, BookName, Price) AS
SELECT 
    j.JanreName, 
    b.BookName, 
    b.Price
FROM 
    [Books] b 
JOIN 
    [Janre] j ON b.JanreId = j.Id;
GO

/*  Create a procedure to fetch books by genre with sorting option. */
CREATE PROCEDURE BooksByJanre 
    @janreName NVARCHAR(100),
    @sort INT
AS
BEGIN
    IF @sort = 0
        SELECT * FROM View_7 
        WHERE JanreName = @janreName
        ORDER BY Price ASC;
    ELSE IF @sort = 1
        SELECT * FROM View_7 
        WHERE JanreName = @janreName
        ORDER BY Price DESC;
    ELSE
        SELECT * FROM View_7 
        WHERE JanreName = @janreName; 
END;
GO

EXEC BooksByJanre 'Ôýíòåçè', 2;
GO

/* 8. Create a procedure to find the author with the highest circulation. */
CREATE PROCEDURE MaxResAuthor AS
BEGIN
    SELECT TOP 1 
        CONCAT(a.AuthorSurName, ' ', a.AuthorName, ' ', a.AuthorSecName) AS Author
    FROM 
        [Books] b 
    JOIN 
        [Author] a ON b.AuthorId = a.Id
    GROUP BY 
        CONCAT(a.AuthorSurName, ' ', a.AuthorName, ' ', a.AuthorSecName)
    ORDER BY 
        MAX(b.Circulation) DESC;
END;
GO

EXEC MaxResAuthor;
GO

/* 9. Create a procedure to calculate the factorial of a number. */
CREATE PROCEDURE Factorial
    @a INT
AS
BEGIN
    DECLARE @p INT = 1;
    DECLARE @i INT = 1;

    WHILE @i <= @a
    BEGIN
        SET @p *= @i;
        SET @i += 1;
    END
    RETURN @p; -- Return the factorial value
END;
GO

DECLARE @res INT;
EXEC @res = Factorial 3;
SELECT '3! is ', @res;
GO

/* 10. Create a procedure to update publication dates of books. */
SELECT * 
INTO #TMP_10
FROM [Books];
GO

CREATE PROCEDURE UpdateTMP_10
    @tamplatBookName NVARCHAR(100)
AS
BEGIN
    UPDATE #TMP_10
    SET DateOfPubl = DATEADD(YEAR, 2, DateOfPubl)  
    WHERE BookName LIKE @tamplatBookName + '%';
END;
GO

EXEC UpdateTMP_10 'ß';
GO

SELECT 
    tmp.BookName, 
    tmp.DateOfPubl AS 'Date'
FROM 
    #TMP_10 tmp
ORDER BY 
    tmp.Date;
GO

/* 11. Create a procedure to update circulation and prices for books published within a date range. */
SELECT * 
INTO #TMP_11
FROM [Books];
GO

CREATE PROCEDURE UpdateTMP_11
    @min DATE,
    @max DATE
AS
BEGIN
    UPDATE #TMP_11
    SET 
        Circulation = Circulation * 2, 
        Price = Price * 1.2
    WHERE 
        DateOfPubl BETWEEN @min AND @max;
END;
GO

EXEC UpdateTMP_11 '2016-02-15', '2018-03-16';
GO

SELECT 
    tmp.BookName, 
    tmp.DateOfPubl, 
    tmp.Price, 
    tmp.Circulation
FROM 
    #TMP_11 tmp
ORDER BY 
    tmp.DateOfPubl;
GO
