SELECT * FROM [User].[Details];
SELECT * FROM [User].[Collection];
SELECT * FROM [User].[Compendium];
SELECT * FROM [MtG].[Card];
SELECT * FROM [Admin].[AspNetUsers];
SELECT * FROM [Admin].[AspNetRoles];
SELECT * FROM [Admin].[AspNetUserRoles];

SELECT [MtG].[GetManaCost]('Omnath, Locus of Mana') AS ManaCost;
SELECT [MtG].[GetSetName]('4ce5b167-df7a-499e-8dcc-7aec2e28b382') AS SetName;
SELECT [MtG].[GetSetIcon]('4ce5b167-df7a-499e-8dcc-7aec2e28b382') AS SetIcon;

SELECT * FROM [User].[GetCardCollection]('UCf97c-0678_0', 'Omnath, Locus of Mana');
SELECT * FROM [User].[GetFullCollection]('UCf97c-0678_0');
SELECT [MtG].[GetCardName]('4ce5b167-df7a-499e-8dcc-7aec2e28b382');

INSERT INTO [MtG].[Card] VALUES('4ce5b167-df7a-499e-8dcc-7aec2e28b382', 'Omnath, Locus of Mana', 'https://cards.scryfall.io/png/front/4/c/4ce5b167-df7a-499e-8dcc-7aec2e28b382.png?1610161645', 'Commander Collection: Green', 'https://svgs.scryfall.io/sets/cc1.svg?1688356800', '{2}{G}', 'Mono Green');
EXECUTE [User].[InsertIntoCollection] 'UCf97c-0678_0', '4ce5b167-df7a-499e-8dcc-7aec2e28b382', 'UO-NM', 'Black Deck Box, Omnath Deck', 1;
EXECUTE [User].[InsertIntoCollection] 'UCf97c-0678_0', '4ce5b167-df7a-499e-8dcc-7aec2e28b382', 'UO-NM', 'Legendary Storage Binder', 1;
INSERT INTO [User].[Collection] VALUES('UCf97c-0678_0', '4ce5b167-df7a-499e-8dcc-7aec2e28b382', '', 'UO-NM', 'Black Deck Box, Omnath Deck', 1);
DELETE FROM [User].[Collection] WHERE CompendiumID = 'UCf97c-0678_0';
DELETE FROM [User].[Compendium] WHERE ID = 'UCf97c-0678_0';
EXECUTE [MtG].[UpdateCardQuantity]'f97c771c-95f5-492d-a0b8-d25db8300678', '4ce5b167-df7a-499e-8dcc-7aec2e28b382', 'UO-NM', 'Legendary Storage Binder', -1;
EXECUTE [MtG].[UpdateCardQuantity]'f97c771c-95f5-492d-a0b8-d25db8300678', '4ce5b167-df7a-499e-8dcc-7aec2e28b382', 'UO-NM', 'Black Deck Box, Omnath Deck', -1;

INSERT INTO [Admin].[AspNetUserRoles] VALUES('ce8531db-388b-40b6-8db5-3037845814da', '003');


SELECT UC.*, 
AG.Type, AG.Name, AG.[Description]
FROM [User].[Collection] AS UC
LEFT JOIN [MtG].[AvailableGrades] AS AG
ON UC.Condition = AG.ID
WHERE UC.CompendiumID = 'UCf97c-0678_0' AND UC.CardID = '4ce5b167-df7a-499e-8dcc-7aec2e28b382';

SELECT * FROM [User].[GetUserCollection]('UCf97c-0678_0', 'Omnath, Locus of Mana');

SELECT [MtG].[CheckCardExists]('4e4fb50c-a81f-44d3-93c5-fa9a0b37f617')

SELECT TOP 25 CardID, Count(CardID) AS 'Count'
FROM (
    SELECT DISTINCT CardID, CompendiumID
    FROM [User].[Collection]
) AS DistinctCards
GROUP BY CardID
ORDER BY Count DESC;

SELECT UserName
FROM [Admin].[AspNetUsers]
WHERE Id = 'f97c771c-95f5-492d-a0b8-d25db8300678'

SELECT *
FROM [Admin].[AspNetUserRoles]
WHERE RoleId = '000' OR RoleId = '001'


SELECT * FROM [Admin].[Top25Cards]()

SELECT * FROM [MtG].[AvailableGrades]

Select * from [MtG].[Card]

UPDATE [MtG].[Card] SET SetIcon = 'https://svgs.scryfall.io/sets/znr.svg?1689566400' WHERE ID = '4e4fb50c-a81f-44d3-93c5-fa9a0b37f617'

SELECT *
FROM [User].[Compendium]

INSERT INTO [User].[Compendium] VALUES('UCf97c-0678_0', 'Chandra Ablaze');
INSERT INTO [User].[Compendium] VALUES('UCf97c-0678_0', 'Jace, the Mind Sculptor');
INSERT INTO [User].[Compendium] VALUES('UCf97c-0678_0', 'Omnath, Locus of All');
INSERT INTO [User].[Compendium] VALUES('UCf97c-0678_0', 'Omnath, Locus of Creation');
INSERT INTO [User].[Compendium] VALUES('UCf97c-0678_0', 'Omnath, Locus of Mana');

UPDATE [User].[Collection] SET ScryfallUri = 'https://scryfall.com/card/mom/249/omnath-locus-of-all' WHERE CardID = '33d94ecf-758b-4f68-a7be-6bf3ff1047f4';

SELECT u.Id AS UserId, u.UserName, r.Id AS RoleId, r.Name AS RoleName
    FROM [Admin].[AspNetUsers] u
    INNER JOIN [Admin].[AspNetUserRoles] ur ON u.Id = ur.UserId
    INNER JOIN [Admin].[AspNetRoles] r ON ur.RoleId = r.Id;