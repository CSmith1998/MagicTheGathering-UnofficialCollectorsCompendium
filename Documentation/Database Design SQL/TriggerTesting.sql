SELECT * FROM [User].[Details];
SELECT * FROM [User].[Collection];
SELECT * FROM [User].[Compendium];

INSERT INTO [MtG].[Card] VALUES('4ce5b167-df7a-499e-8dcc-7aec2e28b382', 'Omnath, Locus of Mana', 'Mono Green');
INSERT INTO [User].[Collection] VALUES('UCf97c-0678_0', '4ce5b167-df7a-499e-8dcc-7aec2e28b382', 'UO-NM', 'Black Deck Box, Omnath Deck', 1);
INSERT INTO [User].[Collection] VALUES('UCf97c-0678_0', '4ce5b167-df7a-499e-8dcc-7aec2e28b382', 'UO-NM', 'Legendary Storage Binder', 1);
DELETE FROM [User].[Collection] WHERE CompendiumID = 'UCf97c-0678_0';
DELETE FROM [User].[Compendium] WHERE ID = 'UCf97c-0678_0';
EXECUTE [MtG].[UpdateCardQuantity]'f97c771c-95f5-492d-a0b8-d25db8300678', '4ce5b167-df7a-499e-8dcc-7aec2e28b382', 'UO-NM', 'Legendary Storage Binder', 1;
EXECUTE [MtG].[UpdateCardQuantity]'f97c771c-95f5-492d-a0b8-d25db8300678', '4ce5b167-df7a-499e-8dcc-7aec2e28b382', 'UO-NM', 'Black Deck Box, Omnath Deck', -1;


SELECT UC.*, 
AG.Type, AG.Name, AG.[Description]
FROM [User].[Collection] AS UC
LEFT JOIN [MtG].[AvailableGrades] AS AG
ON UC.Condition = AG.ID
WHERE UC.CompendiumID = 'UCf97c-0678_0' AND UC.CardID = '4ce5b167-df7a-499e-8dcc-7aec2e28b382';