/* Card Details - OnHold */
/* SELECT C.*, GROUP_CONCAT(K.Keyword, ', '),
Face.FaceName, Face.ManaCost, Face.TypeLine, Face.Power, 
Face.Toughness, Face.OracleText, Face.FlavorText, Legality.*, 
GROUP_CONCAT(Finish.FinishName, ', '), Price.USD, Price.USD_Foil,
Price.USD_Etched, Price.EUR, Price.EUR_Foil, Price.TIX,
STRING_AGG(ImgUrl.FaceName, ImgUrl.Small, ImgUrl.Normal, ImgUrl.Large,
ImgUrl.PNG, ImgUrl.ArtCrop, ImgUrl.BorderCrop, ', ')


FROM [MtG].[Card] AS C
INNER JOIN [MtG].[Face] AS Face
    ON C.ID = Face.CardID
INNER JOIN [MtG].[Colors] AS Color
    ON C.ID = Color.CardID */