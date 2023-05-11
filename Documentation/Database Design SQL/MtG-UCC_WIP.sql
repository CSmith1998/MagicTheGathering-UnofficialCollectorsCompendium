SET IMPLICIT_TRANSACTIONS ON
SET XACT_ABORT ON
BEGIN TRANSACTION

CREATE TABLE [User].[Access] (
    ID VARCHAR(45), 
    AccessType VARCHAR(256),
    IP VARCHAR(36),
    Time DATETIME,
    CONSTRAINT CPK_UserAccess PRIMARY KEY (ID, Time)
);

CREATE TABLE [MtG].[AvailableSets] (
    SetCode VARCHAR(10) PRIMARY KEY,
    SetName VARCHAR(100),
    SetType VARCHAR(25),
    SetURL VARCHAR(250)
);

CREATE TABLE [MtG].[Card] (
    ID VARCHAR(36) PRIMARY KEY,
    Name VARCHAR(141) NOT NULL,
    ReleasedAt DATE NOT NULL,
    Layout VARCHAR(25) NOT NULL DEFAULT('Normal'),
    ConvertedManaCost DECIMAL(3,1) NOT NULL,
    TypeLine VARCHAR(150) NOT NULL,
    Reserved NCHAR(1) NOT NULL DEFAULT('N'),
    Foil NCHAR(1) NOT NULL DEFAULT('N'),
    Nonfoil NCHAR(1) NOT NULL DEFAULT('Y'),
    Oversized NCHAR(1) NOT NULL DEFAULT('N'),
    Promo NCHAR(1) NOT NULL DEFAULT('N'),
    Reprint NCHAR(1) NOT NULL DEFAULT('N'),
    SetCode VARCHAR(10) NOT NULL,
    SetName VARCHAR(100) NOT NULL,
    RulingsURL VARCHAR(250) NOT NULL,
    Rarity VARCHAR(12) NOT NULL DEFAULT('Common'),
    Artist VARCHAR(100) NOT NULL,
    FullArt NCHAR(1) NOT NULL DEFAULT('N'),
    Textless NCHAR(1) NOT NULL DEFAULT('N'),
);

CREATE TABLE [MtG].[Face] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    FaceName VARCHAR(141) NOT NULL,
    ManaCost VARCHAR(125) NOT NULL,
    CONSTRAINT CPK_FaceID PRIMARY KEY (CardID, FaceName)
);

CREATE TABLE [MtG].[AvailableGrades] (
    GradeID VARCHAR(12) PRIMARY KEY,
    Type VARCHAR(10) NOT NULL,
    Name VARCHAR(20) NOT NULL,
    Description VARCHAR(MAX)
);

CREATE TABLE [User].[Compendium] (
    ID VARCHAR(MAX),
    CardName VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](Name),
    TotalQty INT /* AS GetUserCardTotal(ID, CardName),  Computed Column */
    CONSTRAINT CPK_UserCompendium PRIMARY KEY (ID, CardName)
);

CREATE TABLE [User].[Collection] (
    CompendiumID VARCHAR(MAX),
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID),
    Condition VARCHAR(12) FOREIGN KEY REFERENCES [MtG].[AvailableGrades](GradeID) DEFAULT('Unknown') NOT NULL,
    StorageLocation VARCHAR(250) DEFAULT('Undefined') NOT NULL,
    Quantity INT DEFAULT(1) NOT NULL,
    CONSTRAINT CPK_UserCollection PRIMARY KEY (CompendiumID, CardID, Condition, StorageLocation)
);

CREATE TABLE [User].[Details] (
    AccountID NVARCHAR(450) PRIMARY KEY,
    CompendiumID VARCHAR(MAX) FOREIGN KEY REFERENCES [User].[Compendium](ID), /* Handled by Trigger */
    AccessID VARCHAR(45) FOREIGN KEY REFERENCES [User].[Access](ID), /* Handled by Trigger */
    CONSTRAINT FK_DetailsAccountID FOREIGN KEY REFERENCES [Admin].[AspNetUsers](Id)
);

CREATE TABLE [MtG].[AvailableColors] (
    ColorID CHAR(1) PRIMARY KEY,
    ColorName VARCHAR(5) UNIQUE NOT NULL,
    LandName VARCHAR(8) UNIQUE NOT NULL
);

CREATE TABLE [MtG].[Colors] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    FaceName VARCHAR(141) FOREIGN KEY REFERENCES [MtG].[Face](FaceName) NOT NULL,
    ColorID CHAR(1) FOREIGN KEY REFERENCES [MtG].[AvailableColors](ColorID) NOT NULL,
    CONSTRAINT CFK_FaceID FOREIGN KEY REFERENCES [MtG].[Face](ID, FaceName),
    CONSTRAINT CPK_CardColorID PRIMARY KEY (CardID, FaceName, ColorID)
);

CREATE TABLE [MtG].[AvailableIdentities] (
    IdentityName VARCHAR(8) PRIMARY KEY,
    Black NCHAR(1) NOT NULL,
    Green NCHAR(1) NOT NULL,
    Red NCHAR(1) NOT NULL,
    Blue NCHAR(1) NOT NULL,
    White NCHAR(1) NOT NULL
);

CREATE TABLE [MtG].[ColorIdentity] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    IdentityName VARCHAR(8) FOREIGN KEY REFERENCES [MtG].[AvailableIdentities](IdentityName) NOT NULL,
    CONSTRAINT CPK_CardColorIdentity PRIMARY KEY (CardID, IdentityName)
);

CREATE TABLE [MtG].[AvailableKeywords] (
    Keyword VARCHAR(25) PRIMARY KEY,
    Description VARCHAR(MAX) NOT NULL
);

CREATE TABLE [MtG].[Keywords] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    FaceName VARCHAR(141) FOREIGN KEY REFERENCES [MtG].[Face](FaceName) NOT NULL,
    Keyword VARCHAR(25) FOREIGN KEY REFERENCES [MtG].[AvailableKeywords](Keyword) NOT NULL,
    CONSTRAINT CPK_KeywordID PRIMARY KEY (CardID, FaceName, Keyword)
);

CREATE TABLE [MtG].[Prices] (
    PriceID INT IDENTITY PRIMARY KEY,
    CardID VARCHAR(36) UNIQUE FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    USD DECIMAL(10,2) NULL,
    USD_Foil DECIMAL(10,2) NULL,
    USD_Etched DECIMAL(10,2) NULL,
    EUR DECIMAL(10,2) NULL,
    EUR_Foil DECIMAL(10,2) NULL,
    TIX DECIMAL(10,2) NULL
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
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    Scryfall VARCHAR(250) NULL,
    Gatherer VARCHAR(250) NULL,
    EDHRec VARCHAR(250) NULL
);

CREATE TABLE [MtG].[PurchaseURLs] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    TCGPlayer VARCHAR(250) NULL,
    CardMarket VARCHAR(250) NULL,
    CardHoarder VARCHAR(250) NULL
);

CREATE TABLE [MtG].[Artist] (
    ID VARCHAR(36) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL
);

CREATE TABLE [MtG].[ArtistIDs] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    FaceName VARCHAR(141) FOREIGN KEY REFERENCES [MtG].[Face](FaceName) NOT NULL,
    ArtistID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Artist](ID) NOT NULL,
    CONSTRAINT CPK_FaceArtistID PRIMARY KEY (CardID, FaceName, ArtistID)
);

CREATE TABLE [MtG].[Legalities] (
    CardID VARCHAR(36) PRIMARY KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    Standard NCHAR(1) NOT NULL DEFAULT('N'),
    Future NCHAR(1) NOT NULL DEFAULT('N'),
    Historic NCHAR(1) NOT NULL DEFAULT('N'),
    Gladiator NCHAR(1) NOT NULL DEFAULT('N'),
    Pioneer NCHAR(1) NOT NULL DEFAULT('N'),
    Explorer NCHAR(1) NOT NULL DEFAULT('N'),
    Modern NCHAR(1) NOT NULL DEFAULT('N'),
    Legacy NCHAR(1) NOT NULL DEFAULT('N'),
    Pauper NCHAR(1) NOT NULL DEFAULT('N'),
    Vintage NCHAR(1) NOT NULL DEFAULT('N'),
    Penny NCHAR(1) NOT NULL DEFAULT('N'),
    Commander NCHAR(1) NOT NULL DEFAULT('N'),
    Oathbreaker NCHAR(1) NOT NULL DEFAULT('N'),
    Brawl NCHAR(1) NOT NULL DEFAULT('N'),
    HistoricBrawl NCHAR(1) NOT NULL DEFAULT('N'),
    Alchemy NCHAR(1) NOT NULL DEFAULT('N'),
    PauperCommander NCHAR(1) NOT NULL DEFAULT('N'),
    Duel NCHAR(1) NOT NULL DEFAULT('N'),
    Oldschool NCHAR(1) NOT NULL DEFAULT('N'),
    Premodern NCHAR(1) NOT NULL DEFAULT('N'),
    Predh NCHAR(1) NOT NULL DEFAULT('N')
);

CREATE TABLE [MtG].[AvailableFinishes] (
    Name VARCHAR(8) PRIMARY KEY,
    Description VARCHAR(MAX) NOT NULL
);

CREATE TABLE [MtG].[Finishes] (
    CardID VARCHAR(36) FOREIGN KEY REFERENCES [MtG].[Card](ID) NOT NULL,
    FinishName VARCHAR(8) FOREIGN KEY REFERENCES [MtG].[AvailableFinishes] NOT NULL,
    CONSTRAINT CPK_CardFinishes PRIMARY KEY (CardID, FinishName)
);

/* INSERT STATIC INFORMATION */

/* Available Finishes */
INSERT INTO [MtG].[AvailableFinishes] VALUES('Nonfoil', 'A standard Magic: The Gathering card with no special finish.');
INSERT INTO [MtG].[AvailableFinishes] VALUES('Foil', 'A Magic: The Gathering card with a holo/foil finish.');
INSERT INTO [MtG].[AvailableFinishes] VALUES('Etched', 'A Magic: The Gathering card with a special etched finish.');
INSERT INTO [MtG].[AvailableFinishes] VALUES('Glossy', 'A Magic: The Gathering card with a glossy finish.');

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
INSERT INTO [MtG].[AvailableGrades] VALUES('UO-NM', 'Unofficial', 'Near Mint', 'Self-graded card identified as being in Mint or Near Mint condition. Near Mint condition cards display minimal or no wear or damage. The card should appear “fresh out of the pack.” Other than minor chipping, indentation, or scratches, the card shows no moderate or major signs of damage. These cards may be “never played” cards or cards that have been played with sleeves.');
INSERT INTO [MtG].[AvailableGrades] VALUES('UO-LP', 'Unofficial', 'Lightly Played', 'Self-graded card identified as being lightly played. Lightly Played condition cards may have minor border or corner wear, scruffs or scratches. There are no major defects such as grime, bends, or issues with the structural integrity of the card. Noticeable imperfections are okay, but none should be too severe or at too high a volume.');
INSERT INTO [MtG].[AvailableGrades] VALUES('UO-MP', 'Unofficial', 'Moderately Played', 'Self-graded card identified as being moderately played. Moderately Played condition cards can have border wear, corner wear, scratching or scuffing, creasing or whitening, or any combination of moderate examples of these flaws. A Moderately Played card may have some imperfection impacting a small area of the card from mishandling or poor storage, such as creasing that doesn''t affect card integrity, in combination with other issues such as scratches, scuffs, or border/edge wear.');
INSERT INTO [MtG].[AvailableGrades] VALUES('UO-HP', 'Unofficial', 'Heavily Played', 'Self-graded card identified as being heavily played. Heavily Played condition cards show a major amount of wear. Cards can show a variety of moderate imperfections along with creasing, whitening, and bends. Heavily Played cards can also have flaws that impact the integrity of the card, but the card can still be sleeve playable.');
INSERT INTO [MtG].[AvailableGrades] VALUES('UO-DMG', 'Unofficial', 'Damaged', 'Self-graded card identified as being damaged. Damaged condition cards show wear or imperfections beyond the standards for other conditions. Card in this condition can also exhibit an imperfection that may make the card illegal for tournament play, even in a sleeve. Cards may have major border wear, scratching or scuffing, as well as folds, creases, tears or other damage that impacts the structural integrity of the card.');

/* Available Colors */
INSERT INTO [MtG].[AvailableColors] VALUES('B', 'Black', 'Swamp');
INSERT INTO [MtG].[AvailableColors] VALUES('G', 'Green', 'Forest');
INSERT INTO [MtG].[AvailableColors] VALUES('R', 'Red', 'Mountain');
INSERT INTO [MtG].[AvailableColors] VALUES('U', 'Blue', 'Island');
INSERT INTO [MtG].[AvailableColors] VALUES('W', 'White', 'Plains');

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
INSERT INTO [MtG].[AvailableKeywords] VALUES('Attach', 'The term attach is used on Auras, Equipment, and Fortifications, which provide effects to certain other cards for an indeterminate amount of time. These types of cards are used by designating something (usually a permanent) for them to be "attached" to.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Counter', 'To counter a spell or ability is to remove it from the stack without resolving its effects, putting it directly into its owner''s graveyard. Some spells and abilities have an additional clause that replaces the graveyard with another game zone. There are instant spells that will explicitly counter other spells, generally known as "counterspells" after the original card with this effect. Some cards specify that they "cannot be countered".');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Exile', 'To exile a card is to put it into the exile zone, usually as part of a card''s effect. Starting from the Magic 2010 rules changes, cards that say "remove [something] from the game" or "set [something] aside" were issued errata to say "exile [something]" instead.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Fight', 'When two creatures fight each other, each creature deals damage equal to its power to the other creature. Multiple creatures may fight each other at the same time.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Mill', 'When a player Mills x cards, they put the top x cards of that library into their graveyard.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Sacrifice', 'To sacrifice a permanent is to put it into its owner''s graveyard. A player can only sacrifice a permanent they control. Note that this term is separate from other ways permanents can be put into their owners'' graveyards, such as destruction (meaning regeneration has no effect on sacrifice) and state-based actions (a creature having 0 toughness, for example). Players are not allowed to sacrifice unless prompted to by a game effect.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Scry', 'Scry x allows the player to take the top x cards from their deck, examine them, and place any number of them on the bottom of their deck and the rest on top in any order desired.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Tap', 'To tap a permanent is to rotate the card 90 degrees. This indicates it is being used, often as a cost, or to indicate that a creature is attacking (except for creatures with vigilance). Creatures a player controls that have not been under their control since the beginning of their most recent turn are said to have "summoning sickness" and cannot be tapped for their abilities that include the "tap symbol", nor can they attack, but they can be tapped for costs that use the word "tap" (for example, "Tap two untapped creatures you control").');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Untap', 'To untap a permanent is to return it to a vertical orientation, allowing it to be tapped again. A tapped permanent must be untapped before it can be tapped again. However, untapping can also be a cost for activated abilities. It has its own special untap symbol (often called "Q"), and is separate from normal untapping. To pay a cost including the untap symbol, the permanent must be already tapped. If that permanent is also a creature, then, as with the tap symbol, that ability can only be used if the creature has been under its controller''s control since the beginning of their most recent turn.');

/* Available Keywords - Evergreen */
INSERT INTO [MtG].[AvailableKeywords] VALUES('Deathtouch', 'Deathtouch is a static ability that causes a creature to be destroyed as a result of having been dealt damage by a source with deathtouch. In this way, for a creature with deathtouch, any nonzero amount of damage it deals to another creature is considered enough to kill it.');
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
INSERT INTO [MtG].[AvailableKeywords] VALUES('Vigilance', 'Creatures with vigilance do not tap when attacking, meaning they can still be used during the opponent''s turn to block.');

/* Keywords - Expert Level (Mechanics) */
INSERT INTO [MtG].[AvailableKeywords] VALUES('Absorb', 'This ability is written Absorb x, where x is a quantity of damage prevented on a creature with the ability.');
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
INSERT INTO [MtG].[AvailableKeywords] VALUES('Wither', 'Wither is a replacement ability that modifies damage. Nonlethal damage marked on a creature normally goes away at the end of the turn. However, whenever a source with wither deals damage to a creature, that creature receives a number of -1/-1 counters equal to the amount of damage dealt to it. When it deals damage to a player, that player will receive regular damage unlike infect.');

/* Available Keywords - Ability Words */
INSERT INTO [MtG].[AvailableKeywords] VALUES('Addendum', 'Cards with addendum have additional effects if they are cast during their controller''s main phase.');
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
INSERT INTO [MtG].[AvailableKeywords] VALUES('Undergrowth', 'Undergrowth provides benefits depending on the number of creatures in the player''s graveyard.');

/* Available Keywords - Discontinued Keywords */
INSERT INTO [MtG].[AvailableKeywords] VALUES('Banding', 'Banding is an ability that has defensive and offensive functions. A defending player determines how combat damage is dealt by an opposing creature if at least one of the creatures blocking has banding (without banding, the attacking player determines this). An attacking player may form "bands" of creatures with banding, which may also include one non-banding creature. If one creature in the band becomes blocked, the whole band becomes blocked as well, whether or not the defender could block other creatures in the band.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Bury', 'Destroy target creature. It cannot be regenerated.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Fear', 'Creatures with fear cannot be blocked except by black creatures and by artifact creatures.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Intimidate', 'A creature with intimidate cannot be blocked except by artifact creatures and creatures that share a color with it.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Landhome', 'This ability is written as (land type) home . A creature with landhome may only attack a player who controls a land of the specified land type, and must be sacrificed if its controller does not control at least one land of that same type.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Landwalk', 'This ability is written as (Land type) walk. A creature with this ability can not be blocked while the defending player controls at least one land with the printed land type (e.g. a creature with swampwalk can not be blocked if the opponent has a swamp on the battlefield).');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Phasing', 'Phasing introduced a new rule to the game. Cards with the status "phased out" are treated as though they do not exist except for cards that specifically interact with phased-out cards. At the beginning of each player''s turn, all permanents the player controls which have phasing become "phased out", along with anything attached to the phasing cards. Any cards the player controls which were phased out become "phased in" and return to the battlefield at the same time. Phasing in or out does not tap or untap the permanent. A token that phases out ceases to exist, while anything attached to it phases out and does not phase in on the token''s controller''s next turn.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Regenerate', ' An ability such as "Regenerate [this creature]" could be activated; in this context "regenerate" means "set up a regeneration shield", which protects the affected permanent from the next time it would be destroyed (either due to damage or to "destroy" effects). Instead of being destroyed, the permanent would become tapped and be removed from combat. The second keyword action refers to when this actually occurs: cards like Skeleton Scavengers have a delayed triggered ability that only triggers when the creature has a destroy effect prevented by its regeneration ability.');
INSERT INTO [MtG].[AvailableKeywords] VALUES('Shroud', 'A player or permanent with shroud cannot be the target of spells or abilities (even their own).');

COMMIT TRANSACTION