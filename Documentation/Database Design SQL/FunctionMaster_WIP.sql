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

/* Update Card Quantity */
/* CREATE PROCEDURE [MtG].[UpdateCardQuantity] (@AccountID NVARCHAR(450), @CardID VARCHAR(36), @Qty INT)
AS BEGIN
    DECLARE @CompendiumID VARCHAR(450);
    SET @CompendiumID = (
        SELECT CompendiumID
        FROM [User].[Details] AS UD
        WHERE UD.AccountID = @AccountID
    );
    DECLARE @Quantity INT;
    SET @Quantity = (
        SELECT Quantity
        FROM [User].[Collection] AS UC
        WHERE UC.CompendiumID = @CompendiumID
    );
    IF(@Quantity + @Qty <= 0) DELETE FROM [User].[Collection] WHERE CompendiumID = @CompendiumID AND CardID = @CardID;
    ELSE UPDATE [User].[Collection] SET Quantity = Quantity + @Qty WHERE CompendiumID = @CompendiumID AND CardID = @CardID;
END; */

/* Collection Update Trigger */
/* CREATE TRIGGER [User].[trUpdateCollection]
ON [User].[Collection]
INSTEAD OF UPDATE
AS BEGIN
    DECLARE @CompendiumID VARCHAR(450);
    SET @CompendiumID = (SELECT i.CompendiumID FROM INSERTED AS i);
    DECLARE @CardID VARCHAR(141);
    SET @CardID = (SELECT i.CardID FROM INSERTED as i);
    DECLARE @Condition VARCHAR(12);
    SET @Condition = (SELECT i.Condition FROM INSERTED AS i);
    DECLARE @Location VARCHAR(250);
    SET @Location = (SELECT i.StorageLocation FROM INSERTED AS i);
    DECLARE @Qty INT;
    SET @Qty = (SELECT i.Quantity FROM INSERTED AS i);
    DECLARE @CardName VARCHAR(141);
    SET @CardName = (SELECT c.Name FROM [MtG].[Card] AS c WHERE c.ID = @CardID);

    IF(@Qty <= 0) BEGIN
        DELETE FROM [User].[Collection] WHERE CardID = @CardID;
        RETURN;
    END
    ELSE BEGIN
        IF(@Condition NOT IN (SELECT ID FROM [MtG].[AvailableGrades])) SET @Condition = 'UO-UKN';
        IF(@Location IS NULL OR @Location = '') SET @Location = 'Undefined';
    END

    UPDATE [User].[Collection] SET Condition = @Condition, StorageLocation = @Location, Quantity = @Qty
    WHERE CompendiumID = @CompendiumID AND CardID = @CardID;
END; */

/* Compendium Update Trigger */
/* CREATE TRIGGER [User].[trUpdateCompendium]
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
/* CREATE TRIGGER [User].[trInsertCollection]
ON [User].[Collection]
AFTER UPDATE
AS BEGIN
    DECLARE @CompendiumID VARCHAR(450);
    SET @CompendiumID = (SELECT CompendiumID FROM INSERTED);
    DECLARE @CardID VARCHAR(36);
    SET @CardID = (SELECT CardID FROM INSERTED);
    DECLARE @CardName VARCHAR(141);
    SET @CardName = (SELECT Name FROM [MtG].[Card] WHERE ID = @CardID);

    IF(@CardName IN (SELECT CardName FROM [MtG].[Compendium] WHERE ID = @CompendiumID))
        RETURN;
    ELSE
        INSERT INTO [User].[Compendium] VALUES(@CompendiumID, @CardName);
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
RETURNS @T TABLE (VALUE NVARCHAR(MAX))
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
  INSERT @T SELECT SUBSTRING(@List, F, F - f) FROM A OPTION (MAXRECURSION 0);
  RETURN;  
END; */