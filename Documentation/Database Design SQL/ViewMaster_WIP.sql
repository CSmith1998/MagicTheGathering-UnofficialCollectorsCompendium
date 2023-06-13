/* Card Details - OnHold */
/* SELECT C.*, GROUP_CONCAT(K.Keyword, ', '),
Face.FaceName, Face.ManaCost, Face.TypeLine, Face.Power, 
Face.Toughness, Face.OracleText, Face.FlavorText, Legality.*, 
STRING_AGG(Finish.FinishName, ', '), Price.USD, Price.USD_Foil,
Price.USD_Etched, Price.EUR, Price.EUR_Foil, Price.TIX,
STRING_AGG(ImgUrl.FaceName, ImgUrl.Small, ImgUrl.Normal, ImgUrl.Large,
ImgUrl.PNG, ImgUrl.ArtCrop, ImgUrl.BorderCrop, ', ')


FROM [MtG].[Card] AS C
INNER JOIN [MtG].[Face] AS Face
    ON C.ID = Face.CardID
INNER JOIN [MtG].[Colors] AS Color
    ON C.ID = Color.CardID */

SELECT C.*,

STRING_AGG(CONVERT(NVARCHAR(max), K.FaceName), ', ') as 'FaceNames', STRING_AGG(CONVERT(NVARCHAR(max), K.Keyword), ', ') AS 'Keywords',

Legality.Standard, Legality.Future, Legality.Historic,
Legality.Gladiator, Legality.Pioneer, Legality.Explorer,
Legality.Modern, Legality.Legacy, Legality.Pauper,
Legality.Vintage, Legality.Penny, Legality.Commander,
Legality.Oathbreaker, Legality.Brawl, Legality.HistoricBrawl,
Legality.Alchemy, Legality.PauperCommander, Legality.Duel,
Legality.Oldschool, Legality.Premodern, Legality.Predh,

STRING_AGG(CONVERT(NVARCHAR(max), Finish.FinishName), ', '),

Price.USD, Price.USD_Foil, Price.USD_Etched,
Price.EUR, Price.EUR_Foil, Price.TIX,

Purchase.TCGPlayer, Purchase.CardMarket, Purchase.CardHoarder

FROM [MtG].[Card] AS C
LEFT JOIN [MtG].[Keywords] AS K
    ON C.ID = K.CardID
LEFT JOIN [MtG].[Legalities] AS Legality
    ON C.ID = Legality.CardID
LEFT JOIN [MtG].[Finishes] AS Finish
    ON C.ID = Finish.CardID
LEFT JOIN [MtG].[Prices] AS Price
    ON C.ID = Price.CardID
LEFT JOIN [MtG].[PurchaseURLs] AS Purchase
    ON C.ID = Purchase.CardID

WHERE C.ID = 'ae155ee2-008f-4dc6-82bf-476be7baa224' GROUP BY 

C.ID, C.Name, C.ReleasedAt, C.Layout, 
C.ConvertedManaCost, C.ColorIdentity, C.TypeLine, 
C.Reserved, C.Foil, C.Nonfoil, 
C.Promo, C.Oversized, C.Rarity, 
C.FullArt, C.Textless, C.Reprint, 
C.RulingsURL, C.SetID, C.Artist,

Legality.Standard, Legality.Future, Legality.Historic,
Legality.Gladiator, Legality.Pioneer, Legality.Explorer,
Legality.Modern, Legality.Legacy, Legality.Pauper,
Legality.Vintage, Legality.Penny, Legality.Commander,
Legality.Oathbreaker, Legality.Brawl, Legality.HistoricBrawl,
Legality.Alchemy, Legality.PauperCommander, Legality.Duel,
Legality.Oldschool, Legality.Premodern, Legality.Predh,

Price.USD, Price.USD_Foil, Price.USD_Etched,
Price.EUR, Price.EUR_Foil, Price.TIX,

Purchase.TCGPlayer, Purchase.CardMarket, Purchase.CardHoarder;

SELECT

Face.FaceName,
/*dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), Face.ManaCost), ','), ',') AS 'ManaCost',
dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), K.Keyword), ','), ',') AS 'Keywords',
dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), Face.Power), ','), ',') AS 'Power',
dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), Face.Toughness), ','), ',') AS 'Toughness',
dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), Face.OracleText), '//'), '//') AS 'OracleText',
dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), Face.FlavorText), '//'), '//') AS 'FlavorText',*/
Face.ManaCost, K.Keyword, Face.Power, Face.Toughness, Face.OracleText, Face.FlavorText,

dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), Colors.FaceName), '//'), '//') AS FaceName,
dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), Colors.ColorID), ','), ',') AS ColorID,

/*dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), ImgUrl.FaceName), ', '), ',') AS */
dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), ImgUrl.Small), ','), ',') AS Small,
dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), ImgUrl.Normal), ','), ',') AS Normal,
dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), ImgUrl.Large), ','), ',') AS Large,
dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), ImgUrl.PNG), ','), ',') AS PNG,
dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), ImgUrl.ArtCrop), ','), ',') AS ArtCrop,
dbo.fn_DistinctList(STRING_AGG(CONVERT(NVARCHAR(max), ImgUrl.BorderCrop), ','), ',') AS BorderCrop

FROM [MtG].[Card] AS C
LEFT JOIN [MtG].[Keywords] AS K
    ON C.ID = K.CardID
LEFT JOIN [MtG].[Face] AS Face
    ON C.ID = Face.CardID
LEFT JOIN [MtG].[Colors] as Colors
    ON C.ID = Colors.CardID
LEFT JOIN [MtG].[Legalities] AS Legality
    ON C.ID = Legality.CardID
LEFT JOIN [MtG].[Finishes] AS Finish
    ON C.ID = Finish.CardID
LEFT JOIN [MtG].[Prices] AS Price
    ON C.ID = Price.CardID
LEFT JOIN [MtG].[ImageURLs] AS ImgUrl
    ON C.ID = ImgUrl.CardID
LEFT JOIN [MtG].[PurchaseURLs] AS Purchase
    ON C.ID = Purchase.CardID

WHERE C.ID = 'ae155ee2-008f-4dc6-82bf-476be7baa224' GROUP BY Face.FaceName, Face.ManaCost, Face.FlavorText, Face.OracleText, Face.Power, Face.Toughness, K.Keyword, Face.TypeLine;