/* Card Quantity for Computed Column */
/* CREATE FUNCTION [MtG].[GetCardTotal] (@CompendiumID VARCHAR(450), @CardName VARCHAR(141))
RETURNS INT AS
BEGIN
    DECLARE @AccountID NVARCHAR(450);
    SET @AccountID = (
        SELECT AccountID
        FROM [User].[Details] AS UD
        WHERE UD.CompendiumID = @CompendiumID
    );
    DECLARE @CardID VARCHAR(36);
    SET @CardID = (
        SELECT ID
        FROM [MtG].[Card] AS C
        WHERE C.Name = @CardName
    );
    DECLARE @Qty INT;
    SET @Qty = (
        SELECT SUM(Quantity) 
        FROM [User].[Collection] AS UC
        WHERE UC.CompendiumID = @CompendiumID
            AND UC.CardID = @CardID
    );
    RETURN @Qty;
END; */

/* Get Color Identity for Computed Column */
/* CREATE FUNCTION [MtG].[GetColorIdentity] (@CardName VARCHAR(141))
RETURNS VARCHAR(10) AS
BEGIN
    DECLARE @ColorIdentity VARCHAR(10);
    SET @ColorIdentity = (
        SELECT ColorIdentity 
        FROM [MtG].[Card] AS C
        WHERE C.Name = @CardName
    );
    RETURN @ColorIdentity
END; */

/* CREATE FUNCTION [MtG].[GetManaCost] (@CardName VARCHAR(141))
RETURNS VARCHAR(150) AS
BEGIN
    DECLARE @Cost VARCHAR(150);
    SET @Cost = (
        SELECT TOP 1 ManaCost 
        FROM [MtG].[Card] AS C
        WHERE C.Name = @CardName
        ORDER BY ManaCost
    );
    RETURN @Cost;
END; */

/* CREATE FUNCTION [MtG].[GetCardName](@CardID VARCHAR(36))
RETURNS VARCHAR(141) AS
BEGIN
    DECLARE @CardName VARCHAR(141);
    SET @CardName = (
        SELECT C.Name
        FROM [MtG].[Card] AS C
        WHERE C.ID = @CardID
    );
    RETURN @CardName
END; */

/* CREATE FUNCTION [MtG].[GetSetName] (@CardID VARCHAR(36))
RETURNS VARCHAR(250) AS
BEGIN
    DECLARE @SetName VARCHAR(250);
    SET @SetName = (
        SELECT C.SetName 
        FROM [MtG].[Card] AS C
        WHERE C.ID = @CardID
    );
    RETURN @SetName
END; */

/* CREATE FUNCTION [MtG].[GetSetIcon] (@ID VARCHAR(36))
RETURNS VARCHAR(450) AS
BEGIN
    DECLARE @Icon VARCHAR(450);
    SET @Icon = (
        SELECT SetIcon 
        FROM [MtG].[Card] AS C
        WHERE C.ID = @ID
    );
    RETURN @Icon
END; */

/* CREATE FUNCTION [MtG].[GetCardFace] (@ID VARCHAR(36))
RETURNS VARCHAR(450) AS
BEGIN
    DECLARE @CardFace VARCHAR(450);
    SET @CardFace = (
        SELECT PNG 
        FROM [MtG].[Card] AS C
        WHERE C.ID = @ID
    );
    RETURN @CardFace
END; */

/* Get User Collection */
/* ALTER FUNCTION [User].[GetCardCollection] (
    @CompendiumID VARCHAR(450),
    @CardName VARCHAR(141) = NULL
)
RETURNS TABLE AS
RETURN
(
    SELECT UC.*, AG.Type, AG.Name, AG.Description
    FROM [User].[Collection] AS UC
    INNER JOIN [MtG].[AvailableGrades] AS AG 
        ON UC.Condition = AG.ID
    WHERE UC.CompendiumID = @CompendiumID
    AND UC.CardName = @CardName
); */

/* Get User Collection */
/* ALTER FUNCTION [User].[GetFullCollection] (
    @CompendiumID VARCHAR(450)
)
RETURNS TABLE AS
RETURN
(
    SELECT UC.*, AG.Type, AG.Name, AG.Description
    FROM [User].[Collection] AS UC
    INNER JOIN [MtG].[AvailableGrades] AS AG 
        ON UC.Condition = AG.ID
    WHERE UC.CompendiumID = @CompendiumID
); */

/* Get Username */
/* CREATE FUNCTION [User].[GetUsername] (
    @AccountID NVARCHAR(450))
RETURNS NVARCHAR(256) AS
BEGIN
    DECLARE @UserName NVARCHAR(256);
    SET @UserName = (
        SELECT UserName
        FROM [Admin].[AspNetUsers] AS ANU
        WHERE ANU.Id = @AccountID
    );
    RETURN @AccountID; 
END; */

/* ALTER PROCEDURE [User].[InsertIntoCollection]
    @CompendiumID VARCHAR(450),
    @CardID VARCHAR(36),
    @Condition VARCHAR(12),
    @Location VARCHAR(250),
    @Qty INT
AS
BEGIN
    DECLARE @CardName VARCHAR(141);
    SET @CardName = (SELECT c.Name FROM [MtG].[Card] AS c WHERE c.ID = @CardID);

    IF(@CardName NOT IN (
        SELECT C.Name
        FROM [MtG].[Card] AS C
    )) RETURN;

    IF(@Qty > 0) 
        INSERT INTO [User].[Collection] VALUES(@CompendiumID, @CardID, @CardName, @Condition, @Location, @Qty);
END; */

/* CREATE PROCEDURE [User].[InsertIntoCompendium]


/* Update Card Quantity */
/* CREATE PROCEDURE [MtG].[UpdateCardQuantity] 
    @AccountID NVARCHAR(450), 
    @CardID VARCHAR(36),
    @Condition VARCHAR(12),
    @Location VARCHAR(250),
    @Qty INT
AS 
BEGIN
    SET NOCOUNT ON;

    DECLARE @CompendiumID VARCHAR(450);
    DECLARE @Quantity INT;
    DECLARE @CardName VARCHAR(141);
    DECLARE @TotalQty INT;

    SELECT @CompendiumID = CompendiumID
    FROM [User].[Details]
    WHERE AccountID = @AccountID;

    SELECT @Quantity = Quantity
    FROM [User].[Collection]
    WHERE CompendiumID = @CompendiumID AND CardID = @CardID;

    SELECT @CardName = Name
    FROM [MtG].[Card]
    WHERE ID = @CardID;

    IF (@Quantity + @Qty <= 0)
    BEGIN
        DELETE FROM [User].[Collection]
        WHERE CompendiumID = @CompendiumID AND CardID = @CardID AND Condition = @Condition AND StorageLocation = @Location;

        IF ((SELECT ISNULL(TotalQty, 0) FROM [User].[Compendium] WHERE ID = @CompendiumID AND CardName = @CardName) <= 0)
        BEGIN
            DELETE FROM [User].[Compendium] 
            WHERE ID = @CompendiumID AND CardName = @CardName;
        END
    END
    ELSE
    BEGIN
        UPDATE [User].[Collection] 
        SET Quantity = Quantity + @Qty 
        WHERE CompendiumID = @CompendiumID AND CardID = @CardID AND Condition = @Condition AND StorageLocation = @Location;
    END
END; */

/* Collection Update Trigger */
/* CREATE TRIGGER [User].[trUpdateCollection]
ON [User].[Collection]
INSTEAD OF UPDATE
AS BEGIN
    DECLARE @CompendiumID VARCHAR(450);
    SET @CompendiumID = (SELECT i.CompendiumID FROM INSERTED AS i);
    DECLARE @CardID VARCHAR(36);
    SET @CardID = (SELECT i.CardID FROM INSERTED as i);
    DECLARE @Condition VARCHAR(12);
    SET @Condition = (SELECT i.Condition FROM INSERTED AS i);
    DECLARE @Location VARCHAR(250);
    SET @Location = (SELECT i.StorageLocation FROM INSERTED AS i);
    DECLARE @Qty INT;
    SET @Qty = (SELECT i.Quantity FROM INSERTED AS i);
    DECLARE @CardName VARCHAR(141);
    SET @CardName = (SELECT c.Name FROM [MtG].[Card] AS c WHERE c.ID = @CardID);

    IF(@CardName NOT IN (
        SELECT C.Name
        FROM [MtG].[Card] AS C
    )) RETURN;

    IF(@Qty <= 0) BEGIN
        DELETE FROM [User].[Collection] WHERE CardID = @CardID;
        RETURN;
    END
    ELSE BEGIN
        IF(@Condition NOT IN (SELECT ID FROM [MtG].[AvailableGrades])) SET @Condition = 'UO-UKN';
        IF(@Location IS NULL OR @Location = '') SET @Location = 'Undefined';
    END

    UPDATE [User].[Collection] SET CardName = @CardName, Condition = @Condition, StorageLocation = @Location, Quantity = @Qty
    WHERE CompendiumID = @CompendiumID AND CardID = @CardID AND Condition = @Condition AND StorageLocation = @Location;
END; */

/* Compendium Update Trigger */
/* ALTER TRIGGER [User].[trUpdateCompendium]
ON [User].[Compendium]
AFTER UPDATE
AS BEGIN
    DECLARE @CompendiumID VARCHAR(450);
    SET @CompendiumID = (SELECT ID FROM INSERTED);
    DECLARE @CardName VARCHAR(141);
    SET @CardName = (SELECT CardName FROM INSERTED);
    DECLARE @Qty INT;
    SET @Qty = (SELECT TotalQty FROM INSERTED);

    IF(@Qty > 0) RETURN;
    ELSE DELETE FROM [User].[Compendium] WHERE ID = @CompendiumID AND CardName = @CardName;
END; */

/* Generic Sequence */
/* CREATE SEQUENCE [Admin].[sqCounter] AS INT START WITH 0 INCREMENT BY 1 NO CYCLE NO CACHE; */

/* New Access */
/* CREATE PROCEDURE [Admin].[NewAccess] (@AccountID NVARCHAR(450), @AccessType VARCHAR(256), @IP VARCHAR(36))
AS BEGIN
    DECLARE @AccessID VARCHAR(45);
    SET @AccessID = (
        SELECT AccessID
        FROM [User].[Details] AS UD
        WHERE UD.AccountID = @AccountID
    );
    DECLARE @CurrentTime DATETIME;
    SET @CurrentTime = GETDATE();

    INSERT INTO [User].[Access] VALUES(@AccessID, @AccessType, @IP, @CurrentTime);
END; */

/* New User */
/* CREATE TRIGGER [Admin].[trNewUser]
ON [Admin].[AspNetUsers]
AFTER INSERT
AS BEGIN
    DECLARE @AccountID NVARCHAR(450);
    SET @AccountID = (SELECT i.Id FROM INSERTED as i);
    DECLARE @CompendiumID VARCHAR(450);
    SET @CompendiumID = CONCAT('UC', LEFT(@AccountID, 4), '-', RIGHT(@AccountID, 4), '_', NEXT VALUE FOR [Admin].[sqCounter]);
    DECLARE @AccessID VARCHAR(45);
    SET @AccessID = CONCAT('UA', LEFT(@AccountID, 4), RIGHT(@AccountID, 4), 'f');

    INSERT INTO [User].[Details] VALUES(@AccountID, @CompendiumID, @AccessID);
END;  */

/* User Validated */
/* CREATE TRIGGER [Admin].[trValidateRole]
ON [Admin].[AspNetUsers]
AFTER UPDATE
AS BEGIN
    DECLARE @Old BIT;
    SET @Old = (SELECT EmailConfirmed FROM DELETED);
    DECLARE @New BIT;
    SET @New = (SELECT EmailConfirmed FROM INSERTED);

    IF(@Old = 0 AND @New = 1)
        INSERT INTO [Admin].[AspNetUserRoles] VALUES((SELECT Id FROM INSERTED), '003');
END; */

/* New Card */
/* CREATE PROCEDURE [MtG].[NewCard] (@CardID VARCHAR(141), @CardJSON NVARCHAR(MAX))
AS BEGIN
    IF(@CardID IN (SELECT ID FROM [MtG].[Card])) RETURN;

    DECLARE TABLE 

    INSERT INTO [MtG].[Card] VALUES(@CardID, Name, ReleasedAt, Layout, ConvertedManaCost, ColorIdentity, TypeLine, Reserved, Foil, Nonfoil, Oversized, Promo, Reprint, SetID, RulingsURL, Rarity, Artist, FullArt, Textless) SELECT * FROM OPENJSON(@CardJSON);

    INSERT INTO [MtG].[Card] VALUES(@CardID, (SELECT Name FROM OPENJSON(@CardJSON)));   
    
END; */

/* Get User's CompendiumID */
/* CREATE FUNCTION [User].[GetCompendiumID] (@AccountID NVARCHAR(450))
RETURNS VARCHAR(450) AS 
BEGIN
    DECLARE @CompendiumID VARCHAR(450);
    SET @CompendiumID = (SELECT UD.CompendiumID FROM [User].[Details] AS UD WHERE UD.AccountID = @AccountID);

    RETURN @CompendiumID;
END; */

/* Check Authorization */
/* CREATE FUNCTION [Admin].[UserValidation] (@Username NVARCHAR(256), @Password NVARCHAR(MAX))
RETURNS INT AS
BEGIN
    DECLARE @PasswordHash NVARCHAR(MAX);
    SET @PasswordHash = (SELECT PasswordHash FROM [Admin].[AspNetUsers] WHERE UserName = @Username);
    IF(@Password != @PasswordHash)
        RETURN 0;
    
    RETURN 1;
END; */

/* Inserted into Collection */
/* ALTER TRIGGER [User].[trInsertCollection]
ON [User].[Collection]
AFTER INSERT
AS BEGIN
    DECLARE @CompendiumID VARCHAR(450);
    SET @CompendiumID = (SELECT CompendiumID FROM INSERTED);
    DECLARE @CardID VARCHAR(36);
    SET @CardID = (SELECT CardID FROM INSERTED);
    DECLARE @Condition VARCHAR(12);
    DECLARE @CardName VARCHAR(141);
    SET @CardName = (SELECT c.Name FROM [MtG].[Card] AS c WHERE c.ID = @CardID);
    SET @Condition = (SELECT Condition FROM INSERTED);
    DECLARE @Location VARCHAR(250);
    SET @Location = (SELECT StorageLocation FROM INSERTED);
    DECLARE @Qty INT;
    SET @Qty = (SELECT Quantity FROM INSERTED);
    DECLARE @ColorIdentity VARCHAR(10);
    SET @ColorIdentity = (SELECT ColorIdentity FROM [MtG].[Card] AS C WHERE C.ID = @CardID);

    IF EXISTS (
        SELECT 1 
        FROM [User].[Compendium] 
        WHERE ID = @CompendiumID 
          AND CardName = @CardName
    ) RETURN;
    
    ELSE INSERT INTO [User].[Compendium] VALUES(@CompendiumID, @CardName);
END; */

/* String Aggregation */
/* CREATE FUNCTION [dbo].[fn_DistinctList]
(
  @String NVARCHAR(MAX),
  @Delimiter NVARCHAR(4)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @Finisher NVARCHAR(5);
  IF(@Delimiter = '//')
    SET @Finisher = (' ' + @Delimiter + ' ');
  ELSE
    SET @Finisher = (@Delimiter + ' ');
  DECLARE @Result NVARCHAR(MAX);
  WITH MY_CTE AS ( SELECT Distinct(value) FROM [dbo].[SimpleSplitFunction](@String, 
@Delimiter)  )
  SELECT @Result = STRING_AGG(value, @Finisher) FROM MY_CTE
  RETURN @Result
END; */

/* Simple Split */
/* CREATE FUNCTION [dbo].[SimpleSplitFunction]
(
  @List      NVARCHAR(MAX),
  @Delimiter NVARCHAR(4)
)
RETURNS @T TABLE (value NVARCHAR(MAX))
AS
BEGIN
  DECLARE @Seek INT;
  IF(@Delimiter = '//')
    SET @Seek = 2;
  ELSE
    SET @Seek = 1;
  WITH A(F,T) AS  
  (
    SELECT CAST(1 AS BIGINT), CHARINDEX(@Delimiter, @List)
    UNION ALL
    SELECT T + @Seek, CHARINDEX(@Delimiter, @List, T + 1) 
    FROM A WHERE CHARINDEX(@Delimiter, @List, T + 1) > 0
  )  
  INSERT @T SELECT SUBSTRING(@List, F, F - F) FROM A OPTION (MAXRECURSION 0);
  RETURN;  
END; */