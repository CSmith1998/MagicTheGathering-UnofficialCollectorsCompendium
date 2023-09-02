/* GET TOP 25 */
/* CREATE FUNCTION [Admin].[Top25Cards]()
RETURNS TABLE
AS
RETURN (
    SELECT TOP 25 C.CardID, C.Count, MC.Name, MC.PNG, MC.SetName, MC.SetIcon, MC.ManaCost, MC.ColorIdentity
    FROM (
        SELECT TOP 25 CardID, Count(CardID) AS 'Count'
        FROM (
            SELECT DISTINCT CardID, CompendiumID
            FROM [User].[Collection]
        ) AS DistinctCards
        GROUP BY CardID
        ORDER BY Count DESC
    ) AS C
    INNER JOIN [MtG].[Card] AS MC ON MC.ID = C.CardID
); */

/* GET USAGE STATS */
/* CREATE FUNCTION [Admin].[GetLoginData]()
RETURNS TABLE
AS
RETURN (
    SELECT TOP 12 DATEPART(HOUR, Time) AS LoginHour, COUNT(*) AS LoginCount
    FROM [User].[Access]
    WHERE AccessType = 'LOGIN'
    GROUP BY DATEPART(HOUR, Time)
    ORDER BY LoginCount DESC
); */

/* Card Quantity for Computed Column */
/* ALTER FUNCTION [MtG].[GetCardTotal] (@CompendiumID VARCHAR(450), @CardName VARCHAR(141))
RETURNS INT AS
BEGIN
    DECLARE @AccountID NVARCHAR(450);
    SET @AccountID = (
        SELECT TOP 1 AccountID
        FROM [User].[Details] AS UD
        WHERE UD.CompendiumID = @CompendiumID
    );

    DECLARE @CardID VARCHAR(36);
    SET @CardID = (
        SELECT TOP 1 ID
        FROM [MtG].[Card] AS C
        WHERE C.Name = @CardName
    );

    DECLARE @Qty INT;
    SET @Qty = (
        SELECT SUM(Quantity) 
        FROM [User].[Collection] AS UC
        WHERE UC.CompendiumID = @CompendiumID
            AND UC.CardID = @CardID
        GROUP BY UC.CompendiumID, UC.CardID -- Use GROUP BY to ensure only one row is returned
    );

    RETURN @Qty;
END; */

/* ALTER FUNCTION [MtG].[CheckCardExists] (@CardID VARCHAR(36))
RETURNS INT AS
BEGIN
    IF(@CardID IN (SELECT ID FROM [MtG].[Card]))
        RETURN 1;
    
    RETURN 0;
END; */

/* Get Color Identity for Computed Column */
/* ALTER FUNCTION [MtG].[GetColorIdentity] (@CardName VARCHAR(141))
RETURNS VARCHAR(10) AS
BEGIN
    DECLARE @ColorIdentity VARCHAR(10);
    SET @ColorIdentity = (
        SELECT TOP 1 ColorIdentity 
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
    IF(@CardID NOT IN (
        SELECT C.ID
        FROM [MtG].[Card] AS C
    )) RETURN;

    IF(@Condition NOT IN (
        SELECT ID
        FROM [MtG].[AvailableGrades]
    )) SET @Condition = 'UO-UKN';

    DECLARE @CardName VARCHAR(141);
    SET @CardName = (SELECT c.Name FROM [MtG].[Card] AS c WHERE c.ID = @CardID);

    IF(@Qty > 0) 
        INSERT INTO [User].[Collection] VALUES(@CompendiumID, @CardID, @CardName, @Condition, @Location, @Qty);
END; */

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

/* CREATE PROCEDURE [User].[UpdateCollection]
    @AccountID NVARCHAR(450), 
    @CardID VARCHAR(36),
    @Condition VARCHAR(12),
    @Location VARCHAR(250),
    @Qty INT
AS 
BEGIN
    DECLARE @CompendiumID VARCHAR(450);
    SELECT @CompendiumID = CompendiumID
    FROM [User].[Details]
    WHERE AccountID = @AccountID;

    DECLARE @OldCondition VARCHAR(12);
    SET @OldCondition = (SELECT Condition FROM [User].[Collection] WHERE CompendiumID = @CompendiumID AND CardID = @CardID);
    DECLARE @OldLocation VARCHAR(250);
    SET @OldLocation = (SELECT StorageLocation FROM [User].[Collection] WHERE CompendiumID = @CompendiumID AND CardID = @CardID);

    UPDATE [User].[Collection] SET Condition = @Condition, StorageLocation = @Location, Quantity = @Qty
    WHERE CompendiumID = @CompendiumID AND CardID = @CardID AND Condition = @OldCondition AND StorageLocation = @OldLocation;
END; */

/* Collection Update Trigger */
/* ALTER TRIGGER [User].[trUpdateCollection]
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

    DECLARE @OldCondition VARCHAR(12);
    SET @OldCondition = (SELECT Condition FROM [User].[Collection] WHERE CompendiumID = @CompendiumID AND CardID = @CardID);
    DECLARE @OldLocation VARCHAR(250);
    SET @OldLocation = (SELECT StorageLocation FROM [User].[Collection] WHERE CompendiumID = @CompendiumID AND CardID = @CardID);


    IF(@CardID NOT IN (
        SELECT C.ID
        FROM [MtG].[Card] AS C
    )) RETURN;

    DECLARE @CardName VARCHAR(141);
    SET @CardName = (SELECT c.Name FROM [MtG].[Card] AS c WHERE c.ID = @CardID);

    IF(@Qty <= 0) 
    BEGIN
        DELETE FROM [User].[Collection] WHERE CardID = @CardID;
        RETURN;
    END
    ELSE BEGIN
        IF(@Condition NOT IN (SELECT ID FROM [MtG].[AvailableGrades])) SET @Condition = 'UO-UKN';
        IF(@Location IS NULL OR @Location = '') SET @Location = 'Undefined';
    END

    UPDATE [User].[Collection] SET CardName = @CardName, Condition = @Condition, StorageLocation = @Location, Quantity = @Qty
    WHERE CompendiumID = @CompendiumID AND CardID = @CardID AND Condition = @OldCondition AND StorageLocation = @OldLocation;
END; */

/* CREATE TRIGGER [User].[trRecordDeleted]
ON [User].[Collection]
AFTER DELETE
AS BEGIN
    DECLARE @CompendiumID VARCHAR(450);
    SET @CompendiumID = (SELECT CompendiumID FROM DELETED);
    DECLARE @CardID VARCHAR(36);
    SET @CardID = (SELECT CardID FROM DELETED);
    DECLARE @CardName VARCHAR(141);
    SET @CardName = (
        SELECT Name FROM [MtG].[Card]
        WHERE Name = @CardName
    );

    DECLARE @RemainingQty INT;
    SET @RemainingQty = (
        SELECT TotalQty
        FROM [User].[Compendium]
        WHERE ID = @CompendiumID
        AND CardName = @CardName
    );

    IF(@RemainingQty <= 0) 
        DELETE FROM [User].[Compendium] WHERE ID = @CompendiumID AND CardName = @CardName;
END; */

/* Compendium Update Trigger */
/* CREATE TRIGGER [User].[trUpdateCompendium]
ON [User].[Compendium]
AFTER UPDATE
AS 
BEGIN
    SET NOCOUNT ON;

    DECLARE @CompendiumID VARCHAR(450);
    DECLARE @CardName VARCHAR(141);
    DECLARE @Qty INT;

    -- Use a cursor to loop through the rows in the INSERTED table
    DECLARE cursorCompendium CURSOR FOR
    SELECT ID, CardName, TotalQty
    FROM INSERTED;

    OPEN cursorCompendium;
    FETCH NEXT FROM cursorCompendium INTO @CompendiumID, @CardName, @Qty;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF(@Qty > 0)
        BEGIN
            RETURN;
        END
        ELSE
        BEGIN
            -- Delete rows from [User].[Compendium] based on ID and CardName
            DELETE FROM [User].[Compendium] WHERE ID = @CompendiumID AND CardName = @CardName;
        END

        FETCH NEXT FROM cursorCompendium INTO @CompendiumID, @CardName, @Qty;
    END

    CLOSE cursorCompendium;
    DEALLOCATE cursorCompendium;
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

/*
CREATE FUNCTION [Admin].[GetUsersWithRoles]()
RETURNS TABLE
AS
RETURN (
    SELECT u.Id AS UserId, u.UserName, r.Id AS RoleId, r.Name AS RoleName
    FROM [Admin].[AspNetUsers] u
    INNER JOIN [Admin].[AspNetUserRoles] ur ON u.Id = ur.UserId
    INNER JOIN [Admin].[AspNetRoles] r ON ur.RoleId = r.Id
);
/*

/*
CREATE PROCEDURE [Admin].[DeleteUser]
    @UserId NVARCHAR(450)
AS
BEGIN
    DELETE FROM [Admin].[AspNetUsers]
    WHERE Id = @UserId
END;
*/

/*
CREATE PROCEDURE [Admin].[ChangeUserRole]
    @UserId NVARCHAR(450),
    @RoleId NVARCHAR(450)
AS
BEGIN

    UPDATE [Admin].[AspNetUserRoles]
    SET RoleId = @RoleId
    WHERE UserId = @UserId;

END;
*/

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
/* ALTER TRIGGER [Admin].[trValidateRole]
ON [Admin].[AspNetUsers]
AFTER UPDATE
AS BEGIN
    DECLARE @Old BIT;
    SET @Old = (SELECT EmailConfirmed FROM DELETED);
    DECLARE @New BIT;
    SET @New = (SELECT EmailConfirmed FROM INSERTED);

    DECLARE @Id NVARCHAR(450);
    SET @Id = (SELECT Id FROM INSERTED);

    IF(@Old = 0 AND @New = 1)
        INSERT INTO [Admin].[AspNetUserRoles] VALUES(@Id, '003');
END; */

/* New Card */
/* CREATE PROCEDURE [MtG].[NewCard] 
    @CardID VARCHAR(36), 
    @CardName VARCHAR(141), 
    @PNG VARCHAR(450), 
    @SetName VARCHAR(250), 
    @SetIcon VARCHAR(450), 
    @ManaCost VARCHAR(150), 
    @ColorIdentity VARCHAR(10)
AS
BEGIN
    IF(@CardID NOT IN (
        SELECT ID
        FROM [MtG].[Card]
    ) AND @ColorIdentity IN (
        SELECT IdentityName
        FROM [MtG].[AvailableIdentities]
    )) INSERT INTO [MtG].[Card] VALUES(@CardID, @CardName, @PNG, @SetName, @SetIcon, @ManaCost, @ColorIdentity)
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

/* CREATE FUNCTION [Admin].[AdminValidation] (@Username NVARCHAR(256), @Password NVARCHAR(MAX), @AccountID NVARCHAR(450))
RETURNS INT AS
BEGIN
    DECLARE @BasicAuth INT;
    SET @BasicAuth = (SELECT [Admin].[UserValidation](@Username, @Password));

    IF (@BasicAuth = 1)
    BEGIN
        IF (@Username IN (
                SELECT UserName
                FROM [Admin].[AspNetUsers]
                WHERE Id = @AccountID
            ) AND @AccountID IN (
                SELECT UserId
                FROM [Admin].[AspNetUserRoles]
                WHERE RoleId = '000' OR RoleID = '001'
            ))
            RETURN 1;
    END

    RETURN 0;
END; */

/* CREATE PROCEDURE [Admin].[UserRoleChange](@AccountID NVARCHAR(450), @RoleID NVARCHAR(450))
AS BEGIN
    IF(@RoleID IN (
        SELECT Id
        FROM [Admin].[AspNetRoles]
    ) AND @RoleID != '000' AND @AccountID IN (
        SELECT Id
        FROM [Admin].[AspNetUsers]
    )) 
    BEGIN
        UPDATE [Admin].[AspNetUserRoles] SET RoleId = @RoleID WHERE UserId = @AccountID;
    END
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