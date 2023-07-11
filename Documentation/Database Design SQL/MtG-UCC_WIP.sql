SET IMPLICIT_TRANSACTIONS ON
SET XACT_ABORT ON
BEGIN TRANSACTION

/* CREATE TABLE [MtG].[AvailableSets] (
    ID VARCHAR(36) PRIMARY KEY,
    SetCode VARCHAR(10),
    SetName VARCHAR(100),
    SetType VARCHAR(25),
    Released VARCHAR(20) DEFAULT('Missing'),
    SymbolUrl VARCHAR(250) DEFAULT('Missing')
); */

CREATE TABLE [MtG].[AvailableIdentities] (
    IdentityName VARCHAR(10) PRIMARY KEY,
    Black NCHAR(1) DEFAULT('N'),
    Green NCHAR(1) DEFAULT('N'),
    Red NCHAR(1) DEFAULT('N'),
    Blue NCHAR(1) DEFAULT('N'),
    White NCHAR(1) DEFAULT('N')
);

/* CREATE TABLE [MtG].[Card] (
    ID VARCHAR(36) PRIMARY KEY,
    Name VARCHAR(141) Unique,
    ReleasedAt DATE,
    Layout VARCHAR(25) DEFAULT('Normal'),
    ConvertedManaCost DECIMAL(3,1),
    ColorIdentity VARCHAR(10) FOREIGN KEY REFERENCES [MtG].[AvailableIdentities](IdentityName),
    TypeLine VARCHAR(150),
    Reserved NCHAR(1) DEFAULT('N'),
    Foil NCHAR(1) DEFAULT('N'),
    Nonfoil NCHAR(1) DEFAULT('Y'),
    Oversized NCHAR(1) DEFAULT('N'),
    Promo NCHAR(1) DEFAULT('N'),
    Reprint NCHAR(1) DEFAULT('N'),
    SetID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[AvailableSets](ID),
    RulingsURL VARCHAR(250),
    Rarity VARCHAR(12) DEFAULT('Common'),
    Artist VARCHAR(100),
    FullArt NCHAR(1) DEFAULT('N'),
    Textless NCHAR(1) DEFAULT('N')
); */

CREATE TABLE [MtG].[Card] (
    ID VARCHAR(36) PRIMARY KEY,
    Name VARCHAR(141),
    PNG VARCHAR(450),
    SetName VARCHAR(250),
    SetIcon VARCHAR(450),
    ManaCost VARCHAR(150),
    ColorIdentity VARCHAR(10) FOREIGN KEY REFERENCES [MtG].[AvailableIdentities](IdentityName)
);

/* CREATE TABLE [MtG].[Face] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    FaceName VARCHAR(141) UNIQUE NOT NULL,
    ManaCost VARCHAR(125),
    TypeLine VARCHAR(150),
    Power INT,
    Toughness INT,
    OracleText VARCHAR(500),
    FlavorText VARCHAR(500),
    CONSTRAINT CPK_FaceID PRIMARY KEY (CardID, FaceName)
); */

CREATE TABLE [MtG].[AvailableGrades] (
    ID VARCHAR(12) PRIMARY KEY,
    Type VARCHAR(10),
    Name VARCHAR(20),
    Description VARCHAR(MAX)
);

CREATE TABLE [User].[Details] (
    AccountID NVARCHAR(450) PRIMARY KEY,
    CompendiumID VARCHAR(450) UNIQUE NOT NULL, 
    AccessID VARCHAR(45) UNIQUE NOT NULL, 
    CONSTRAINT FK_DetailsAccountID FOREIGN KEY (AccountID) REFERENCES [Admin].[AspNetUsers](Id)
);

CREATE TABLE [User].[Compendium] (
    ID VARCHAR(450) FOREIGN KEY REFERENCES [User].[Details](CompendiumID) NOT NULL,
    CardName VARCHAR(141) UNIQUE NOT NULL,
    ManaCost AS [MtG].[GetManaCost](CardName),
    ColorIdentity AS [MtG].[GetColorIdentity](CardName),
    TotalQty AS [MtG].[GetCardTotal](ID, CardName), 
    CONSTRAINT CPK_UserCompendium PRIMARY KEY (ID, CardName)
);

/* UPDATE COLLECTION IN API AND SITE TO USE NEW CardName FIELD! REMOVE CardName PASS FROM COMPENDIUM VIEW */

CREATE TABLE [User].[Collection] (
    CompendiumID VARCHAR(450) FOREIGN KEY REFERENCES [User].[Details](CompendiumID) NOT NULL,
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    CardName VARCHAR(141),
    CardFace AS [MtG].[GetCardFace](CardID),
    SetName AS [MtG].[GetSetName](CardID),
    SetIcon AS [MtG].[GetSetIcon](CardID),
    Condition VARCHAR(12) FOREIGN KEY REFERENCES [MtG].[AvailableGrades](ID) DEFAULT('UO-UKN') NOT NULL,
    StorageLocation VARCHAR(250) DEFAULT('Undefined') NOT NULL,
    Quantity INT DEFAULT(1),
    CONSTRAINT CPK_UserCollection PRIMARY KEY (CompendiumID, CardID, Condition, StorageLocation)
);

CREATE TABLE [User].[Access] (
    ID VARCHAR(45) FOREIGN KEY REFERENCES [User].[Details](AccessID) NOT NULL, 
    AccessType VARCHAR(256),
    IP VARCHAR(36),
    Time DATETIME NOT NULL,
    CONSTRAINT CPK_UserAccess PRIMARY KEY (ID, Time)
);

/* CREATE TABLE [MtG].[AvailableColors] (
    ColorID CHAR(1) PRIMARY KEY,
    ColorName VARCHAR(5) UNIQUE,
    LandName VARCHAR(8) UNIQUE
);

CREATE TABLE [MtG].[Colors] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    FaceName VARCHAR(141) FOREIGN KEY REFERENCES [MtG].[Face](FaceName) NOT NULL,
    ColorID CHAR(1) FOREIGN KEY REFERENCES [MtG].[AvailableColors](ColorID) NOT NULL,
    CONSTRAINT CFK_FaceID FOREIGN KEY (CardID, FaceName) REFERENCES [MtG].[Face](CardID, FaceName),
    CONSTRAINT CPK_CardColorID PRIMARY KEY (CardID, FaceName, ColorID)
); */

/* CREATE TABLE [MtG].[ColorIdentity] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    IdentityName VARCHAR(10) FOREIGN KEY REFERENCES [MtG].[AvailableIdentities](IdentityName) NOT NULL,
    CONSTRAINT CPK_CardColorIdentity PRIMARY KEY (CardID, IdentityName)
); */

/* CREATE TABLE [MtG].[AvailableKeywords] (
    Keyword VARCHAR(25) PRIMARY KEY,
    Description VARCHAR(MAX)
);

CREATE TABLE [MtG].[Keywords] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    FaceName VARCHAR(141) FOREIGN KEY REFERENCES [MtG].[Face](FaceName) NOT NULL,
    Keyword VARCHAR(25) FOREIGN KEY REFERENCES [MtG].[AvailableKeywords](Keyword) NOT NULL,
    CONSTRAINT CPK_KeywordID PRIMARY KEY (CardID, FaceName, Keyword)
);

CREATE TABLE [MtG].[Prices] (
    CardID VARCHAR(36) PRIMARY KEY,
    USD DECIMAL(10,2) NULL,
    USD_Foil DECIMAL(10,2) NULL,
    USD_Etched DECIMAL(10,2) NULL,
    EUR DECIMAL(10,2) NULL,
    EUR_Foil DECIMAL(10,2) NULL,
    TIX DECIMAL(10,2) NULL,
    CONSTRAINT FK_CardPrices FOREIGN KEY (CardID) REFERENCES [MtG].[Card](ID)
);

CREATE TABLE [MtG].[ImageURLs] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    FaceName VARCHAR(141) FOREIGN KEY REFERENCES [MtG].[Face](FaceName) NOT NULL,
    Small VARCHAR(250) NULL,
    Normal VARCHAR(250) NULL,
    Large VARCHAR(250) NULL,
    PNG VARCHAR(250) NULL,
    ArtCrop VARCHAR(250) NULL,
    BorderCrop VARCHAR(250) NULL,
    CONSTRAINT CPK_FaceImageID PRIMARY KEY (CardID, FaceName)
);

CREATE TABLE [MtG].[CardURLs] (
    CardID VARCHAR(36) PRIMARY KEY,
    Scryfall VARCHAR(250) NULL,
    Gatherer VARCHAR(250) NULL,
    EDHRec VARCHAR(250) NULL
    CONSTRAINT FK_CardUrls FOREIGN KEY (CardID) REFERENCES [MtG].[Card](ID)
);

CREATE TABLE [MtG].[PurchaseURLs] (
    CardID VARCHAR(36) PRIMARY KEY,
    TCGPlayer VARCHAR(250) NULL,
    CardMarket VARCHAR(250) NULL,
    CardHoarder VARCHAR(250) NULL,
    CONSTRAINT FK_CardPurchaseUrls FOREIGN KEY (CardID) REFERENCES [MtG].[Card](ID)
); */

/* CREATE TABLE [MtG].[Artist] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    FaceName VARCHAR(141) FOREIGN KEY REFERENCES [MtG].[Face](FaceName) NOT NULL,
    Name VARCHAR(50),
    CONSTRAINT CPK_CardArtist PRIMARY KEY (CardID, FaceName, Name)
); */

/* CREATE TABLE [MtG].[ArtistIDs] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    FaceName VARCHAR(141) FOREIGN KEY REFERENCES [MtG].[Face](FaceName) NOT NULL,
    ArtistID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Artist](ID) NOT NULL,
    CONSTRAINT CPK_FaceArtistID PRIMARY KEY (CardID, FaceName, ArtistID)
); */

/* CREATE TABLE [MtG].[Legalities] (
    CardID VARCHAR(36) PRIMARY KEY,
    Standard NCHAR(1) DEFAULT('N'),
    Future NCHAR(1) DEFAULT('N'),
    Historic NCHAR(1) DEFAULT('N'),
    Gladiator NCHAR(1) DEFAULT('N'),
    Pioneer NCHAR(1) DEFAULT('N'),
    Explorer NCHAR(1) DEFAULT('N'),
    Modern NCHAR(1) DEFAULT('N'),
    Legacy NCHAR(1) DEFAULT('N'),
    Pauper NCHAR(1) DEFAULT('N'),
    Vintage NCHAR(1) DEFAULT('N'),
    Penny NCHAR(1) DEFAULT('N'),
    Commander NCHAR(1) DEFAULT('N'),
    Oathbreaker NCHAR(1) DEFAULT('N'),
    Brawl NCHAR(1) DEFAULT('N'),
    HistoricBrawl NCHAR(1) DEFAULT('N'),
    Alchemy NCHAR(1) DEFAULT('N'),
    PauperCommander NCHAR(1) DEFAULT('N'),
    Duel NCHAR(1) DEFAULT('N'),
    Oldschool NCHAR(1) DEFAULT('N'),
    Premodern NCHAR(1) DEFAULT('N'),
    Predh NCHAR(1) DEFAULT('N'),
    CONSTRAINT FK_CardLegalities FOREIGN KEY (CardID) REFERENCES [MtG].[Card](ID)
);

CREATE TABLE [MtG].[AvailableFinishes] (
    Name VARCHAR(8) PRIMARY KEY,
    Description VARCHAR(450)
);

CREATE TABLE [MtG].[Finishes] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    FinishName VARCHAR(8) FOREIGN KEY REFERENCES [MtG].[AvailableFinishes](Name) NOT NULL,
    CONSTRAINT CPK_CardFinishes PRIMARY KEY (CardID, FinishName)
); */

/* EMERGENCY DROP COMMANDS
DROP TABLE [MtG].[Finishes];
DROP TABLE [MtG].[AvailableFinishes];
DROP TABLE [MtG].[Legalities];
DROP TABLE [MtG].[PurchaseURLs];
DROP TABLE [MtG].[CardURLs];
DROP TABLE [MtG].[ImageURLs];
DROP TABLE [MtG].[Prices];
DROP TABLE [MtG].[Keywords];
DROP TABLE [MtG].[AvailableKeywords];
DROP TABLE [MtG].[Colors];
DROP TABLE [MtG].[AvailableColors];
DROP TABLE [User].[Access];
DROP TABLE [User].[Collection];
DROP TABLE [User].[Compendium];
DROP TABLE [User].[Details];
DROP TABLE [MtG].[AvailableGrades];
DROP TABLE [MtG].[Face];
DROP TABLE [MtG].[Card];
DROP TABLE [MtG].[AvailableIdentities];
DROP TABLE [MtG].[AvailableSets];
*/

/* INSERT STATIC INFORMATION */

/* Available Finishes */
/*INSERT INTO [MtG].[AvailableFinishes] VALUES('Nonfoil', 'A standard Magic: The Gathering card with no special finish.');
INSERT INTO [MtG].[AvailableFinishes] VALUES('Foil', 'A Magic: The Gathering card with a holo/foil finish.');
INSERT INTO [MtG].[AvailableFinishes] VALUES('Etched', 'A Magic: The Gathering card with a special etched finish.');
INSERT INTO [MtG].[AvailableFinishes] VALUES('Glossy', 'A Magic: The Gathering card with a glossy finish.');*/

/* Available Grades - Official Grading */
INSERT INTO [MtG].[AvailableGrades] VALUES('OG-GEM-MT 10', 'Official', 'Gem Mint', 'Officially graded card that has been deemed to be virtually perfect. Attributes include four perfectly shaped corners, sharp focus and full original gloss. A Gem Mint 10 must be free of staining of any kind, but an allowance may be made for a slight printing imperfection, if it doesn''t impair the overall appeal of the card. The card''s contents must be centered on the card face within a tolerance not to exceed approximately 55/45 to 60/40 percent on the front and 75/25 percent on the back.');
INSERT INTO [MtG].[AvailableGrades] VALUES('OG-MINT 9', 'Official', 'Mint', 'Officially graded card that has been deemed to be  in superb condition. A Mint 9 exhibits only one of the following minor flaws: a very slight stain on the back, a minor printing imperfection, or slightly off-color borders. Centering must be approximately 60/40 to 65/35 or better on the front and 90/10 or better on the back.');
INSERT INTO [MtG].[AvailableGrades] VALUES('OG-NM-MT 8', 'Official', 'Near Mint-Mint', 'Officially graded card that has been deemed to be super high-end. A Near Mint-Mint appears like a Mint 9 at first glance, but upon closer inspection, the card can exhibit the following: a very slight stain on the back, minute fraying at one or two corners, a minor printing imperfection, and/or slightly off-color borders. Centering must be approximately 65/35 to 70/30 or better on the front and 90/10 or better on the back.');
INSERT INTO [MtG].[AvailableGrades] VALUES('OG-NM 7', 'Official', 'Near Mint', 'Officially graded card that has been deemed to have very minimal surface wear. A Mint card should have just slight surface wear upon close inspection. There may be slight fraying on some corners. Content focus might be slightly out-of-register. A minor printing blemish is acceptable. Slight staining is acceptable on the back of the card only. Centering must be approximately 70/30 to 75/25 or better on the front and 90/10 or better on the back.');
INSERT INTO [MtG].[AvailableGrades] VALUES('OG-EX-MT 6', 'Official', 'Excellent Mint', 'Officially graded card that has been deemed to have visible surface wear or a printing defect that does not detract from its overall appeal. A very light scratch may be present only upon close inspection. Corners may have slightly graduated fraying. Content focus may be slightly out-of-register. Card may show some loss of original gloss, may have a minor stain on the back, may exhibit very slight notching on edges, and may show some off-color on borders. Centering must be 80/20 or better on the front and 90/10 or better on the back.');
INSERT INTO [MtG].[AvailableGrades] VALUES('OG-EX 5', 'Official', 'Excellent', 'Officially graded card with very minor damage to corners becoming evident. Surface wear or printing defects are more visible. There may be minor chipping on edges. Loss of original gloss will be more apparent. Focus of content may be slightly out-of-register. Several light scratches may be visible upon close inspection, but do not detract from the appeal of the card. Card may show some off-color borders. Centering must be 85/13 or better on the front and 90/10 or better on the back.');
INSERT INTO [MtG].[AvailableGrades] VALUES('OG-VG-EX 4', 'Official', 'Very Good-Excellent', 'Officially graded card with minor damage to corners becoming evident and suface wear that is noticeable but modest. The card may have light scuffing or light scratches. Some original gloss will be retained. Borders may be slightly off-color. A light crease may be visible. Centering must be 85/15 or better on the front and 90/10 or better on the back.');
INSERT INTO [MtG].[AvailableGrades] VALUES('OG-VG 3', 'Official', 'Very Good', 'Officially graded card with evident damage to corners, but not extreme, with some surface wear apparent, along with possible light scuffing or light scratches. Focus of content may be somewhat off-register and edges may exhibit noticeable wear. Much, but not all, of the card''s original gloss is lost. Borders may be somewhat discolored. A crease may be visible. Printing defects are possible. Slight stain may show on card front and staining to the card back may be more prominent. Centering must be 90/10 or better on the front and back.');
INSERT INTO [MtG].[AvailableGrades] VALUES('OG-GOOD 2', 'Official', 'Good', 'Officially graded card that shows accelerated damage to corners and surface wear that is starting to become obvious. A good card may have scratching, scuffing, light staining, or chipping on the front. There may be several creases. Original gloss may be completely absent. Card may show considerable discoloration. Centering must be 90/10 or better on the front and back.');
INSERT INTO [MtG].[AvailableGrades] VALUES('OG-FR 1.5', 'Official', 'Fair', 'Officially graded card that shows extreme wear to corners, possible effecting the contents of the card. The surface of the card will show advanced stages of wear, including scuffing, scratching, pitting, chipping, and staining. The contents will possibly be quite out-of-register and the borders may show considerable discoloration. The card may have one or more heavy creases. In order to achieve a Fair grade, a card must be fully intact. Even though the card may be heavily worn, it cannot achieve this grade if it is missing solid pieces of the card as a result of a major tear, etc. This would include damage such as the removal of the back layer of the card or an entire corner. The centering must be approximately 90/10 or better on the front and back.');
INSERT INTO [MtG].[AvailableGrades] VALUES('OG-PR 1', 'Official', 'Poor', 'Officially graded card that exhibits defects that have advanced to such a serious stage such that the eye appeal of the card has nearly vanished in its entirety. A Poor card may be missing one or two small pieces, exhibit major creasing that nearly breaks through all the layers of the card, or it may contain extreme discoloration or dirtiness throughout that may make it difficult to identify some of the content on the front or back. A card of this nature may also show noticeable warping or other types of destructive effect.');
INSERT INTO [MtG].[AvailableGrades] VALUES('OG-N0', 'Official', 'Authentic Only', 'Officially certified card that proves it is authentic, but has not been given a numeric grade. This may be due to the existence of an alteration, one with malice or otherwise, a major defect, or the owner asked to encapsulate the card without a grade.');
INSERT INTO [MtG].[AvailableGrades] VALUES('OG-AA', 'Official', 'Authentic Altered', 'Officially certified card that proves it is authentic, but has been refused a grade due to the existence of alterations. The term altered may mean that the card shows evidence of one or more of the following: trimming, recoloring, restoration, and/or cleaning.');

/* Available Grades - Unofficial Grading */
INSERT INTO [MtG].[AvailableGrades] VALUES('UO-UKN', 'Unofficial', 'Unknown', 'A card with an undetermined grade.');
INSERT INTO [MtG].[AvailableGrades] VALUES('UO-NM', 'Unofficial', 'Near Mint', 'Self-graded card identified as being in Mint or Near Mint condition. Near Mint condition cards display minimal or no wear or damage. The card should appear "fresh out of the pack." Other than minor chipping, indentation, or scratches, the card shows no moderate or major signs of damage. These cards may be "never played" cards or cards that have been played with sleeves.');
INSERT INTO [MtG].[AvailableGrades] VALUES('UO-LP', 'Unofficial', 'Lightly Played', 'Self-graded card identified as being lightly played. Lightly Played condition cards may have minor border or corner wear, scruffs or scratches. There are no major defects such as grime, bends, or issues with the structural integrity of the card. Noticeable imperfections are okay, but none should be too severe or at too high a volume.');
INSERT INTO [MtG].[AvailableGrades] VALUES('UO-MP', 'Unofficial', 'Moderately Played', 'Self-graded card identified as being moderately played. Moderately Played condition cards can have border wear, corner wear, scratching or scuffing, creasing or whitening, or any combination of moderate examples of these flaws. A Moderately Played card may have some imperfection impacting a small area of the card from mishandling or poor storage, such as creasing that doesn''t affect card integrity, in combination with other issues such as scratches, scuffs, or border/edge wear.');
INSERT INTO [MtG].[AvailableGrades] VALUES('UO-HP', 'Unofficial', 'Heavily Played', 'Self-graded card identified as being heavily played. Heavily Played condition cards show a major amount of wear. Cards can show a variety of moderate imperfections along with creasing, whitening, and bends. Heavily Played cards can also have flaws that impact the integrity of the card, but the card can still be sleeve playable.');
INSERT INTO [MtG].[AvailableGrades] VALUES('UO-DMG', 'Unofficial', 'Damaged', 'Self-graded card identified as being damaged. Damaged condition cards show wear or imperfections beyond the standards for other conditions. Card in this condition can also exhibit an imperfection that may make the card illegal for tournament play, even in a sleeve. Cards may have major border wear, scratching or scuffing, as well as folds, creases, tears or other damage that impacts the structural integrity of the card.');

/* Available Colors */
/*INSERT INTO [MtG].[AvailableColors] VALUES('B', 'Black', 'Swamp');
INSERT INTO [MtG].[AvailableColors] VALUES('G', 'Green', 'Forest');
INSERT INTO [MtG].[AvailableColors] VALUES('R', 'Red', 'Mountain');
INSERT INTO [MtG].[AvailableColors] VALUES('U', 'Blue', 'Island');
INSERT INTO [MtG].[AvailableColors] VALUES('W', 'White', 'Plains');*/

/* Available Identities - MonoColor - BGRUW */
INSERT INTO [MtG].[AvailableIdentities] VALUES('Mono Black', 'Y', 'N', 'N', 'N', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Mono Green', 'N', 'Y', 'N', 'N', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Mono Red', 'N', 'N', 'Y', 'N', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Mono Blue', 'N', 'N', 'N', 'Y', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Mono White', 'N', 'N', 'N', 'N', 'Y');

/* Available Identities - No Color - BGRUW */
INSERT INTO [MtG].[AvailableIdentities] VALUES('Colorless', 'N', 'N', 'N', 'N', 'N');

/* Available Identities - Two Color Identities - BGRUW */
INSERT INTO [MtG].[AvailableIdentities] VALUES('Azorius', 'N', 'N', 'N', 'Y', 'Y');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Boros', 'N', 'N', 'Y', 'N', 'Y');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Dimir', 'Y', 'N', 'N', 'Y', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Golgari', 'Y', 'Y', 'N', 'N', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Gruul', 'N', 'Y', 'Y', 'N', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Izzet', 'N', 'N', 'Y', 'Y', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Orzhov', 'Y', 'N', 'N', 'N', 'Y');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Rakdos', 'Y', 'N', 'Y', 'N', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Selesnya', 'N', 'Y', 'N', 'N', 'Y');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Simic', 'N', 'Y', 'N', 'Y', 'N');

/* Available Identities - Three Color Identities - BGRUW */
INSERT INTO [MtG].[AvailableIdentities] VALUES('Abzan', 'Y', 'Y', 'N', 'N', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Bant', 'N', 'Y', 'N', 'Y', 'Y');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Esper', 'Y', 'N', 'N', 'Y', 'Y');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Grixis', 'Y', 'N', 'Y', 'Y', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Jeskai', 'N', 'N', 'Y', 'Y', 'Y');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Jund', 'Y', 'Y', 'Y', 'N', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Mardu', 'Y', 'N', 'Y', 'N', 'Y');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Naya', 'N', 'Y', 'Y', 'N', 'Y');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Sultai', 'Y', 'Y', 'N', 'Y', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Temur', 'N', 'Y', 'Y', 'Y', 'N');

/* Available Identities - Four Color Identities - BGRUW */
INSERT INTO [MtG].[AvailableIdentities] VALUES('Glint', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Dune', 'Y', 'Y', 'Y', 'N', 'Y');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Ink', 'N', 'Y', 'Y', 'Y', 'Y');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Witch', 'Y', 'Y', 'N', 'Y', 'Y');
INSERT INTO [MtG].[AvailableIdentities] VALUES('Yore', 'Y', 'N', 'Y', 'Y', 'Y');

/* Available Identities - Five Color Identities - BGRUW */
INSERT INTO [MtG].[AvailableIdentities] VALUES('Rainbow', 'Y', 'Y', 'Y', 'Y', 'Y');

/* Available Keywords  - Evergreen Actions*/
/*INSERT INTO [MtG].[AvailableKeywords] VALUES('Attach', 'The term attach is used on Auras, Equipment, and Fortifications, which provide effects to certain other cards for an indeterminate amount of time. These types of cards are used by designating something (usually a permanent) for them to be "attached" to.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Counter', 'To counter a spell or ability is to remove it from the stack without resolving its effects, putting it directly into its owner''s graveyard. Some spells and abilities have an additional clause that replaces the graveyard with another game zone. There are instant spells that will explicitly counter other spells, generally known as "counterspells" after the original card with this effect. Some cards specify that they "cannot be countered".');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Exile', 'To exile a card is to put it into the exile zone, usually as part of a card''s effect. Starting from the Magic 2010 rules changes, cards that say "remove [something] from the game" or "set [something] aside" were issued errata to say "exile [something]" instead.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Fight', 'When two creatures fight each other, each creature deals damage equal to its power to the other creature. Multiple creatures may fight each other at the same time.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Mill', 'When a player Mills x cards, they put the top x cards of that library into their graveyard.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Sacrifice', 'To sacrifice a permanent is to put it into its owner''s graveyard. A player can only sacrifice a permanent they control. Note that this term is separate from other ways permanents can be put into their owners'' graveyards, such as destruction (meaning regeneration has no effect on sacrifice) and state-based actions (a creature having 0 toughness, for example). Players are not allowed to sacrifice unless prompted to by a game effect.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Scry', 'Scry x allows the player to take the top x cards from their deck, examine them, and place any number of them on the bottom of their deck and the rest on top in any order desired.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Tap', 'To tap a permanent is to rotate the card 90 degrees. This indicates it is being used, often as a cost, or to indicate that a creature is attacking (except for creatures with vigilance). Creatures a player controls that have not been under their control since the beginning of their most recent turn are said to have "summoning sickness" and cannot be tapped for their abilities that include the "tap symbol", nor can they attack, but they can be tapped for costs that use the word "tap" (for example, "Tap two untapped creatures you control").');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Untap', 'To untap a permanent is to return it to a vertical orientation, allowing it to be tapped again. A tapped permanent must be untapped before it can be tapped again. However, untapping can also be a cost for activated abilities. It has its own special untap symbol (often called "Q"), and is separate from normal untapping. To pay a cost including the untap symbol, the permanent must be already tapped. If that permanent is also a creature, then, as with the tap symbol, that ability can only be used if the creature has been under its controller''s control since the beginning of their most recent turn.');*/

/* Available Keywords - Evergreen */
/*INSERT INTO [MtG].[AvailableKeywords] VALUES('Deathtouch', 'Deathtouch is a static ability that causes a creature to be destroyed as a result of having been dealt damage by a source with deathtouch. In this way, for a creature with deathtouch, any nonzero amount of damage it deals to another creature is considered enough to kill it.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Defender', 'Creatures with defender cannot attack.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Double Strike', 'A creature with double strike deals both first strike and normal combat damage.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Enchant', 'This ability is written Enchant (quality) and appears on Auras, a subtype of enchantment spells. An Aura enters the battlefield attached to a permanent spell with the quality of its Enchant ability, and can only be attached to a permanent with that quality. If an Aura is no longer attached to a permanent with the required quality (such as if the object it enchants leaves the battlefield), it is put into its owner''s discard pile. Like protection, the quality can be almost anything, but it normally has a permanent type associated with it, such as "Enchant creature".');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Equip', ' A player may pay the Equip cost as a sorcery (only during their own main phase when the stack is empty) to attach it to a creature they control. That creature becomes "equipped" and can then be referenced by the equipment as the "equipped creature". The controller may pay the Equip cost again to move it to another creature. When a creature leaves the battlefield or stops being a creature by some effect, any equipment attached to it "falls off", becoming unattached but remaining on the battlefield. Equipment does not "fall off" if another player gains control of either the creature or the equipment - the player who controls the equipment may pay the Equip cost to move it to a creature they control.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('First Strike', 'Creatures with first strike deal damage before other creatures in combat. Therefore, if a creature with first strike deals sufficient damage to kill an opposing creature without this ability, it will not suffer any combat damage from that creature in return.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Flash', 'Artifacts, creatures or enchantments with flash may be played any time their controller could play an instant.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Flying', 'Creatures with flying cannot be blocked except by other creatures with flying and/or reach.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Haste ', 'Creatures with the haste ability are able to attack and use abilities that involve the tap symbol on the turn a player gains control of them, instead of waiting until their controller''s next turn. Haste is an example of a retroactive keywording, as cards from almost every earlier set have possessed "may attack the turn [they] come into play" or "unaffected by summoning sickness", which was replaced by the word "haste".');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Hexproof', 'A player or permanent with hexproof cannot be the target of spells or abilities controlled by an opponent. This is similar to shroud, but it does not deny the player (or their allies) the ability to target their own hexproof permanents.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Indestructible', 'A permanent with indestructible cannot be destroyed by effects that say "Destroy" or by lethal damage. However, they can be countered, exiled, returned to the hand or library, sacrificed, or killed with effects that lower their toughness to zero.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Lifelink', 'Permanents with lifelink cause their controller to gain life whenever they deal damage equal to the amount of damage dealt.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Menace', 'A creature with menace can only be blocked by two or more creatures.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Protection', 'A creature with protection from a quality cannot be enchanted, equipped, blocked, or targeted by anything with that quality, and all damage that would be dealt by a source of that quality is prevented, barring exceptions which explicitly state otherwise.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Prowess', 'Prowess is a triggered ability. A creature with prowess gains +1/+1 (until end of turn) whenever a noncreature spell is cast by its controller. If a creature has multiple instances of prowess, each triggers separately.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Reach', 'Reach is a countermeasure to block creatures with flying. Creatures with flying can only be blocked by creatures with flying or reach.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Trample', 'An attacking creature with trample which is blocked may deal any excess damage, above what is needed to kill the blocker, directly to the defending player. The choice is made by the attacking player, as circumstances can arise in which "overkilling" the blocking creature is a more advantageous move.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Vigilance', 'Creatures with vigilance do not tap when attacking, meaning they can still be used during the opponent''s turn to block.');*/

/* Keywords - Expert Level (Mechanics) */
/*INSERT INTO [MtG].[AvailableKeywords] VALUES('Absorb', 'This ability is written Absorb x, where x is a quantity of damage prevented on a creature with the ability.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Adapt', 'This ability is written (cost): Adapt x. If a creature has no +1/+1 counters on it, the player may pay the adapt cost to put N +1/+1 counters on that creature. In comparison to monstrosity, if a creature somehow loses its +1/+1 counters, it can adapt again and pick up more.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Affinity', 'This ability is written Affinity for (quality). A card with affinity costs 1 generic mana less to cast for each permanent with that quality under the caster''s control.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Afterlife', 'This ability is written Afterlife x. When a creature with afterlife dies, its controller creates x 1/1 black and white spirit tokens with flying.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Aftermath', 'Aftermath is an ability that appears on instant and sorcery split cards (a card with two separate card images printed on its face next to one another). Only one of the pair of images contains the aftermath ability. The half of the pair without the aftermath ability can be cast from the player''s hand as normal. Once the physical card is in the player''s graveyard (discard pile), the half of the pair that has the aftermath ability can be cast from the graveyard for the cost printed on the upper right of that card, after which the physical card is exiled.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Amplify', 'This ability is written Amplify x. As a creature with amplify enters the battlefield, its controller may reveal any number of creature cards in their hand that share a creature type with the creature . That creature enters the battlefield with x +1/+1 counters on it for each card revealed this way.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Annihilator', 'This ability is written Annihilator x. Whenever a creature with annihilator attacks, the defending player sacrifices x permanents. Annihilator abilities trigger and resolve during the declare attackers step. The defending player chooses and sacrifices the required number of permanents before they declare blockers.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Ascend', 'Ascend is an ability that checks if the player controls ten or more permanents. Regardless of source, if the player passes the check, they gain a unique quality called city blessing for the rest of the game, which empowers all cards with ascend in various ways.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Aura Swap', 'This ability is written Aura swap (cost). By paying the aura swap cost, the player may exchange the Aura with this ability with an Aura card in their hand, if they control and own the Aura with aura swap.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Bands With Other', 'This ability is a limited version of banding, written as Bands with other (quality). A creature with this ability has banding, but can only band with creatures that have the same ability; e.g. are of the creature type or sub-type (quality), are of the color (quality), and so on. Unlike normal banding, in an attacking band only one creature is required to have the bands with other (quality) ability, so long as all other creatures in the band have the specified quality. All other banding rules apply.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Battle Cry', 'When a creature with battle cry attacks, all other attacking creatures get +1/+0 until the end of the turn.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Bestow', 'This ability is written Bestow (cost). A creature with bestow gives the player the option to cast it as an Aura that enchants a creature, granting that creature its power, toughness, and abilities. A bestow card cast for its normal cost will enter the stack as a creature spell. By choosing to pay the alternative cost, which is a static ability, it becomes an Enchantment-Aura spell; if the creature it targets leaves the battlefield before the bestow card resolves or while the bestow card is enchanting the creature, the bestow card enters the battlefield as an enchantment creature - unlike a regular aura card which would go to the graveyard.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Bolster', 'This ability is written Bolster x. When a player bolsters, the player chooses one of their creatures with the lowest toughness among them and puts x +1/+1 counters on it. The bolster effect does not target; the choice of creature is made at the resolution of the spell or ability.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Bloodthirst', 'This ability is written Bloodthirst x. A creature with bloodthirst x enters the battlefield with x +1/+1 counters on it if an opponent had been damaged during that turn.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Bushido', 'This ability is written Bushido x. When a creature with bushido blocks or becomes blocked, it gets +x/+x until end of turn.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Buyback', 'This ability is written Buyback (cost). It appears on instants and sorceries and is an additional, optional cost when casting the card. If the buyback cost was paid, the card returns to its owner''s hand upon resolving, instead of going to the graveyard.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Cascade', 'When a spell with cascade is cast, its controller reveals cards from the top of their deck until a non-land card that has a lower converted mana cost is revealed. That player may then (in addition to the original spell) cast the revealed spell without paying its mana cost; all other revealed cards are put on the bottom of the deck in a random order.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Champion', 'This ability is written Champion a (type). It is an evolution-style mechanic that mimics a creature changing into a "new improved version". When a creature with champion enters the battlefield, its controller must exile a card they control of the appropriate type, or sacrifice the champion. When the creature with champion leaves the battlefield, the creature it "championed" (the exiled card) is returned to the battlefield.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Changeling', 'Changeling is a keyword that gives a card all possible creature types.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Cipher', 'When a spell with cipher resolves, its controller may exile the spell "encoded" on a creature they control. Then, whenever that creature deals combat damage to an opponent, its controller can cast a free copy of the encoded spell.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Clash', 'When a card says to clash, its controller chooses an opponent to clash with, and each player involved in the clash reveals the top card of their deck, then puts it on the top or bottom of that deck. The winner of the clash is the player who revealed the card with the highest converted mana cost. If there is a tie, there is no winner. All cards with clash grant a bonus effect if their controller wins the clash.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Conspire', 'As a player casts a spell with conspire, they may pay the optional, additional cost of tapping two creatures that share a color with the spell. They then copy the spell and may choose new targets for the copy.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Convoke', 'As a spell with convoke is cast, its controller may tap any number of creatures. Each creature tapped reduces the card''s mana cost by 1 generic mana or 1 mana of the tapped creature''s color.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Crew', 'This ability is written as Crew x and appears only on vehicles. Vehicles are not creatures by default, but have a power and toughness printed in a different colour. A vehicle''s controller can pay the crew cost by tapping any number of creatures with total power greater than or equal to x, which turns the vehicle into an artifact creature until end of turn.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Cumulative Upkeep', 'This ability is written Cumulative upkeep (cost). At the beginning of each of its controller''s upkeeps, an "age counter" is put on the card. The player must then either pay the cumulative upkeep cost for each age counter on the permanent, or sacrifice it.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Cycling', 'This ability is written Cycling (cost). A player with a card with cycling in hand may pay the cycling cost, discard the card, and draw a new card.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Dash', 'This ability is written Dash (cost). A player casting a card with Dash may opt to pay its Dash cost instead of the normal cost. If the Dash cost is chosen, the creature gains Haste until the end of turn, and is returned to its owner''s hand at the end of turn.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Daybound & Nightbound', 'Cards featuring daybound and nightbound will transform when certain rules are met. If it is day, to transform to night the active player must not cast any spells during their turn. To transform back to day, the active player must cast two or more spells during their last turn.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Delve', 'When playing a card with delve, its controller may exile any number of cards in their graveyard. For each card exiled, the spell costs 1 colorless mana less to play.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Detain', 'When a player detains a permanent, the detained permanent cannot attack, block, or activate abilities until the start of the player''s next turn.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Devour', 'This ability is written Devour x. As a creature with devour enters the battlefield, its controller may sacrifice any number of creatures in order to put x +1/+1 counters on the devouring creature for each creature sacrificed.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Dredge', 'This ability is written Dredge x. If a card with dredge is in the player''s graveyard, that player may put the top x cards of their deck into their graveyard and return the card with dredge to their hand, instead of drawing a card from their deck. A player cannot do this if there are fewer than x cards in their library.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Echo', 'This ability is written Echo (cost). Cards with echo require their echo cost to be paid at the beginning of their controller''s upkeep, the turn after the card was played or gained control of. If the echo cost is not paid, then the card is sacrificed.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Embalm', 'This ability is written Embalm (cost). When a card with this ability is in a player''s graveyard, that player may pay its embalm cost to exile the card and put a token into play that is a zombie copy of the creature, in addition to the creature''s other creature types. This allows a player to gain a second use from a card with benefits from other cards that interact with zombie creatures. Embalm is an activated ability (the token is created, not cast) and may be played only when the player could cast a sorcery.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Emerge', 'Emerge is an ability allowing the player to pay an alternate mana cost by sacrificing a creature and paying the difference between the Emerge cost and the sacrificed creature''s converted mana cost.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Entwine', 'This ability is written Entwine (cost). All cards with entwine are modal spells with two choices. Normally, a player chooses one mode or the other. If the card''s entwine cost is paid in addition to its regular cost, both effects happen.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Epic', 'Epic has two effects: first, after a player casts a spell with epic, they can no longer cast spells for the remainder of the game. However, at the beginning of each of they upkeeps for the rest of the game, the player puts a new copy of the epic spell on the stack. This does not count as "casting" it (so it does not become a useless ability) and no mana payment is required.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Evolve', 'Evolve is a keyword on creatures which allows them to grow larger. Whenever a creature enters the battlefield under the player''s control, if that creature has larger power or toughness than the creature with evolve, that player puts a +1/+1 counter on the creature with evolve.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Evoke', 'This ability is written as Evoke (cost) and is an alternate cost for a creature, generally far lower, with the condition that the creature must be sacrificed upon entering the battlefield. All cards with evoke have additional effects upon entering or leaving the battlefield. The creature''s controller may choose whether the sacrifice occurs before or after the additional effect(s).');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Exalted', 'When any creature a player controls attacks alone, it receives +1/+1 until end of turn for each permanent with the exalted keyword that player controls.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Exert', 'Depending on the card, a creature with this ability can be exerted to activate its ability, or can be exerted during attack for an additional bonus, at the cost of that creature not untapping during its controller''s next untap step.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Exploit', 'A card with exploit gives the player who casts it the option to sacrifice a creature they control when it enters the battlefield, so that a specified ability will trigger.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Explore', 'When a creature explores, its controller reveals the top card of their library. If it is a land card, they put it in their hand; otherwise, they put a +1/+1 counter on that creature and can choose to leave that card on top or send it to their graveyard.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Extort', 'When casting a spell, the player may pay one white or black mana. If they do, then each opponent loses one life and the player gains one life for each point of life their opponent(s) lost.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Fabricate', 'This creature ability is written as Fabricate x. When a creature with fabricate enters the battlefield, its controller either puts x +1/+1 counters on it or creates x 1/1 colorless Servo artifact creature tokens.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Fading', 'This ability is written as Fading x. A permanent with fading enters the battlefield with x fade counters on it. At the beginning of its controller''s upkeep, a fade counter is removed; if a counter cannot be removed, the card is sacrificed.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Fateseal', 'This ability is written Fateseal x. To fateseal, a player looks at the top x cards of an opponent''s deck and may put any number of those cards on the bottom of that player''s deck.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Flanking', 'When a creature with flanking is blocked by a creature without this ability, the blocking creature gets -1/-1 until end of turn. The effect is cumulative; multiple instances of flanking will effect a greater penalty, though a blocking creature only needs one instance to avoid the effect.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Flashback', 'This ability is written Flashback (cost). When a card with this ability is in a player''s graveyard, that player may pay its flashback cost and cast the card from the graveyard. The card is then exiled.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Flip', 'Flip is a keyword action that deals with specially printed cards known as "flip cards". Each of these cards has two sets of normal card attributes (e.g. name, rules text, power and toughness): one right-side-up above the card''s image and one upside-down (with no mana cost) below the image. Flip cards enter the battlefield unflipped, with only the former set of attributes applying. Once certain conditions are met, the player flips the card (rotating it 180 degrees) and the second set of attributes come into effect. Once flipped, a card cannot be unflipped (except by leaving the battlefield and returning), and effects that would "flip" a card that is already "flipped" do nothing.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Forecast', 'This ability is written Forecast — Cost: Effect. During a player''s upkeep, if they have a card with forecast in their hand, they may pay the forecast cost to activate its forecast ability. The cost always includes revealing the card until the end of the upkeep. A player can only do this once per turn per forecast card.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Foretell', 'To foretell a card, a player pays two mana (of any combination of colors) and then exiles the card with foretell ability faced down. In any future turns, they can cast the card from exile by paying the foretell costs (this is the mana cost listed on the card) rather than paying the mana cost of the card. They may not cast the card from exile on the same turn that it was exiled.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Fortify', 'This ability is written Fortify (cost). A player pays the fortify cost as a sorcery (only during their own main phase when the stack is empty) and attaches it to a land they control. That land becomes "fortified" and can then be referenced by the fortification as the "fortified land". Other than attaching to lands instead of creatures, the rules for fortifications are similar to those for equipment.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Frenzy', 'This ability is written Frenzy x. When a creature with frenzy attacks and is not blocked, it gets + x /+0 until end of turn.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Graft', 'This ability is written Graft x. All creatures with graft are 0/0 creatures that enter the battlefield with x +1/+1 counters on them. Whenever another creature enters the battlefield, a player may move one +1/+1 counter from any number of creatures with graft they control onto that creature.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Gravestorm', 'When a player casts a spell with gravestorm, they put a copy of that spell on the stack for each permanent that was previously put into a graveyard that turn.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Haunt', 'When a creature with haunt dies or when an instant or sorcery with haunt resolves, the ability triggers causing the card to be exiled "haunting" a creature. Haunt allows a player to use an effect twice: once when the spell is played (or the creature enters the battlefield), and once when the creature it haunts is put into a graveyard.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Hideaway', 'When a card with hideaway enters the battlefield, its controller chooses one card from the top four of their library and exiles that card face-down. Each card with hideaway also has another ability that allows its controller to play the "hidden" card, without paying its mana cost, under certain conditions.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Horsemanship', 'Horsemanship parallels flying in that creatures with horsemanship can only be blocked by other creatures with horsemanship. There is no exception analogous to reach.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Infect', 'Creatures with infect deal damage to other creatures in the form of -1/-1 counters, similar to wither, and to players in the form of poison counters. A player who receives 10 poison counters loses the game.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Jump-Start', 'Spells with jump-start can be cast from the graveyard with the additional cost of discarding a card. After the spell leaves the stack, it is exiled.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Kicker', 'This ability is written Kicker (cost). The kicker cost is an additional and optional cost that can be paid when the card is cast. If the card is "kicked", an ability of the card takes effect. Some cards have multiple kicker abilities; a player may choose to pay any, all, or none of these.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Level Up', 'This ability is written Level up (cost). Any time they could cast a sorcery, a player may activate the level up ability of a "leveler" creature to put a level counter on it. Leveler creatures increase in power and gain new abilities as they accumulate level counters, as indicated by the three striped bands in the text box.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Living Weapon', 'When an equipment with living weapon enters the battlefield, its controller puts a 0/0 black Germ creature token onto the battlefield then attaches that equipment to the token. All cards with living weapon give the equipped creature a toughness increase to compensate for the Germ''s 0 toughness; the player may attach the equipment to a different creature, but the Germ will be instantly sent to the graveyard.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Madness', 'This ability is written Madness (cost). At the time a player discards a card with madness, they may pay its madness cost and cast the card.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Manifest', 'This ability is written Manifest [one or more cards], most frequently manifest the top card of your library. When the player manifests a card, the player puts it onto the battlefield face down, disguising its true identity from their opponents. While face down, it''s a 2/2 colorless creature with no name, no abilities, and no creature types. Face-down cards act as creatures: they can attack and block, be targeted by spells and abilities affecting creatures, and be modified with auras and equipment. However, if the face-down card is a creature card then it can be turned face-up for its full mana cost whether it has this ability on its own or not. If the card has the morph ability, the controller can use this ability to turn the card face-up, regardless of the card''s type; megamorph is treated the same way. These uses of morph and megamorph are considered ''special actions'' and do not hit the stack.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Meld', 'Meld is a keyword action where two specific cards can be exiled and then returned to the battlefield combined into a single creature.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Mentor', 'Whenever a creature with mentor attacks, a +1/+1 counter may be placed on another attacking creature with lesser power. If a creature has multiple instances of mentor, each triggers separately.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Miracle', 'This ability is written Miracle (cost). If the first card a player draws during any turn has miracle, they may reveal the card. If the card is revealed, the player may then cast the card for its miracle cost.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Modular', 'This ability is written Modular x. A creature with modular enters the battlefield with x +1/+1 counters on it, and when that creature is put into a graveyard, its controller may put all the +1/+1 counters on that creature onto a target artifact creature.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Monstrosity', 'This ability is written (Cost): Monstrosity x. If a creature is not monstrous yet, this ability makes that creatures monstrous and it gets x +1/+1 counters. Some creatures with this ability gain an additional effect once they become monstrous.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Morph', 'This ability is written Morph (cost). A card with morph may be cast face-down by paying 3 generic mana. While face-down, the creature is a colorless, nameless and typeless 2/2 creature. At any time, a player may pay the creature''s morph cost and turn the card face-up. Many cards with morph have additional abilities when they are turned face-up. Only cards with morph may be played face-down. If a card without morph is turned face-down by an effect, it cannot be turned face-up (unless the effect specified otherwise), because it has no morph ability with which to do so.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Multikicker', 'Multikicker is a variant of the kicker keyword, written Multikicker (cost), where the cost can be paid any number of times when the card is played, as opposed to the limit of one as defined in the original kicker ability. Cards with multikicker have an ability that references the number of times the card was "kicked".');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Mutate', 'If the player casts a spell for its mutate cost, they put it over or under a non-Human creature they own. The creature mutates into the creature on top plus all abilities from under it.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Ninjutsu', 'This ability is written Ninjutsu (cost). If a player has a Ninja in hand and controls an attacking creature the opponent has declined to block, they may pay its ninjutsu cost, return the unblocked creature to their hand, and put the Ninja onto the battlefield tapped and attacking.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Offering', 'This ability is written (Creature type) offering. A player may cast a creature with the offering ability as an instant (similar to flash) but must sacrifice a creature of the stated type and pay the difference in mana cost between the sacrificed creature and the creature with offering.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Overload', 'By paying the more-expensive overload cost instead of the regular mana cost, the spell can affect all possible targets, rather than a single one.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Persist', 'When a creature with persist is put into a graveyard from the battlefield, if it had no -1/-1 counters on it, it is returned to the battlefield under its owner''s control with a -1/-1 counter on it.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Poisonous', 'This ability is written Poisonous x. Whenever a creature with poisonous deals combat damage to a player, that player gets x poison counters. A player with ten poison counters loses the game.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Populate', 'To populate, a player puts a token onto the battlefield that''s a copy of a creature token they control.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Proliferate', 'To proliferate, a player chooses any number of permanents and/or players with a counter (e.g. a Planeswalker loyalty counter, a +1/+1 counter, a poison counter), then gives each exactly one additional counter of a kind that permanent or player already has.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Provoke', 'When a creature with provoke attacks, its controller may target a creature the defending player controls, forcing it to untap (if it is tapped) and block the attacking creature if it is able to do so. The ability can choose a creature that is not able to block the creature with provoke.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Prowl', 'This ability is written Prowl (cost) and is an alternate cost. A player can cast a card for its prowl cost if the player controls a creature of the same type which dealt damage to a player that turn. Most cards with prowl have an additional effect if cast for their prowl cost.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Rampage', 'This ability is written Rampage x. When a creature with rampage becomes blocked, the creature gains +x/+x until end of turn for each creature beyond the first assigned to block.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Rebound', 'The rebound ability allows a player to cast an instant or sorcery spell more than once. When a spell with rebound is cast from a player''s hand, that player exiles it, and during their next upkeep may cast the spell again without paying its mana cost.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Recover', 'This ability is written Recover (cost). Whenever a creature is put into a player''s graveyard from the battlefield, all cards with recover in that player''s graveyard trigger. That player may then pay each card''s recover cost; if the cost is paid, the card is put into the player''s hand, but if it is not paid, the card is exiled.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Reinforce', 'This ability is written Reinforce x — (cost). A player may discard a card with reinforce from their hand, pay its reinforce cost, and put x +1/+1 counters on a target creature.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Renown', 'This ability is written Renown x. The first time a creature deals combat damage to a player, x +1/+1 counters are put on it.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Replicate', 'This ability is written Replicate (cost). When a player casts a spell with replicate, they may pay the replicate cost any number of times, then they put a copy of the spell on the stack for each time the replicate cost was paid.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Retrace', 'The Retrace keyword allows players to replay a spell from the graveyard by paying its mana cost and all associated costs with the additional cost of discarding a land card. Unlike with flashback, a card cast from the graveyard with retrace is not exiled, and returns to the graveyard after it resolves.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Riot', 'As a creature with riot enters the battlefield, its controller can choose it to enter with a +1/+1 counter or haste. If a creature has multiple instances of riot, each triggers separately.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Ripple', 'This ability is written Ripple x. When a spell with ripple is cast, its controller may reveal the top x cards of their deck. If any of them have the same name as the spell with ripple that was cast, then the player can cast those cards without paying their mana costs (this triggers their ripple abilities, so a player can ripple again). Any cards not thus cast are then put on the bottom of that player''s deck.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Scavenge', 'This ability is written Scavenge (cost). Any time they could cast a sorcery, a player may exile a card with scavenge from their graveyard to put a number of +1/+1 counters onto a target creature equal to the power of the creature with scavenge.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Shadow', 'Creatures with shadow can only block or be blocked by other creatures with the shadow ability.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Soulbond', 'Creatures with soulbond can be paired with other creatures (with or without soulbond) when either creature enters the battlefield. When paired, each of the paired creatures receives the ability printed on the soulbond creature''s card (if both creatures have soulbond, they each receive both abilities). Creatures remain paired as long as they remain under the control of the caster.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Soulshift', 'This ability is written Soulshift x. When a creature with soulshift is put into a graveyard from the battlefield, its controller may return a spirit card with converted mana cost x or less from their graveyard to their hand.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Spectacle', 'This ability is written Spectacle (cost). A player can cast a spell for its spectacle cost if an opponent lost life during the turn. In some cases additional benefits are provided for paying the spectacle cost.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Splice', 'This ability is written Splice onto (quality) (cost). As a player casts a spell with a given quality, they may reveal any number of cards in their hand with splice onto that quality, and pay their splice costs; each splicing card''s effects are added to those of the spell cast, while the cards spliced onto the spell are kept in the player''s hand. These effects are placed after the played spell''s effects.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Split Second', 'While a spell with split second is on the stack, players cannot cast spells or activate non-mana abilities. Triggered abilities and certain special actions that do not use the stack (such as un-morphing a face-down permanent) can be played as normal.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Storm', 'When a spell with storm is played, the player puts a copy of that spell on the stack for each spell cast before the storm spell that turn, getting that many instances of the spell.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Sunburst', 'A permanent with sunburst enters the battlefield with a +1/+1 counter if a creature, or a charge counter otherwise, for each different color of mana spent to pay its mana cost.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Support', 'This ability is written as Support N, and puts a +1/+1 counter on each of up to N target creatures.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Surveil', 'To Surveil x, a player looks at the top x cards of their library, and puts them in the graveyard or on top of their deck in any order.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Suspend', 'This ability is written Suspend x — (cost). Any time a player could cast a spell with suspend, they may instead pay its suspend cost to exile it with x time counters on it. The player removes a time counter every time their upkeep step begins. Other spells or effects can add or remove time counters from suspended cards.) When the last counter is removed, the spell is cast without paying its mana cost and, if it is a creature, it gains haste. Cards may be given suspend and have time counters put on them when they are exiled by an effect.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Totem Armor', 'Totem armor is an ability which appears on Auras. When the enchanted creature would be destroyed, an attached Aura with totem armor is destroyed instead.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Transfigure', 'This ability is written Transfigure (cost). Any time a sorcery could be cast, a player may pay a creature''s transfigure cost and sacrifice it to search their deck for a creature with the same converted mana cost as the sacrificed creature and place it onto the battlefield.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Transform', 'Each transform card enters the battlefield with its front face up, and when certain conditions are met, the player turns the card over to its other face to transform it.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Transmute', 'This ability is written Transmute (cost). When a sorcery could be cast, a player may pay the transmute cost of a card in their hand and discard it, then search their deck for a card with the same converted mana cost as the discard and put that card in their hand.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Typecycling', 'Typecycling is a variant of cycling that is worded (card type) cycling (cost). When the ability is used the player discards the card, then may search their deck for any card containing the indicated subtype and put it in their hand.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Undying', 'When a creature with undying is put into a graveyard from the battlefield, if it had no +1/+1 counters on it, it is returned to the battlefield under its owner''s control with a +1/+1 counter.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Unearth', 'This ability is written Unearth (cost). If a creature with unearth is in a player''s graveyard, any time a sorcery could be played, that player may pay its unearth cost to return that creature to the battlefield. The creature gains haste and is exiled at the beginning of the next end step, or if it would otherwise leave the battlefield.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Unleash', 'A player may choose to have a creature with unleash enter the battlefield with a +1/+1 counter on it. If a creature with unleash has a +1/+1 counter on it (whether put there by its own ability or another source), that creature cannot block.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Vanishing', 'This ability is written Vanishing x. A permanent with vanishing enters the battlefield with x time counters on it. At the beginning of its controller''s upkeep, a time counter is removed. When the last counter is removed, the card is sacrificed.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Ward', 'Whenever a permanent with ward becomes the target of a spell or ability an opponent controls, the ability is countered unless that player pays the associated Ward cost.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Wither', 'Wither is a replacement ability that modifies damage. Nonlethal damage marked on a creature normally goes away at the end of the turn. However, whenever a source with wither deals damage to a creature, that creature receives a number of -1/-1 counters equal to the amount of damage dealt to it. When it deals damage to a player, that player will receive regular damage unlike infect.');*/

/* Available Keywords - Ability Words */
/*INSERT INTO [MtG].[AvailableKeywords] VALUES('Addendum', 'Cards with addendum have additional effects if they are cast during their controller''s main phase.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Battalion', 'Battalion is a creature ability word which gives an advantage whenever the creature attacks with at least two other creatures.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Bloodrush', 'For a cost, bloodrush allows a creature card to be discarded to give a temporary boost to an attacking creature, equal to the discarded creature''s power and toughness and also temporarily granting the discarded creature''s abilities.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Channel', 'All cards with channel have the ability to be discarded for a cost to yield a specified effect.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Chroma', 'Chroma is an ability of a permanent or spell that checks for specific mana symbols of cards in specific zones. When a card with chroma is played, it will indicate a specified effect or characteristic-defining ability and repeat it for every color symbol in the checked zone.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Domain', 'Domain refers to an effect that may be stronger or weaker depending on the number of basic land types (Plains, Island, Swamp, Mountain, and/or Forest) among lands a player controls.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Enrage', 'Enrage is a creature-exclusive ability word, indicating abilities that trigger whenever that creature is dealt damage.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Fateful Hour', 'Cards with fateful hour gain an additional ability if controlled by a player with 5 life or less.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Ferocious', 'Cards with ferocious gain an additional ability if their controller controls a creature with power four or more.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Grandeur', 'Grandeur is an ability written as Discard another card named (name of card): (effect). This was designed as a means of reducing the drawback of drawing multiple copies of the same legendary permanent.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Hellbent', 'Cards with the hellbent ability word have greater effects if their controller has no cards in their hand.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Heroic', 'Cards with the heroic ability word gain an advantage when targeted with a spell. Although there are many heroic effects, the most common use of this mechanic is to give a creature a +1/+1 counter.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Imprint', 'Imprint is an ability word which only appears on artifacts and creatures. All cards with imprint have either an activated (Cost: Effect) or triggered ability which allows the player to exile a card to grant abilities to the artifact with imprint.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Join Forces', 'Join forces is an ability word geared toward multiplayer variants. An effect denoted with join forces allows all players to contribute to it, usually by paying mana, though that effect might not be mutually beneficial.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Kinship', 'All cards with kinship are creatures that check, at the beginning of their controller''s upkeep, the top card of that player''s deck. If it shares a creature type with the creature that has the kinship ability, the player may reveal it for a bonus effect.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Landfall', 'Landfall is an ability word associated with bonuses given to players for playing lands.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Metalcraft', 'Cards with the metalcraft ability word gain an additional effect while their controller controls three or more artifacts.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Morbid', 'Cards with the morbid ability word gain an additional effect during a turn in which a creature died.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Radiance', 'The radiance ability word denotes abilities that target one permanent, but affect all permanents of the same type that share a color with the target.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Raid', 'A card with raid gains an additional effect if their controller attacked the turn they are played.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Rally', 'A creature with a rally ability triggers whenever an ally enters the battlefield under their control and gives some kind of bonus to all of that player''s creatures, even non-ally creatures.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Sweep', 'Sweep is an ability word used on spells with effects which can be strengthened by returning any number of lands of a single basic land type to their owners'' hands.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Threshold', 'This ability is written Threshold — ability. Whenever a player has seven or more cards in the graveyard, their cards gain any threshold abilities they might have. A player cannot activate an ability tied to threshold unless they have seven or more cards in the graveyard.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Undergrowth', 'Undergrowth provides benefits depending on the number of creatures in the player''s graveyard.');*/

/* Available Keywords - Discontinued Keywords */
/*INSERT INTO [MtG].[AvailableKeywords] VALUES('Banding', 'Banding is an ability that has defensive and offensive functions. A defending player determines how combat damage is dealt by an opposing creature if at least one of the creatures blocking has banding (without banding, the attacking player determines this). An attacking player may form "bands" of creatures with banding, which may also include one non-banding creature. If one creature in the band becomes blocked, the whole band becomes blocked as well, whether or not the defender could block other creatures in the band.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Bury', 'Destroy target creature. It cannot be regenerated.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Fear', 'Creatures with fear cannot be blocked except by black creatures and by artifact creatures.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Intimidate', 'A creature with intimidate cannot be blocked except by artifact creatures and creatures that share a color with it.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Landhome', 'This ability is written as (land type) home . A creature with landhome may only attack a player who controls a land of the specified land type, and must be sacrificed if its controller does not control at least one land of that same type.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Landwalk', 'This ability is written as (Land type) walk. A creature with this ability can not be blocked while the defending player controls at least one land with the printed land type (e.g. a creature with swampwalk can not be blocked if the opponent has a swamp on the battlefield).');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Phasing', 'Phasing introduced a new rule to the game. Cards with the status "phased out" are treated as though they do not exist except for cards that specifically interact with phased-out cards. At the beginning of each player''s turn, all permanents the player controls which have phasing become "phased out", along with anything attached to the phasing cards. Any cards the player controls which were phased out become "phased in" and return to the battlefield at the same time. Phasing in or out does not tap or untap the permanent. A token that phases out ceases to exist, while anything attached to it phases out and does not phase in on the token''s controller''s next turn.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Regenerate', ' An ability such as "Regenerate [this creature]" could be activated; in this context "regenerate" means "set up a regeneration shield", which protects the affected permanent from the next time it would be destroyed (either due to damage or to "destroy" effects). Instead of being destroyed, the permanent would become tapped and be removed from combat. The second keyword action refers to when this actually occurs: cards like Skeleton Scavengers have a delayed triggered ability that only triggers when the creature has a destroy effect prevented by its regeneration ability.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Shroud', 'A player or permanent with shroud cannot be the target of spells or abilities (even their own).');*/

/* Available Sets */

/* Available Sets - Core Editions */
/*INSERT INTO [MtG].[AvailableSets] VALUES('288bd996-960e-448b-a187-9504c1930c2c', 'LEA', 'Limited Edition Alpha', 'Core', 'August 1993', 'https://static.wikia.nocookie.net/mtg/images/d/dc/Limited_Edition_Alpha_Common.png/revision/latest?cb=20140407040302');
INSERT INTO [MtG].[AvailableSets] VALUES('5307bd88-637c-4a5c-9801-a0d887715302', 'LEB', 'Limited Edition Beta', 'Core', 'October 1993', 'https://static.wikia.nocookie.net/mtg/images/5/58/Limited_Edition_Beta_Common.png/revision/latest?cb=20140407040558');
INSERT INTO [MtG].[AvailableSets] VALUES('cd7694b9-339c-405d-a991-14413d4f6d5c', '2ED', 'Unlimited Edition', 'Core', 'December 1993', 'https://static.wikia.nocookie.net/mtg/images/6/6e/Unlimited_Edition_Common.png/revision/latest?cb=20140407041833');
INSERT INTO [MtG].[AvailableSets] VALUES('45a69797-8adf-468e-a4e1-ba81fd9d66ac', '3ED', 'Revised Edition', 'Core', 'April 1994', 'https://static.wikia.nocookie.net/mtg/images/2/27/Revised_Edition_Common.png/revision/latest?cb=20140407042040');
INSERT INTO [MtG].[AvailableSets] VALUES('2dd259d4-dc13-4956-a2dc-3e1d70b4a743', '4ED', 'Fourth Edition', 'Core', 'May 1995', 'https://static.wikia.nocookie.net/mtg/images/6/69/Fourth_Edition_Common.png/revision/latest?cb=20140407042805');
INSERT INTO [MtG].[AvailableSets] VALUES('5afd2f4b-8309-4f45-a2b2-3785018474cb', '5ED', 'Fifth Edition', 'Core', 'March 1997', 'https://static.wikia.nocookie.net/mtg/images/0/06/Fifth_Edition_Common.png/revision/latest?cb=20140407043124');
INSERT INTO [MtG].[AvailableSets] VALUES('78ee1957-d5d4-4551-acae-b1b418e8a50b', '6ED', 'Classic Sixth Edition', 'Core', 'April 1999', 'https://static.wikia.nocookie.net/mtg/images/1/13/Classic_Sixth_Edition_Common.png/revision/latest?cb=20161001185157');
INSERT INTO [MtG].[AvailableSets] VALUES('230f38aa-9511-4db8-a3aa-aeddbc3f7bb9', '7ED', 'Seventh Edition', 'Core', 'April 2001', 'https://static.wikia.nocookie.net/mtg/images/d/dd/Seventh_Edition_Common.png/revision/latest?cb=20140407043705');
INSERT INTO [MtG].[AvailableSets] VALUES('cae8d29d-5979-4d8f-884d-7f3183bcc886', '8ED', 'Eighth Edition', 'Core', 'July 2003', 'https://static.wikia.nocookie.net/mtg/images/7/71/Eighth_Edition_Common.png/revision/latest?cb=20140407044104');
INSERT INTO [MtG].[AvailableSets] VALUES('e70c8572-4732-4e92-a140-b4e3c1c84c93', '9ED', 'Ninth Edition', 'Core', 'July 2005', 'https://static.wikia.nocookie.net/mtg/images/b/b0/Ninth_Edition_Common.png/revision/latest?cb=20140407044329');
INSERT INTO [MtG].[AvailableSets] VALUES('a66a6124-0d81-488d-b080-91f5ba7fbad0', '10E', 'Tenth Edition', 'Core', 'July 2007', 'https://static.wikia.nocookie.net/mtg/images/3/38/Tenth_Edition_Common.png/revision/latest?cb=20140407044527');
INSERT INTO [MtG].[AvailableSets] VALUES('0dba38a9-6b9d-4768-9831-4e03e8970a0b', 'M10', 'Magic 2010', 'Core', 'July 2009', 'https://static.wikia.nocookie.net/mtg/images/7/75/Magic_2010_Common.png/revision/latest?cb=20140407045719');
INSERT INTO [MtG].[AvailableSets] VALUES('485d2468-18c8-42a4-9482-ca1c51e0470e', 'M11', 'Magic 2011', 'Core', 'July 2010', 'https://static.wikia.nocookie.net/mtg/images/3/3f/Magic_2011_Common.png/revision/latest?cb=20140407051028');
INSERT INTO [MtG].[AvailableSets] VALUES('5cdd2643-229c-4441-a62a-c34e4b531e1c', 'M12', 'Magic 2012', 'Core', 'July 2011', 'https://static.wikia.nocookie.net/mtg/images/9/92/Magic_2012_Common.png/revision/latest?cb=20140407154534');
INSERT INTO [MtG].[AvailableSets] VALUES('f9b0c6f4-8a4f-4f36-ad3c-e1e16fb8535d', 'M13', 'Magic 2013', 'Core', 'July 2012', 'https://static.wikia.nocookie.net/mtg/images/f/f1/Magic_2013_Common.png/revision/latest?cb=20140407155121');
INSERT INTO [MtG].[AvailableSets] VALUES('e03ee1c0-ecd2-4fcc-ac3c-e8fdb103a847', 'M14', 'Magic 2014', 'Core', 'July 2013', 'https://static.wikia.nocookie.net/mtg/images/9/9c/Magic_2014_Common.png/revision/latest?cb=20140406170729');
INSERT INTO [MtG].[AvailableSets] VALUES('6ce49890-3b37-42a5-8932-dbeef1d7b62c', 'M15', 'Magic 2015', 'Core', 'July 2014', 'https://static.wikia.nocookie.net/mtg/images/b/be/Magic_2015_Common.png/revision/latest?cb=20160302194623');
INSERT INTO [MtG].[AvailableSets] VALUES('0eeb9a9a-20ac-404d-b55f-aeb7a43a7f62', 'ORI', 'Magic Origins', 'Core', 'July 2015', 'https://static.wikia.nocookie.net/mtg/images/6/63/Magic_Origins_Common.png/revision/latest?cb=20160404180428');
INSERT INTO [MtG].[AvailableSets] VALUES('2f5f2509-56db-414d-9a7e-6e312ec3760c', 'M19', 'Core Set 2019', 'Core', 'July 2018', 'https://static.wikia.nocookie.net/mtg/images/5/59/Core_Set_2019_Common.png/revision/latest?cb=20181020194738');
INSERT INTO [MtG].[AvailableSets] VALUES('4a787360-9767-4f44-80b1-2405dc5e39c7', 'M20', 'Core Set 2020', 'Core', 'July 2019', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('bc94aba1-7376-4e02-a12d-3a2efb66ab0f', 'M21', 'Core Set 2021', 'Core', 'July 2020', 'Missing');*/

/* Available Sets - Standard Sets */
/*INSERT INTO [MtG].[AvailableSets] VALUES('856f63eb-e056-43e5-8a56-7a58e1608940', 'ARN', 'Arabian Nights', 'Expansion', 'December 1993', 'https://static.wikia.nocookie.net/mtg/images/5/59/Arabian_Nights_Common.png/revision/latest?cb=20140409211806');
INSERT INTO [MtG].[AvailableSets] VALUES('819f9678-87dd-4aba-a47b-2d553bfea21f', 'ATQ', 'Antiquities', 'Expansion', 'March 1994', 'https://static.wikia.nocookie.net/mtg/images/b/b1/Antiquities_Common.png/revision/latest?cb=20140409211530');
INSERT INTO [MtG].[AvailableSets] VALUES('78c50b4b-b220-455b-a2d5-cee458fa56f3', 'LEG', 'Legends', 'Expansion', 'June 1994', 'https://static.wikia.nocookie.net/mtg/images/6/61/Legends_Common.png/revision/latest?cb=20140409211341');
INSERT INTO [MtG].[AvailableSets] VALUES('a21c6836-c435-459a-81e3-22d2da174549', 'DRK', 'The Dark', 'Expansion', 'August 1994', 'https://static.wikia.nocookie.net/mtg/images/c/c7/Homelands_Common.png/revision/latest?cb=20140409210543');
INSERT INTO [MtG].[AvailableSets] VALUES('cf7390b1-341a-4ae8-a325-da0f5f322f13', 'FEM', 'Fallen Empires', 'Expansion', 'November 1994', 'https://static.wikia.nocookie.net/mtg/images/1/15/Fallen_Empires_Common.png/revision/latest?cb=20140409210939');
INSERT INTO [MtG].[AvailableSets] VALUES('b0e08eea-5c01-4406-a6e2-dcd09c5e5b67', 'ICE', 'Ice Age', 'Expansion', 'June 1995', 'https://static.wikia.nocookie.net/mtg/images/a/a9/Ice_Age_Common.png/revision/latest?cb=20140409210322');
INSERT INTO [MtG].[AvailableSets] VALUES('5ac1f606-e682-46e9-ad0f-122a3783581b', 'HML', 'Homelands', 'Expansion', 'October 1995', 'https://static.wikia.nocookie.net/mtg/images/c/c7/Homelands_Common.png/revision/latest?cb=20140409210543');
INSERT INTO [MtG].[AvailableSets] VALUES('64987b06-4a5c-443d-b560-ff5691744582', 'ALL', 'Alliances', 'Expansion', 'May 1996', 'https://static.wikia.nocookie.net/mtg/images/5/5f/Alliances_Common.png/revision/latest?cb=20140409205957');
INSERT INTO [MtG].[AvailableSets] VALUES('5f06acf3-8123-4a78-b2e7-089b0b775a4a', 'MIR', 'Mirage', 'Expansion', 'September 1996', 'https://static.wikia.nocookie.net/mtg/images/e/e9/Mirage_Common.png/revision/latest?cb=20140409205232');
INSERT INTO [MtG].[AvailableSets] VALUES('2c32f1a9-7921-4826-bea0-80bbac70532c', 'VIS', 'Visions', 'Expansion', 'January 1997', 'https://static.wikia.nocookie.net/mtg/images/1/10/Visions_Common.png/revision/latest?cb=20140409204957');
INSERT INTO [MtG].[AvailableSets] VALUES('700997ac-add2-4ce2-992e-5efa0fdfc0e9', 'WTH', 'Weatherlight', 'Expansion', 'May 1997', 'https://static.wikia.nocookie.net/mtg/images/0/0e/Weatherlight_Common.png/revision/latest?cb=20140409204507');
INSERT INTO [MtG].[AvailableSets] VALUES('10df3a67-178e-4363-8668-34f0e6edf2a7', 'TMP', 'Tempest', 'Expansion', 'October 1997', 'https://static.wikia.nocookie.net/mtg/images/8/80/Tempest_Common.png/revision/latest?cb=20140409203807');
INSERT INTO [MtG].[AvailableSets] VALUES('5c83396a-d386-4367-926b-571a75b086a3', 'STH', 'Stronghold', 'Expansion', 'February 1998', 'https://static.wikia.nocookie.net/mtg/images/c/cf/Stronghold_Common.png/revision/latest?cb=20140409203253');
INSERT INTO [MtG].[AvailableSets] VALUES('1401f7af-2e71-476d-9813-991084ed0bb9', 'EXO', 'Exodus', 'Expansion', 'June 1998', 'https://static.wikia.nocookie.net/mtg/images/1/1e/Exodus_Common.png/revision/latest?cb=20140409202749');
INSERT INTO [MtG].[AvailableSets] VALUES('c330df40-51db-4caf-bde6-48df6c181001', 'USG', 'Urza''s Saga', 'Expansion', 'October 1998', 'https://static.wikia.nocookie.net/mtg/images/7/73/Urza%27s_Saga_Common.png/revision/latest?cb=20140409202442');
INSERT INTO [MtG].[AvailableSets] VALUES('78ced61b-4b8a-4b33-b6b2-f5bd66f1a75a', 'ULG', 'Urza''s Legacy', 'Expansion', 'February 1999', 'https://static.wikia.nocookie.net/mtg/images/7/7f/Urza%27s_Legacy_Common.png/revision/latest?cb=20140409200017');
INSERT INTO [MtG].[AvailableSets] VALUES('44f17b37-dcf8-4239-baab-1efc00cd3480', 'UDS', 'Urza''s Destiny', 'Expansion', 'May 1999', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Urzasdestinysymbol.svg/45px-Urzasdestinysymbol.svg.png');
INSERT INTO [MtG].[AvailableSets] VALUES('385e11a4-492b-4d07-b4a6-a1409ef829b8', 'MMQ', 'Mercadian Masques', 'Expansion', 'September 1999', 'https://static.wikia.nocookie.net/mtg/images/4/49/Mercadian_Masques_Common.png/revision/latest?cb=20140409184920');
INSERT INTO [MtG].[AvailableSets] VALUES('fa5d1fdb-f781-473d-b14d-50396d40d43f', 'NEM', 'Nemesis', 'Expansion', 'February 2000', 'https://static.wikia.nocookie.net/mtg/images/b/b5/Nemesis_Common.png/revision/latest?cb=20140409184627');
INSERT INTO [MtG].[AvailableSets] VALUES('c233bd36-57c0-4aa2-ae6c-7aeabfb4e3ce', 'PCY', 'Prophecy', 'Expansion', 'May 2000', 'https://static.wikia.nocookie.net/mtg/images/9/97/Prophecy_Common.png/revision/latest?cb=20140409184328');
INSERT INTO [MtG].[AvailableSets] VALUES('b9ae5e02-7726-47ca-b5e4-5ec402b41cd1', 'INV', 'Invasion', 'Expansion', 'September 2000', 'https://static.wikia.nocookie.net/mtg/images/9/9d/Invasion_Common.png/revision/latest?cb=20140409184112');
INSERT INTO [MtG].[AvailableSets] VALUES('82dc193b-bd5f-4883-a93f-a4155b467ee0', 'PLS', 'Planeshift', 'Expansion', 'January 2001', 'https://static.wikia.nocookie.net/mtg/images/3/3a/Planeshift_Common.png/revision/latest?cb=20140409183518');
INSERT INTO [MtG].[AvailableSets] VALUES('e4e00913-d08d-4899-86ea-5cf631e09ce0', 'APC', 'Apocalypse', 'Expansion', 'May 2001', 'https://static.wikia.nocookie.net/mtg/images/9/97/Apocalypse_Common.png/revision/latest?cb=20140409182524');
INSERT INTO [MtG].[AvailableSets] VALUES('b0d90d2d-494a-4224-bfa0-36ce5ee281b1', 'ODY', 'Odyssey', 'Expansion', 'September 2001', 'https://static.wikia.nocookie.net/mtg/images/6/65/Odyssey_Common.png/revision/latest?cb=20140409180936');
INSERT INTO [MtG].[AvailableSets] VALUES('e0b3fda1-a6ca-4996-849b-08b463d39484', 'TOR', 'Torment', 'Expansion', 'January 2002', 'https://static.wikia.nocookie.net/mtg/images/5/5e/Torment_Common.png/revision/latest?cb=20140409180514');
INSERT INTO [MtG].[AvailableSets] VALUES('cd82de1a-36fd-4618-bfe8-b45532a582d9', 'JUD', 'Judgement', 'Expansion', 'May 2002', 'https://static.wikia.nocookie.net/mtg/images/a/ae/Judgment_Common.png/revision/latest?cb=20140409180135');
INSERT INTO [MtG].[AvailableSets] VALUES('914a6c6d-cb3b-45e8-a2db-9978a2339faf', 'ONS', 'Onslaught', 'Expansion', 'September 2002', 'https://static.wikia.nocookie.net/mtg/images/1/13/Onslaught_Common.png/revision/latest?cb=20140408161826');
INSERT INTO [MtG].[AvailableSets] VALUES('c2d60a18-1a81-4784-8e0c-e1de2f43c5cf', 'LGN', 'Legions', 'Expansion', 'January 25', 'https://static.wikia.nocookie.net/mtg/images/c/cd/Legions_Common.png/revision/latest?cb=20140408161613');
INSERT INTO [MtG].[AvailableSets] VALUES('5133c3a1-1412-4ce6-a1f0-73b695966ded', 'SCG', 'Scourge', 'Expansion', 'May 2003', 'https://static.wikia.nocookie.net/mtg/images/e/e5/Scourge_Common.png/revision/latest?cb=20140408161342');
INSERT INTO [MtG].[AvailableSets] VALUES('1d4f90ba-8d4a-4ee5-bc2f-e2d6bffe4955', 'MRD', 'Mirrodin', 'Expansion', 'September 2003', 'https://static.wikia.nocookie.net/mtg/images/3/3e/Mirrodin_Common.png/revision/latest?cb=20140408033004');
INSERT INTO [MtG].[AvailableSets] VALUES('e29cb2dd-1345-4032-abfe-e52e8c8ce074', 'DST', 'Darksteel', 'Expansion', 'January 2004', 'https://static.wikia.nocookie.net/mtg/images/c/c7/Darksteel_Common.png/revision/latest?cb=20140408032740');
INSERT INTO [MtG].[AvailableSets] VALUES('e4bc1b87-5476-463c-8640-4c414ecf1763', '5DN', 'Fifth Dawn', 'Expansion', 'May 2004', 'https://static.wikia.nocookie.net/mtg/images/3/34/Fifth_Dawn_Common.png/revision/latest?cb=20140407033251');
INSERT INTO [MtG].[AvailableSets] VALUES('6183d21f-a0af-4118-ba58-aca1d8719c01', 'CHK', 'Champions of Kamigawa', 'Expansion', 'September 2004', 'https://static.wikia.nocookie.net/mtg/images/4/4a/Champions_of_Kamigawa_Common.png/revision/latest?cb=20140408032203');
INSERT INTO [MtG].[AvailableSets] VALUES('d4b88587-a1f5-4b47-9e24-78ec9e57bd0e', 'BOK', 'Betrayers of Kamigawa', 'Expansion', 'January 2005', 'https://static.wikia.nocookie.net/mtg/images/6/61/Betrayers_of_Kamigawa_Common.png/revision/latest?cb=20140408031923');
INSERT INTO [MtG].[AvailableSets] VALUES('4db16ad3-2b95-442f-bb6b-e9aa7fe7f769', 'SOK', 'Saviors of Kamigawa', 'Expansion', 'May 2005', 'https://static.wikia.nocookie.net/mtg/images/0/04/Saviors_of_Kamigawa_Common.png/revision/latest?cb=20140408031649');
INSERT INTO [MtG].[AvailableSets] VALUES('15fccbe8-2825-41ca-9d0a-67aebdf91c4a', 'RAV', 'Ravnica: City of Guilds', 'Expansion', 'September 2005', 'https://static.wikia.nocookie.net/mtg/images/d/d6/Ravnica_City_of_Guilds_Common.png/revision/latest?cb=20140408031444');
INSERT INTO [MtG].[AvailableSets] VALUES('594b4d09-8ce1-494d-bdb2-842c124bd087', 'GPT', 'Guildpact', 'Expansion', 'January 2006', 'https://static.wikia.nocookie.net/mtg/images/e/e1/Guildpact_Common.png/revision/latest?cb=20140408031058');
INSERT INTO [MtG].[AvailableSets] VALUES('fdebeda1-b95f-4343-8a94-d125821e6b5c', 'DIS', 'Dissension', 'Expansion', 'April 2006', 'https://static.wikia.nocookie.net/mtg/images/e/ea/Dissension_Common.png/revision/latest?cb=20140408030906');
INSERT INTO [MtG].[AvailableSets] VALUES('1f4f105f-73e4-4f03-849e-82a204807847', 'CSP', 'Coldsnap', 'Expansion', 'July 2006', 'https://static.wikia.nocookie.net/mtg/images/d/d5/Coldsnap_Common.png/revision/latest?cb=20140409205558');
INSERT INTO [MtG].[AvailableSets] VALUES('c1d109bc-ffd8-428f-8d7d-3f8d7e648046', 'TSP', 'Time Spiral', 'Expansion', 'September 2006', 'https://static.wikia.nocookie.net/mtg/images/b/b5/Time_Spiral_Common.png/revision/latest?cb=20140407215251');
INSERT INTO [MtG].[AvailableSets] VALUES('6519be58-b8cb-4cd7-9f5b-4db23364715b', 'TSB', 'Time Spiral Timeshifted', 'Expansion', 'September 2006', 'https://static.wikia.nocookie.net/mtg/images/b/b5/Time_Spiral_Common.png/revision/latest?cb=20140407215251');
INSERT INTO [MtG].[AvailableSets] VALUES('5a1b571c-73e9-4c14-b9d4-a62507d85789', 'PLC', 'Planar Chaos', 'Expansion', 'January 2007', 'https://static.wikia.nocookie.net/mtg/images/a/a3/Planar_Chaos_Common.png/revision/latest?cb=20140407215005');
INSERT INTO [MtG].[AvailableSets] VALUES('bf951ddb-4445-4923-87cb-3fe4ac3c6b9a', 'FUT', 'Future Sight', 'Expansion', 'April 2007', 'https://static.wikia.nocookie.net/mtg/images/9/91/Future_Sight_Common.png/revision/latest?cb=20140407214747');
INSERT INTO [MtG].[AvailableSets] VALUES('30ec97cb-dca9-4bf4-a98b-310f9d8ceaff', 'LRW', 'Lorwyn', 'Expansion', 'September 2007', 'https://static.wikia.nocookie.net/mtg/images/3/36/Lorwyn_Common.png/revision/latest?cb=20140406223811');
INSERT INTO [MtG].[AvailableSets] VALUES('c41550df-7b41-41a3-85ab-8612eb2f168f', 'MOR', 'Morningtide', 'Expansion', 'January 2008', 'https://static.wikia.nocookie.net/mtg/images/6/6c/Morningtide_Common.png/revision/latest?cb=20140407212636');
INSERT INTO [MtG].[AvailableSets] VALUES('c18c0ba1-2081-4808-9b2e-549bc3a666f3', 'SHM', 'Shadowmoor', 'Expansion', 'April 2008', 'https://static.wikia.nocookie.net/mtg/images/d/d3/Shadowmoor_Common.png/revision/latest?cb=20140407212150');
INSERT INTO [MtG].[AvailableSets] VALUES('86b4dfef-f2d1-49d6-825d-7df6bda44357', 'EVE', 'Eventide', 'Expansion', 'July 2008', 'https://static.wikia.nocookie.net/mtg/images/3/36/Eventide_Common.png/revision/latest?cb=20140407211416');
INSERT INTO [MtG].[AvailableSets] VALUES('d667aaec-09b7-4406-b6fa-60795132dc11', 'ALA', 'Shards of Alara', 'Expansion', 'September 2008', 'https://static.wikia.nocookie.net/mtg/images/5/50/Shards_of_Alara_Common.png/revision/latest?cb=20140407210726');
INSERT INTO [MtG].[AvailableSets] VALUES('76b2db58-904c-4e49-8580-9f62f7b3cca4', 'CON', 'Conflux', 'Expansion', 'January 2009', 'https://static.wikia.nocookie.net/mtg/images/4/44/Conflux_Common.png/revision/latest?cb=20140407210222');
INSERT INTO [MtG].[AvailableSets] VALUES('db486ec5-141d-4781-9ee5-5456926934c1', 'ARB', 'Alara Reborn', 'Expansion', 'April 2009', 'https://static.wikia.nocookie.net/mtg/images/c/c0/Alara_Reborn_Common.png/revision/latest?cb=20140407204705');
INSERT INTO [MtG].[AvailableSets] VALUES('eb16a2bd-a218-4e4e-8339-4aa1afc0c8d2', 'ZEN', 'Zendikar', 'Expansion', 'September 2009', 'https://static.wikia.nocookie.net/mtg/images/7/7c/Zendikar_Common.png/revision/latest?cb=20140407034419');
INSERT INTO [MtG].[AvailableSets] VALUES('2f248ce6-c2a5-4c6f-a2be-0c593fbe173c', 'WWK', 'Worldwake', 'Expansion', 'January 2010', 'https://static.wikia.nocookie.net/mtg/images/2/2d/Worldwake_Common.png/revision/latest?cb=20140407193027');
INSERT INTO [MtG].[AvailableSets] VALUES('eadb8a82-ec56-4623-b50e-42e7e60cb535', 'ROE', 'Rise of the Eldrazi', 'Expansion', 'April 2010', 'https://static.wikia.nocookie.net/mtg/images/5/55/Rise_of_the_Eldrazi_Common.png/revision/latest?cb=20160302193227');
INSERT INTO [MtG].[AvailableSets] VALUES('8f403072-9b22-4e69-8d59-22dc4c97fd8d', 'SOM', 'Scars of Mirrodin', 'Expansion', 'September 2010', 'https://static.wikia.nocookie.net/mtg/images/6/63/Scars_of_Mirrodin_Common.png/revision/latest?cb=20150526122935');
INSERT INTO [MtG].[AvailableSets] VALUES('f46c57e3-9301-4006-a6ca-06f3f65961fb', 'MBS', 'Mirrodin Besieged', 'Expansion', 'January 2011', 'https://static.wikia.nocookie.net/mtg/images/8/8b/Mirrodin_Besieged_Common.png/revision/latest?cb=20140407164539');
INSERT INTO [MtG].[AvailableSets] VALUES('e8e356d8-6d01-4dab-aa07-d0999dc9359f', 'NPH', 'New Phyrexia', 'Expansion', 'May 2011', 'https://static.wikia.nocookie.net/mtg/images/9/9c/New_Phyrexia_Common.png/revision/latest?cb=20140407164007');
INSERT INTO [MtG].[AvailableSets] VALUES('84ff1a64-4e69-4ed2-8c08-26206e3b97a0', 'CMD', 'Commander 2011', 'Commander', 'June 2011', 'https://static.wikia.nocookie.net/mtg/images/d/d8/Commander_Common.png/revision/latest?cb=20140409233047');
INSERT INTO [MtG].[AvailableSets] VALUES('d1026945-2969-42b9-be53-f941405a58cb', 'ISD', 'Innistrad', 'Expansion', 'September 2011', 'https://static.wikia.nocookie.net/mtg/images/b/b3/Innistrad_Common.png/revision/latest?cb=20140407163614');
INSERT INTO [MtG].[AvailableSets] VALUES('8052750a-aaf2-46fc-b46d-633f14124017', 'DKA', 'Dark Ascension', 'Expansion', 'January 2012', 'https://static.wikia.nocookie.net/mtg/images/0/00/Dark_Ascension_Common.png/revision/latest?cb=20140407163148');
INSERT INTO [MtG].[AvailableSets] VALUES('039810a9-92d7-4f2d-b2d0-ca661ac586c0', 'AVR', 'Avacyn Restored', 'Expansion', 'April 2012', 'https://static.wikia.nocookie.net/mtg/images/d/dc/Avacyn_Restored_Common.png/revision/latest?cb=20140406031034');
INSERT INTO [MtG].[AvailableSets] VALUES('80b2374d-c5f1-403e-9772-f6c806fd275e', 'RTR', 'Return to Ravnica', 'Expansion', 'September 2012', 'https://static.wikia.nocookie.net/mtg/images/4/45/Return_to_Ravnica_Common.png/revision/latest?cb=20140407162321');
INSERT INTO [MtG].[AvailableSets] VALUES('035a05f7-e020-4f50-a141-ed16ba704bd2', 'GTC', 'Gatecrash', 'Expansion', 'January 2013', 'https://static.wikia.nocookie.net/mtg/images/6/64/Gatecrash_Common.png/revision/latest?cb=20140406202249');
INSERT INTO [MtG].[AvailableSets] VALUES('c8bd8520-cd98-45cd-b533-8d40c2087426', 'DGM', 'Dragon''s Maze', 'Expansion', 'April 2013', 'https://static.wikia.nocookie.net/mtg/images/3/3d/Dragon%27s_Maze_Common.png/revision/latest?cb=20140407161354');
INSERT INTO [MtG].[AvailableSets] VALUES('69093d6f-e25a-41a4-8cf5-688d7f11c0fb', 'THS', 'Theros', 'Expansion', 'September 2013', 'https://static.wikia.nocookie.net/mtg/images/7/73/Theros_Common.png/revision/latest?cb=20140407161028');
INSERT INTO [MtG].[AvailableSets] VALUES('c62e6d4f-af8c-4f27-9bc8-361291890146', 'C13', 'Commander 2013', 'Commander', 'November 2013', 'https://static.wikia.nocookie.net/mtg/images/9/95/Commander_2013_Common.png/revision/latest?cb=20171223185309');
INSERT INTO [MtG].[AvailableSets] VALUES('0980a6e2-eb78-4ad2-8396-cef08fce365e', 'C14', 'Commander 2014', 'Commander', 'Missing', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('ea6c99f9-5489-4504-b30c-c819fa3b1fd3', 'C15', 'Commander 2015', 'Commander', 'Missing', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('3e0d713a-b5cb-4287-81b9-a57d4dcaf415', 'C16', 'Commander 2016', 'Commander', 'Missing', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('5caec427-0c78-4c37-b4ec-30f7e0ba9abf', 'C17', 'Commander 2017', 'Commander', 'Missing', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('', 'C18', 'Commander 2018', 'Expansion', 'August 2018', 'https://static.wikia.nocookie.net/mtg/images/d/dc/Commander_2018_Common.png/revision/latest?cb=20180928172435');
INSERT INTO [MtG].[AvailableSets] VALUES('0fa3ccbb-d86d-4a2e-a55e-c4979c4feeb2', 'C19', 'Commander 2019', 'Commander', 'Missing', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('f60ec786-1f8d-42f7-9abc-0d880fe243f6', 'C20', 'Commander 2020', 'Commander', 'Missing', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('27bf6dbd-a9e1-4904-afa7-d28fc7745c4f', 'C21', 'Commander 2021', 'Commander', 'Missing', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('50a80fe4-a757-408f-ad23-52c5cc5f45cc', 'BNG', 'Born of the Gods', 'Expansion', 'February 2014', 'https://static.wikia.nocookie.net/mtg/images/7/73/Born_of_the_Gods_Common.png/revision/latest?cb=20140407160557');
INSERT INTO [MtG].[AvailableSets] VALUES('204d2dca-1887-4721-9558-164aa7bbeb4f', 'JOU', 'Journey into Nyx', 'Expansion', 'April 2014', 'https://static.wikia.nocookie.net/mtg/images/6/60/Journey_into_Nyx_Common.png/revision/latest?cb=20160405212135');
INSERT INTO [MtG].[AvailableSets] VALUES('7d4ebb59-a50b-45b8-8fff-ab70767819a5', 'CNS', 'Conspiracy', 'Draft Innovation', 'June 2014', 'https://static.wikia.nocookie.net/mtg/images/1/18/Conspiracy_Common.png/revision/latest?cb=20141010175821');
INSERT INTO [MtG].[AvailableSets] VALUES('6c7a715c-ded9-449e-89b0-c665773e9c3c', 'KTK', 'Khans of Tarkir', 'Expansion', 'September 2014', 'https://static.wikia.nocookie.net/mtg/images/6/66/Khans_of_Tarkir_Common.png/revision/latest?cb=20160324201642');
INSERT INTO [MtG].[AvailableSets] VALUES('7bb5cb2b-081a-4c8c-b7e1-494046e6baa1', 'FRF', 'Fate Reforged', 'Expansion', 'January 2015', 'https://static.wikia.nocookie.net/mtg/images/8/8f/Fate_Reforged_Common.png/revision/latest?cb=20160303213116');
INSERT INTO [MtG].[AvailableSets] VALUES('7e72625f-f320-4552-a719-d11e2f1853bd', 'DTK', 'Dragons of Tarkir', 'Expansion', 'March 2015', 'https://static.wikia.nocookie.net/mtg/images/8/82/Dragons_of_Tarkir_Common.png/revision/latest?cb=20160304223647');
INSERT INTO [MtG].[AvailableSets] VALUES('91719374-7ac5-4afa-ada8-5da964dcf1d4', 'BFZ', 'Battle for Zendikar', 'Expansion', 'September 2015', 'https://static.wikia.nocookie.net/mtg/images/d/dd/Battle_for_Zendikar_Common.png/revision/latest?cb=20160229220649');
INSERT INTO [MtG].[AvailableSets] VALUES('cd51d245-8f95-45b0-ab5f-e2b3a3eb5dfe', 'OGW', 'Oath of the Gatewatch', 'Expansion', 'January 2016', 'https://static.wikia.nocookie.net/mtg/images/8/8e/Oath_of_the_Gatewatch_Common.png/revision/latest?cb=20160220212413');
INSERT INTO [MtG].[AvailableSets] VALUES('5e914d7e-c1e9-446c-a33d-d093c02b2743', 'SOI', 'Shadows over Innistrad', 'Expansion', 'April 2016', 'https://static.wikia.nocookie.net/mtg/images/5/5b/Shadows_over_Innistrad_Common.png/revision/latest?cb=20160402193205');
INSERT INTO [MtG].[AvailableSets] VALUES('5f0e4093-334f-4439-bbb5-a0affafd0ffc', 'EMN', 'Eldritch Moon', 'Expansion', 'July 2016', 'https://static.wikia.nocookie.net/mtg/images/e/e6/Eldritch_Moon_Common.png/revision/latest?cb=20160713093604');
INSERT INTO [MtG].[AvailableSets] VALUES('d667e468-be8f-411f-a030-473d148deb74', 'KLD', 'Kaladesh', 'Expansion', 'September 2016', 'https://static.wikia.nocookie.net/mtg/images/2/2c/Kaladesh_Common.png/revision/latest?cb=20160924132316');
INSERT INTO [MtG].[AvailableSets] VALUES('a4a0db50-8826-4e73-833c-3fd934375f96', 'AER', 'Aether Revolt', 'Expansion', 'January 2017', 'https://static.wikia.nocookie.net/mtg/images/f/f1/Aether_Revolt_Common.png/revision/latest?cb=20171222195121');
INSERT INTO [MtG].[AvailableSets] VALUES('02d1c536-68bc-4208-9b65-7741ef1f9da8', 'AKH', 'Amonkhet', 'Expansion', 'April 2017', 'https://static.wikia.nocookie.net/mtg/images/e/ea/Amonkhet_Common.png/revision/latest?cb=20171222195123');
INSERT INTO [MtG].[AvailableSets] VALUES('65ff168b-bb94-47a5-a8f9-4ec6c213e768', 'HOU', 'Hour of Devastation', 'Expansion', 'July 2017', 'https://static.wikia.nocookie.net/mtg/images/8/8d/Hour_of_Devastation_Common.png/revision/latest?cb=20171222195125');
INSERT INTO [MtG].[AvailableSets] VALUES('fe0dad85-54bc-4151-9200-d68da84dd0f2', 'XLN', 'Ixalan', 'Expansion', 'September 2017', 'https://static.wikia.nocookie.net/mtg/images/d/da/Ixalan_Common.png/revision/latest?cb=20171222195127');
INSERT INTO [MtG].[AvailableSets] VALUES('2f7e40fc-772d-4a85-bfdd-01653c41d0fa', 'RIX', 'Rivals of Ixalan', 'Expansion', 'January 2018', 'https://static.wikia.nocookie.net/mtg/images/a/a5/Rivals_of_Ixalan_Common.png/revision/latest?cb=20180117154025');
INSERT INTO [MtG].[AvailableSets] VALUES('be1daba3-51c9-4e7e-9212-36e68addc26c', 'DOM', 'Dominaria', 'Expansion', 'April 2018', 'https://static.wikia.nocookie.net/mtg/images/7/79/Dominara_Common.png/revision/latest?cb=20180526165445');
INSERT INTO [MtG].[AvailableSets] VALUES('fd4d8463-0156-4c60-a40e-778762bb90e4', 'CMA', 'Commander Anthology', 'Commander', 'Missing', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('bf95efbe-b991-4f7c-b9e9-04f0bc59969a', 'CM1', 'Commander''s Arsenal', 'Arsenal', 'Missing', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('2ba5b1a3-40ed-422e-981d-56753004dfc6', 'CM2', 'Commander Anthology Volume II', 'Commander', 'June 2018', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('95f97fbc-58ef-4645-982e-43e2db6f1124', 'BBD', 'Battlebond', 'Draft Innovation', 'June 2018', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('597c6d4a-8212-4903-a6af-12c4ae9e13f0', 'GRN', 'Guilds of Ravnica', 'Expansion', 'September 2018', 'https://static.wikia.nocookie.net/mtg/images/e/e0/Guilds_of_Ravnica_Common.png/revision/latest?cb=20180923183815');
INSERT INTO [MtG].[AvailableSets] VALUES('97a7fd84-8d89-45a3-b48b-c951f6a3f9f1', 'RNA', 'Ravnica Allegiance', 'Expansion', 'January 2019', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('ee044f0b-e101-4ead-8d0e-aa510aad4277', 'WAR', 'War of the Spark', 'Expansion', 'April 2019', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('a90a7b2f-9dd8-4fc7-9f7d-8ea2797ec782', 'ELD', 'Throne of Eldraine', 'Expansion', 'September 2019', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('5f23a78d-cda1-462a-8be3-a62b40c34913', 'THB', 'Theros Beyond Death', 'Expansion', 'January 2020', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('19feda43-15ab-427e-a0e4-148a4bf2b03a', 'IKO', 'Ikoria: Lair of Behemoths', 'Expansion', 'April 2020', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('f4e01fa7-b254-42dd-849f-69b58027a8c4', 'ZNR', 'Zendikar Rising', 'Expansion', 'September 2020', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('43057fad-b1c1-437f-bc48-0045bce6d8c9', 'KHM', 'Kaldheim', 'Expansion', 'January 2021', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('541c3c28-8747-40e5-a231-8e8f33234859', 'STX', 'Strixhaven: School of Mages', 'Expansion', 'April 2021', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('e1ef87ba-ba92-4573-817f-543b996d2851', 'AFR', 'Dungeons & Dragons: Adventures in the Forgotten Realms', 'Expansion', 'July 2021', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('44b8eb8f-fa23-401a-98b5-1fbb9871128e', 'MID', 'Innistrad: Midnight Hunt', 'Expansion', 'September 2021', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('8144b676-569f-4716-8005-bc8f0778f3fa', 'VOW', 'Innistrad: Crimson Vow', 'Expansion', 'November 2021', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('59a2059f-5482-433f-8761-eb2e17859b71', 'NEO', 'Kamigawa: Neon Dynasty', 'Expansion', 'February 2022', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('df837242-8c15-42e4-b049-c933a02dc501', 'SNC', 'Streets of New Capenna', 'Expansion', 'April 2022', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('4e47a6cd-cdeb-4b0f-8f24-cfe1a0127cb3', 'DMU', 'Dominaria United', 'Expansion', 'September 2022', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('4219a14e-6701-4ddd-a185-21dc054ab19b', 'BRO', 'The Brothers'' War', 'Expansion', 'November 2022', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('04bef644-343f-4230-95ee-255f29aa67a2', 'ONE', 'Phyrexia: All Will Be One', 'Expansion', 'February 2023', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('392f7315-dc53-40a3-a2cc-5482dbd498b3', 'MOM', 'March of the Machine', 'Expansion', 'April 2023', 'Missing');*/
/*INSERT INTO [MtG].[AvailableSets] VALUES('', 'MAT', 'March of the Machine: The Aftermath', '', '', '');
INSERT INTO [MtG].[AvailableSets] VALUES('', 'WOE', 'Wilds of Eldraine', '', '', '');
INSERT INTO [MtG].[AvailableSets] VALUES('', 'Expansion', 'The Lost Caverns of Ixalan', '', '', '');*/

/* Available Sets - Non-Rotation Sets */
/*INSERT INTO [MtG].[AvailableSets] VALUES('d7efccd6-55bc-4fb8-9138-e72577510a99', 'MH1', 'Modern Horizons', 'Draft Innovation', 'June 2019', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('c1c7eb8c-f205-40ab-a609-767cb296544e', 'MH2', 'Modern Horizons 2', 'Draft Innovation', 'June 2021', 'Missing');*/

/* Available Sets - Introductory Sets */
/*INSERT INTO [MtG].[AvailableSets] VALUES('478c47df-5058-4ce6-830e-7e80732b2ca9', 'POR', 'Portal', 'Starter', 'June 1997', 'https://static.wikia.nocookie.net/mtg/images/f/f3/Exp_sym_portal.png/revision/latest?cb=20070515214652');
INSERT INTO [MtG].[AvailableSets] VALUES('ac67f18a-4f0e-407e-bab1-a9fe4f659565', 'P02', 'Portal Second Age', 'Starter', 'June 1998', 'https://static.wikia.nocookie.net/mtg/images/5/5f/Exp_sym_portalsecondage.png/revision/latest?cb=20070515214630');
INSERT INTO [MtG].[AvailableSets] VALUES('2676ff2e-9d86-4b5b-b935-e84e41b0755e', 'P3K', 'Portal Three Kingdoms', 'Starter', 'May 1999', 'https://static.wikia.nocookie.net/mtg/images/d/db/Exp_sym_portalthreekingdoms.png/revision/latest?cb=20070515214548');
INSERT INTO [MtG].[AvailableSets] VALUES('7e345c51-7a88-4c7a-8184-4e1ba493b40d', 'S99', 'Starter 1999', 'Starter', 'July 1999', 'https://static.wikia.nocookie.net/mtg/images/e/ee/Exp_sym_starter1999.png/revision/latest?cb=20070515214902');
INSERT INTO [MtG].[AvailableSets] VALUES('1c105623-2564-40d7-a3aa-4134787fb127', 'S00', 'Starter 2000', 'Starter', 'July 2000', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('19c285e9-68e0-45e1-b82b-ac6051eb43be', 'GS1', 'Global Series: Kiang Yanggu & Mu Yanling', 'Duel Deck', 'June 2018', 'Missing');*/

/* Available Sets - Compilation/Reprint Sets */
/*INSERT INTO [MtG].[AvailableSets] VALUES('985eab7d-655a-4cb0-ba74-d48c8dcfb3d4', 'CHR', 'Chronicles', 'Masters', 'July 1995', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('49c9409d-5948-4c00-bd0a-bf3ebd50e23a', 'ATH', 'Anthologies', 'Box', 'November 1996', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('81118b2a-b5c8-4fdc-830a-ce5b74eb60b9', 'BRB', 'Battle Royale Box Set', 'Box', 'November 1998', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('cdc88d15-c4de-4210-a7e4-dcc366de845f', 'BTD', 'Beatdown Box Set', 'Box', 'October 2000', 'https://static.wikia.nocookie.net/mtg/images/e/e7/Beatdown_Box_Set_Common.png/revision/latest?cb=20140411154344');
INSERT INTO [MtG].[AvailableSets] VALUES('cfcec75d-481b-4b24-bcaa-a7185cf32e15', 'DKM', 'Deckmasters', 'Box', 'December 2001', 'https://static.wikia.nocookie.net/mtg/images/9/95/Exp_sym_deckmasters.gif/revision/latest?cb=20070830152350');
INSERT INTO [MtG].[AvailableSets] VALUES('491666a2-3de4-4214-8238-2dad9dfb5a7a', 'DPA', 'Duels of the Planeswalkers', 'Box', 'June 2010', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('3c31de17-6766-448e-a4eb-878d83031f3e', 'MD1', 'Modern Event Deck 2014', 'Box', 'May 2014', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('d13bfc70-6137-4179-aa96-da30fd84de29', 'MB1', 'Mystery Booster', 'Masters', 'March 2020', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('11e90d1b-0502-43e6-b056-e24836523c13', 'TSR', 'Time Spiral Remastered', 'Masters', 'March 2021', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('ca4c2884-e539-4b7f-980d-5d6a50220f2a', 'DMR', 'Dominaria Remastered', 'Masters', 'January 2023', 'Missing');*/

/* Available Sets - Duel Decks */
/*INSERT INTO [MtG].[AvailableSets] VALUES('d5dbdea8-45f6-4d22-990b-6b6897f99d18', 'EVG', 'Duel Decks: Elves vs. Goblins', 'Duel Deck', 'November 2007', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('7161cc1c-adbd-479c-9125-df4c40b0e3ad', 'DD2', 'Duel Decks: Jace vs. Chandra', 'Duel Deck', 'November 2008', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('4a1b5533-e4a3-456e-9fb1-53e754402c23', 'DDC', 'Duel Decks: Divine vs. Demonic', 'Duel Deck', 'April 2009', 'https://static.wikia.nocookie.net/mtg/images/1/18/Duel_Decks_Divine_vs._Demonic_Common.png/revision/latest?cb=20140411011611');
INSERT INTO [MtG].[AvailableSets] VALUES('15f41db6-1810-475b-bf2c-24a488050a37', 'DDD', 'Duel Decks: Garruk vs. Liliana', 'Duel Deck', 'October 2009', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('bf561626-56ca-4eb0-a2de-b84dbe7874f8', 'DDE', 'Duel Decks: Phyrexia vs. the Coalition', 'Duel Deck', 'March 2010', 'https://static.wikia.nocookie.net/mtg/images/c/ce/Duel_Decks_Phyrexia_vs._the_Coalition_Common.png/revision/latest?cb=20140411012330');
INSERT INTO [MtG].[AvailableSets] VALUES('2a5a88d5-e2ac-4252-bc4e-62654b1f9a46', 'DDF', 'Duel Decks: Elspeth vs. Tezzeret', 'Duel Deck', 'September 2010', 'https://static.wikia.nocookie.net/mtg/images/3/3c/Duel_Decks_Elspeth_vs._Tezzeret_Common.png/revision/latest?cb=20140411012755');
INSERT INTO [MtG].[AvailableSets] VALUES('cf842e69-7a05-48e2-adac-fd177087caf5', 'DDG', 'Duel Decks: Knights vs. Dragons', 'Duel Deck', 'April 2011', 'https://static.wikia.nocookie.net/mtg/images/7/73/Duel_Decks_Knights_vs._Dragons_Common.png/revision/latest?cb=20140411014016');
INSERT INTO [MtG].[AvailableSets] VALUES('bad1fe7e-27df-4999-821b-d477c2ec658d', 'DDH', 'Duel Decks: Ajani vs. Nicol Bolas', 'Duel Deck', 'September 2011', 'https://static.wikia.nocookie.net/mtg/images/3/34/Duel_Decks_Ajani_vs._Nicol_Bolas_Common.png/revision/latest?cb=20140410172633');
INSERT INTO [MtG].[AvailableSets] VALUES('a29e8ace-bbcd-4507-b159-7ec77d28f792', 'DDI', 'Duel Decks: Venser vs. Koth', 'Duel Deck', 'March 2012', 'https://static.wikia.nocookie.net/mtg/images/a/ae/Duel_Decks_Venser_vs._Koth_Common.png/revision/latest?cb=20140411020024');
INSERT INTO [MtG].[AvailableSets] VALUES('2dfea68b-b0c4-4f63-ba6c-36c9a6e3030f', 'DDJ', 'Duel Decks: Izzet vs. Golgari', 'Duel Deck', 'September 2012', 'https://static.wikia.nocookie.net/mtg/images/5/59/Duel_Decks_Izzet_vs._Golgari_Common.png/revision/latest?cb=20140411020410');
INSERT INTO [MtG].[AvailableSets] VALUES('529a5259-8a88-4baf-86a0-cd88098c3ce7', 'DDK', 'Duel Decks: Sorin vs. Tibalt', 'Duel Deck', 'March 2013', 'https://static.wikia.nocookie.net/mtg/images/1/19/Duel_Decks_Sorin_vs._Tibalt_Common.png/revision/latest?cb=20140406023912');
INSERT INTO [MtG].[AvailableSets] VALUES('7dfc5406-c4cf-479d-b005-11e578752dc9', 'DDL', 'Duel Decks: Heros vs. Monsters', 'Duel Deck', 'September 2013', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('a80b4ba1-7485-4c16-b745-eeea904863c3', 'DDM', 'Duel Decks: Jace vs. Vraska', 'Duel Deck', 'March 2014', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('163844e5-077e-4e2c-a0f0-fa33fbc7bb3b', 'DDN', 'Duel Decks: Speed vs. Cunning', 'Duel Deck', 'September 2014', 'Missing');*/
/*INSERT INTO [MtG].[AvailableSets] VALUES('', 'DD3', 'Duel Decks Anthology', 'Duel Deck', 'December 2014', 'Missing');*/
/*INSERT INTO [MtG].[AvailableSets] VALUES('6b350326-34f3-43c6-8df5-2b1d9a61ceff', 'DDO', 'Duel Decks: Elspeth vs. Kiora', 'Duel Deck', 'February 2015', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('0dbc7609-b12c-471a-bfd3-c57bc670c445', 'DDP', 'Duel Decks: Zendikar vs. Eldrazi', 'Duel Deck', 'August 2015', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('9f6e1af2-3913-47d6-aa6a-81f34ec7224c', 'DDQ', 'Duel Decks: Blessed vs. Cursed', 'Duel Deck', 'February 2016', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('20e10d8d-c2b0-4d3f-942d-28ae9e137c6e', 'DDR', 'Duel Decks: Nissa vs. Ob Nixilis', 'Duel Deck', 'September 2016', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('758fe4d1-ce2b-4106-8cec-820841d730af', 'DDS', 'Duel Decks: Mind vs. Might', 'Duel Deck', 'March 2017', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('c77df674-0ef5-47d9-ab22-56a6e1dc901c', 'DDT', 'Duel Decks: Merfolk vs. Goblins', 'Duel Deck', 'November 2017', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('01e30e53-f292-4c39-ab09-435b015877f5', 'DDU', 'Duel Decks: Elves vs. Inventors', 'Duel Deck', 'April 2018', 'Missing');*/

/* Available Sets - From the Vault */
/*INSERT INTO [MtG].[AvailableSets] VALUES('c1cec8aa-5906-41d9-ae01-cbdde2e776fb', 'DRB', 'From the Vault: Dragons', 'From the Vault', 'August 2008', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('6254693f-c620-4e47-8bab-01085f8c3ffb', 'V09', 'From the Vault: Exiled', 'From the Vault', 'August 2009', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('3e3ea3e8-3d63-481f-b3ec-03c4f50b602e', 'V10', 'From the Vault: Relics', 'From the Vault', 'August 2010', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('b83c0908-ae67-47eb-9099-7a1791ada84a', 'V11', 'From the Vault: Legends', 'From the Vault', 'August 2011', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('b9259658-67bf-451b-b78b-f5545129e9bd', 'V12', 'From the Vault: Realms', 'From the Vault', 'August 2012', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('815577c6-652f-4171-8298-c1063c5bced1', 'V13', 'From the Vault: Twenty', 'From the Vault', 'August 2013', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('21dd7ae2-1196-46d4-9acf-4ff9d82797be', 'V14', 'From the Vault: Annihilation', 'From the Vault', 'August 2014', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('bd5cb4e5-8090-4bd9-bcd4-89741056689b', 'V15', 'From the Vault: Angels', 'From the Vault', 'August 2015', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('599b33cd-678b-4149-9e68-2a59da7d7f81', 'V16', 'From the Vault: Lore', 'From the Vault', 'August 2016', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('63c89a12-d115-4084-a4af-fceef40ca02f', 'V17', 'From the Vault: Transform', 'From the Vault', 'November 2017', 'Missing');*/

/* Available Sets - Signature Spellbook */
/*INSERT INTO [MtG].[AvailableSets] VALUES('a24031db-1378-420f-b671-bcaec52d6f6c', 'SS1', 'Signature Spellbook: Jace', 'Spellbook', 'June 2018', 'https://static.wikia.nocookie.net/mtg/images/8/85/Signature_Spellbook_Jace_Rare.png/revision/latest?cb=20181020194739');
INSERT INTO [MtG].[AvailableSets] VALUES('9ae53f04-9cbb-45db-8b5c-972fe847a984', 'SS2', 'Signature Spellbook: Gideon', 'Spellbook', 'June 2019', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('4887d21f-71e7-4d7a-a079-e9521fd7e6d7', 'SS3', 'Signature Spellbook: Chandra', 'Spellbook', 'June 2020', 'Missing');*/

/* Available Sets - Premium Deck Series */
/*INSERT INTO [MtG].[AvailableSets] VALUES('3a045e59-64b5-465d-9dbd-f4ddadf8f4dc', 'H09', 'Premium Deck Series: Slivers', 'Premium Deck', 'November 2009', 'https://static.wikia.nocookie.net/mtg/images/d/d5/Premium_Deck_Series_Slivers_Common.png/revision/latest?cb=20140411152459');
INSERT INTO [MtG].[AvailableSets] VALUES('e0d91aba-be11-4ddd-96a4-4753e708458a', 'PD2', 'Premium Deck Series: Fire and Lightning', 'Premium Deck', 'November 2010', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('b6d6ba83-3b91-4203-8103-320cfa50f848', 'PD3', 'Premium Deck Series: Graveborn', 'Premium Deck', 'November 2011', 'Missing');*/

/* Available Sets - Masters Series */
/*INSERT INTO [MtG].[AvailableSets] VALUES('0b7020f2-336d-4706-9ce6-f6710b9ebd5c', 'MMA', 'Modern Masters', 'Masters', 'June 2013', 'https://static.wikia.nocookie.net/mtg/images/c/c3/Modern_Masters_Common.png/revision/latest?cb=20171230083728');
INSERT INTO [MtG].[AvailableSets] VALUES('28cac015-43df-4e88-90d0-95dcdd894834', 'MM2', 'Modern Masters 2015', 'Masters', 'May 2015', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('1f29f022-3ace-4c96-85e8-1f7b63aadf7e', 'EMA', 'Eternal Masters', 'Masters', 'June 2016', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('02624962-f727-4c31-bbf2-a94fa6c5b653', 'MM3', 'Modern Masters 2017', 'Masters', 'March 2017', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('741bcd30-7709-4133-8919-f4b46483bed7', 'IMA', 'Iconic Masters', 'Masters', 'November 2017', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('41ee6e2f-69b3-4c53-8a8e-960f5e974cfc', 'A25', 'Masters 25', 'Masters', 'March 2018', 'https://static.wikia.nocookie.net/mtg/images/8/8f/Masters_25_Common.png/revision/latest?cb=20180310161731');
INSERT INTO [MtG].[AvailableSets] VALUES('2ec77b94-6d47-4891-a480-5d0b4e5c9372', 'UMA', 'Ultimate Masters', 'Masters', 'December 2018', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('372dafe8-b5d1-4b81-998f-3ae96b59498a', '2XM', 'Double Masters', 'Masters', 'August 2020', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('5a645837-b050-449f-ac90-1e7ccbf45031', '2X2', 'Double Masters 2022', 'Masters', 'July 2022', 'Missing');*/

/* Available Sets - Deck Builder's Toolkits */
/*INSERT INTO [MtG].[AvailableSets] VALUES('', 'W10', 'Deck Builder''s Toolkit', 'Expansion', 'May 2010', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('', 'W11', 'Deck Builder''s Toolkit (Refreshed Edition)', 'Expansion', 'March 2011', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('', 'W12', 'Deck Builder''s Toolkit (2012 Edition)', 'Expansion', 'July 2012', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('', 'W14', 'Deck Builder''s Toolkit (2014 Core Set Edition)', 'Expansion', 'July 2013', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('', 'W15', 'Deck Builder''s Toolkit (2015 Core Set Edition)', 'Expansion', 'July 2014', 'Missing');*/
/*INSERT INTO [MtG].[AvailableSets] VALUES('', 'ORI', 'Deck Builder''s Toolkit (Magic Origins Edition)', '', 'July 2015', 'Missing');*/
/*INSERT INTO [MtG].[AvailableSets] VALUES('', 'W16', 'Deck Builder''s Toolkit (Shadows over Innistrad Edition)', 'Expansion', 'April 2016', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('', 'W17', 'Deck Builder''s Toolkit (Amonkhet Edition)', 'Expansion', 'April 2017', 'Missing');*/
/*INSERT INTO [MtG].[AvailableSets] VALUES('', '', 'Deck Builder''s Toolkit (Ixalan Edition)', '', 'September 2017', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('', '', 'Deck Builder''s Toolkit (Core 2019 Edition)', 'Expansion', 'July 2018', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('', '', 'Deck Builder''s Toolkit (Ravnica Allegiance Edition)', '', 'January 2019', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('', '', 'Deck Builder''s Toolkit (Core Set 2020 Edition)', '', 'July 2019', 'Missing');
INSERT INTO [MtG].[AvailableSets] VALUES('', '', 'Deck Builder''s Toolkit (Theros Beyond Death Edition)', '', 'January 2020', 'Missing');*/

COMMIT TRANSACTION;
COMMIT;