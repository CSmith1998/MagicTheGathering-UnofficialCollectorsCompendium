/* Card: ID, Name, ReleasedAt, Layout, ConvertedManaCost, ColorIdentity, TypeLine, Reserved, Foil, Nonfoil, Oversized, Promo, Reprint, SetID, RulingsURL, Rarity, Artist, FullArt, Textless */
INSERT INTO [MtG].[Card] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Archangel Avacyn // Avacyn, the Purifier', '2016-04-08', 'transform', 5.0, 'Boros', 'Legendary Creature — Angel // Legendary Creature — Angel', 'N', 'Y', 'Y', 'N', 'N', 'N', '5e914d7e-c1e9-446c-a33d-d093c02b2743', 'https://api.scryfall.com/cards/ae155ee2-008f-4dc6-82bf-476be7baa224/rulings', 'mythic', 'James Ryman', 'N', 'N');

INSERT INTO [MtG].[Card] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'Odds // Ends', '2006-05-05', 'split', 7.0, 'Jeskai', 'Instant // Instant', 'N', 'Y', 'Y', 'N', 'N', 'N', 'fdebeda1-b95f-4343-8a94-d125821e6b5c', 'https://api.scryfall.com/cards/4bb07091-86d6-4735-82b6-6e71e26710f4/rulings', 'rare', 'Michael Sutfin', 'N', 'N');

INSERT INTO [MtG].[Card] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'Progenitus', '2013-06-07', 'normal', 10.0, 'Rainbow', 'Legendary Creature — Hydra Avatar', 'N', 'Y', 'Y', 'N', 'N', 'Y', '0b7020f2-336d-4706-9ce6-f6710b9ebd5c', 'https://api.scryfall.com/cards/a8a5d0ba-bcb1-41db-80dd-ad22b8408105/rulings', 'mythic', 'Jaime Jones', 'N', 'N');

/*INSERT INTO [MtG].[Card] VALUES('', '', '', '', 0.0, '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO [MtG].[Card] VALUES('', '', '', '', 0.0, '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO [MtG].[Card] VALUES('', '', '', '', 0.0, '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO [MtG].[Card] VALUES('', '', '', '', 0.0, '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO [MtG].[Card] VALUES('', '', '', '', 0.0, '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO [MtG].[Card] VALUES('', '', '', '', 0.0, '', '', '', '', '', '', '', '', '', '', '', '', '', '');*/

/*Face: CardID, FaceName, ManaCost, TypeLine, Power, Toughness, OracleText, FlavorText */
INSERT INTO [MtG].[Face] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Archangel Avacyn', '{3}{W}{W}', 'Legendary Creature — Angel', 4, 4, 'Flash\nFlying, vigilance\nWhen Archangel Avacyn enters the battlefield, creatures you control gain indestructible until end of turn.\nWhen a non-Angel creature you control dies, transform Archangel Avacyn at the beginning of the next upkeep.', null);
INSERT INTO [MtG].[Face] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Avacyn, the Purifier', null, 'Legendary Creature — Angel', 6, 5, 'Flying\nWhen this creature transforms into Avacyn, the Purifier, it deals 3 damage to each other creature and each opponent.', '\"Wings that once bore hope are now stained with blood. She is our guardian no longer.\"\n—Grete, cathar apostate');

INSERT INTO [MtG].[Face] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'Odds', '{U}{R}', 'Instant', null, null, 'Flip a coin. If it comes up heads, counter target instant or sorcery spell. If it comes up tails, copy that spell and you may choose new targets for the copy.', null);
INSERT INTO [MtG].[Face] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'Ends', '{3}{R}{W}', 'Instant', null, null, 'Target player sacrifices two attacking creatures.', null);

INSERT INTO [MtG].[Face] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'Progenitus', '{W}{W}{U}{U}{B}{B}{R}{R}{G}{G}', 'Legendary Creature — Hydra Avatar', 10, 10, 'Protection from everything\nIf Progenitus would be put into a graveyard from anywhere, reveal Progenitus and shuffle it into its owner''s library instead.', 'The Soul of the World has returned.');

/*INSERT INTO [MtG].[Face] VALUES('', '', '', '', 0, 0, '', '');
INSERT INTO [MtG].[Face] VALUES('', '', '', '', 0, 0, '', '');
INSERT INTO [MtG].[Face] VALUES('', '', '', '', 0, 0, '', '');
INSERT INTO [MtG].[Face] VALUES('', '', '', '', 0, 0, '', '');
INSERT INTO [MtG].[Face] VALUES('', '', '', '', 0, 0, '', '');
INSERT INTO [MtG].[Face] VALUES('', '', '', '', 0, 0, '', '');*/

/*Colors: CardID, FaceName, ColorID */
INSERT INTO [MtG].[Colors] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Archangel Avacyn', 'W');
INSERT INTO [MtG].[Colors] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Avacyn, the Purifier', 'R');

INSERT INTO [MtG].[Colors] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'Odds', 'U');
INSERT INTO [MtG].[Colors] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'Odds', 'R');
INSERT INTO [MtG].[Colors] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'Ends', 'R');
INSERT INTO [MtG].[Colors] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'Ends', 'W');

INSERT INTO [MtG].[Colors] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'Progenitus', 'B');
INSERT INTO [MtG].[Colors] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'Progenitus', 'G');
INSERT INTO [MtG].[Colors] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'Progenitus', 'R');
INSERT INTO [MtG].[Colors] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'Progenitus', 'U');
INSERT INTO [MtG].[Colors] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'Progenitus', 'W');

/*INSERT INTO [MtG].[Colors] VALUES('', '', '');
INSERT INTO [MtG].[Colors] VALUES('', '', '');
INSERT INTO [MtG].[Colors] VALUES('', '', '');
INSERT INTO [MtG].[Colors] VALUES('', '', '');
INSERT INTO [MtG].[Colors] VALUES('', '', '');
INSERT INTO [MtG].[Colors] VALUES('', '', '');
INSERT INTO [MtG].[Colors] VALUES('', '', '');
INSERT INTO [MtG].[Colors] VALUES('', '', '');
INSERT INTO [MtG].[Colors] VALUES('', '', '');*/

/* Finishes: CardID, FinishName */
INSERT INTO [MtG].[Finishes] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Foil');
INSERT INTO [MtG].[Finishes] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Nonfoil');

INSERT INTO [MtG].[Finishes] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'Foil');
INSERT INTO [MtG].[Finishes] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'Nonfoil');

INSERT INTO [MtG].[Finishes] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'Foil');
INSERT INTO [MtG].[Finishes] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'Nonfoil');

/*INSERT INTO [MtG].[Finishes] VALUES('', '');
INSERT INTO [MtG].[Finishes] VALUES('', '');
INSERT INTO [MtG].[Finishes] VALUES('', '');
INSERT INTO [MtG].[Finishes] VALUES('', '');
INSERT INTO [MtG].[Finishes] VALUES('', '');
INSERT INTO [MtG].[Finishes] VALUES('', '');*/

/* Keywords: CardID, FaceName, Keyword */
INSERT INTO [MtG].[Keywords] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Archangel Avacyn', 'Flash');
INSERT INTO [MtG].[Keywords] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Archangel Avacyn', 'Flying');
INSERT INTO [MtG].[Keywords] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Archangel Avacyn', 'Vigilance');
INSERT INTO [MtG].[Keywords] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Archangel Avacyn', 'Transform');
INSERT INTO [MtG].[Keywords] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Avacyn, the Purifier', 'Flying');

INSERT INTO [MtG].[Keywords] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'Progenitus', 'Protection');

/*INSERT INTO [MtG].[Keywords] VALUES('', '', '');
INSERT INTO [MtG].[Keywords] VALUES('', '', '');
INSERT INTO [MtG].[Keywords] VALUES('', '', '');
INSERT INTO [MtG].[Keywords] VALUES('', '', '');
INSERT INTO [MtG].[Keywords] VALUES('', '', '');*/

/* Legalities: CardID, Standard, Future, Historic, Gladiator, Pioneer, Explorer, Modern, Legacy, Pauper, Vintage, Penny, Commander, Oathbreaker, Brawl, HistoricBrawl, Alchemy, PauperCommander, Duel, Oldschool, Premodern, Predh */
INSERT INTO [MtG].[Legalities] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'N', 'N', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'N', 'Y', 'Y', 'Y', 'Y', 'N', 'Y', 'N', 'N', 'Y', 'N', 'N', 'N');

INSERT INTO [MtG].[Legalities] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'N', 'N', 'N', 'N', 'N', 'N', 'Y', 'Y', 'N', 'Y', 'Y', 'Y', 'Y', 'N', 'N', 'N', 'N', 'Y', 'N', 'N', 'Y');

INSERT INTO [MtG].[Legalities] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'N', 'N', 'N', 'N', 'N', 'N', 'Y', 'Y', 'N', 'Y', 'N', 'Y', 'Y', 'N', 'N', 'N', 'N', 'Y', 'N', 'N', 'Y');

/*INSERT INTO [MtG].[Legalities] VALUES('', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO [MtG].[Legalities] VALUES('', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO [MtG].[Legalities] VALUES('', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO [MtG].[Legalities] VALUES('', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO [MtG].[Legalities] VALUES('', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N');*/

/* Prices: CardID, USD, USD_Foil, USD_Etched, EUR, EUR_Foil, TIX */
INSERT INTO [MtG].[Prices] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 5.10, 9.78, null, 2.70, 13.33, null);

INSERT INTO [MtG].[Prices] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 0.26, 2.45, null, 0.10, 1.20, 0.01);

INSERT INTO [MtG].[Prices] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 10.55, 34.43, null, 6.35, 13.00, 0.25);

/*INSERT INTO [MtG].[Prices] VALUES('', null, null, null, null, null, null);
INSERT INTO [MtG].[Prices] VALUES('', null, null, null, null, null, null);
INSERT INTO [MtG].[Prices] VALUES('', null, null, null, null, null, null);
INSERT INTO [MtG].[Prices] VALUES('', null, null, null, null, null, null);
INSERT INTO [MtG].[Prices] VALUES('', null, null, null, null, null, null);
INSERT INTO [MtG].[Prices] VALUES('', null, null, null, null, null, null);*/

/* PurchaseURLs: CardID, TCGPlayer, CardMarket, CardHoarder */
INSERT INTO [MtG].[PurchaseURLs] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'https://www.tcgplayer.com/product/114848?page=1&utm_campaign=affiliate&utm_medium=api&utm_source=scryfall', 'https://www.cardmarket.com/en/Magic/Products/Search?referrer=scryfall&searchString=Archangel+Avacyn&utm_campaign=card_prices&utm_medium=text&utm_source=scryfall', 'https://www.cardhoarder.com/cards/59766?affiliate_id=scryfall&ref=card-profile&utm_campaign=affiliate&utm_medium=card&utm_source=scryfall');

INSERT INTO [MtG].[PurchaseURLs] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'https://www.tcgplayer.com/product/13903?page=1&utm_campaign=affiliate&utm_medium=api&utm_source=scryfall', 'https://www.cardmarket.com/en/Magic/Products/Search?referrer=scryfall&searchString=Odds+%2F%2F+Ends&utm_campaign=card_prices&utm_medium=text&utm_source=scryfall', 'https://www.cardhoarder.com/cards/24367?affiliate_id=scryfall&ref=card-profile&utm_campaign=affiliate&utm_medium=card&utm_source=scryfall');

INSERT INTO [MtG].[PurchaseURLs] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'https://www.tcgplayer.com/product/68429?page=1&utm_campaign=affiliate&utm_medium=api&utm_source=scryfall', 'https://www.cardmarket.com/en/Magic/Products/Search?referrer=scryfall&searchString=Progenitus&utm_campaign=card_prices&utm_medium=text&utm_source=scryfall', 'https://www.cardhoarder.com/cards/48818?affiliate_id=scryfall&ref=card-profile&utm_campaign=affiliate&utm_medium=card&utm_source=scryfall');

/*INSERT INTO [MtG].[CardURLs] VALUES('', null, null, null);
INSERT INTO [MtG].[CardURLs] VALUES('', null, null, null);
INSERT INTO [MtG].[CardURLs] VALUES('', null, null, null);
INSERT INTO [MtG].[CardURLs] VALUES('', null, null, null);
INSERT INTO [MtG].[CardURLs] VALUES('', null, null, null);
INSERT INTO [MtG].[CardURLs] VALUES('', null, null, null);*/

/* CardURLs: CardID, Scryfall, Gatherer, EDHRec */
INSERT INTO [MtG].[CardURLs] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'https://scryfall.com/card/soi/5/archangel-avacyn-avacyn-the-purifier?utm_source=api', 'https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=409741', 'https://edhrec.com/route/?cc=Archangel+Avacyn');

INSERT INTO [MtG].[CardURLs] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'https://scryfall.com/card/dis/153/odds-ends?utm_source=api', 'https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=107445', 'https://edhrec.com/route/?cc=Odds+%2F%2F+Ends');

INSERT INTO [MtG].[CardURLs] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'https://scryfall.com/card/mma/182/progenitus?utm_source=api', 'https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=370405', 'https://edhrec.com/route/?cc=Progenitus');

/*INSERT INTO [MtG].[CardURLs] VALUES('', null, null, null);
INSERT INTO [MtG].[CardURLs] VALUES('', null, null, null);
INSERT INTO [MtG].[CardURLs] VALUES('', null, null, null);
INSERT INTO [MtG].[CardURLs] VALUES('', null, null, null);
INSERT INTO [MtG].[CardURLs] VALUES('', null, null, null);
INSERT INTO [MtG].[CardURLs] VALUES('', null, null, null);*/

/* ImageURLs: CardID, FaceName, Small, Normal, Large, PNG, ArtCrop, BorderCrop */
INSERT INTO [MtG].[ImageURLs] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Archangel Avacyn', 'https://cards.scryfall.io/small/front/a/e/ae155ee2-008f-4dc6-82bf-476be7baa224.jpg?1576383667', 'https://cards.scryfall.io/normal/front/a/e/ae155ee2-008f-4dc6-82bf-476be7baa224.jpg?1576383667', 'https://cards.scryfall.io/large/front/a/e/ae155ee2-008f-4dc6-82bf-476be7baa224.jpg?1576383667', 'https://cards.scryfall.io/png/front/a/e/ae155ee2-008f-4dc6-82bf-476be7baa224.png?1576383667', 'https://cards.scryfall.io/art_crop/front/a/e/ae155ee2-008f-4dc6-82bf-476be7baa224.jpg?1576383667', 'https://cards.scryfall.io/border_crop/front/a/e/ae155ee2-008f-4dc6-82bf-476be7baa224.jpg?1576383667');
INSERT INTO [MtG].[ImageURLs] VALUES('ae155ee2-008f-4dc6-82bf-476be7baa224', 'Avacyn, the Purifier', 'https://cards.scryfall.io/small/back/a/e/ae155ee2-008f-4dc6-82bf-476be7baa224.jpg?1576383667', 'https://cards.scryfall.io/normal/back/a/e/ae155ee2-008f-4dc6-82bf-476be7baa224.jpg?1576383667', 'https://cards.scryfall.io/large/back/a/e/ae155ee2-008f-4dc6-82bf-476be7baa224.jpg?1576383667', 'https://cards.scryfall.io/png/back/a/e/ae155ee2-008f-4dc6-82bf-476be7baa224.png?1576383667', 'https://cards.scryfall.io/art_crop/back/a/e/ae155ee2-008f-4dc6-82bf-476be7baa224.jpg?1576383667', 'https://cards.scryfall.io/border_crop/back/a/e/ae155ee2-008f-4dc6-82bf-476be7baa224.jpg?1576383667');

INSERT INTO [MtG].[ImageURLs] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'Odds', 'https://cards.scryfall.io/small/front/4/b/4bb07091-86d6-4735-82b6-6e71e26710f4.jpg?1593273942', 'https://cards.scryfall.io/normal/front/4/b/4bb07091-86d6-4735-82b6-6e71e26710f4.jpg?1593273942', 'https://cards.scryfall.io/large/front/4/b/4bb07091-86d6-4735-82b6-6e71e26710f4.jpg?1593273942', 'https://cards.scryfall.io/png/front/4/b/4bb07091-86d6-4735-82b6-6e71e26710f4.png?1593273942', 'https://cards.scryfall.io/art_crop/front/4/b/4bb07091-86d6-4735-82b6-6e71e26710f4.jpg?1593273942', 'https://cards.scryfall.io/border_crop/front/4/b/4bb07091-86d6-4735-82b6-6e71e26710f4.jpg?1593273942');
INSERT INTO [MtG].[ImageURLs] VALUES('4bb07091-86d6-4735-82b6-6e71e26710f4', 'Ends', 'https://cards.scryfall.io/small/front/4/b/4bb07091-86d6-4735-82b6-6e71e26710f4.jpg?1593273942', 'https://cards.scryfall.io/normal/front/4/b/4bb07091-86d6-4735-82b6-6e71e26710f4.jpg?1593273942', 'https://cards.scryfall.io/large/front/4/b/4bb07091-86d6-4735-82b6-6e71e26710f4.jpg?1593273942', 'https://cards.scryfall.io/png/front/4/b/4bb07091-86d6-4735-82b6-6e71e26710f4.png?1593273942', 'https://cards.scryfall.io/art_crop/front/4/b/4bb07091-86d6-4735-82b6-6e71e26710f4.jpg?1593273942', 'https://cards.scryfall.io/border_crop/front/4/b/4bb07091-86d6-4735-82b6-6e71e26710f4.jpg?1593273942');

INSERT INTO [MtG].[ImageURLs] VALUES('a8a5d0ba-bcb1-41db-80dd-ad22b8408105', 'Progenitus', 'https://cards.scryfall.io/small/front/a/8/a8a5d0ba-bcb1-41db-80dd-ad22b8408105.jpg?1561968078', 'https://cards.scryfall.io/normal/front/a/8/a8a5d0ba-bcb1-41db-80dd-ad22b8408105.jpg?1561968078', 'https://cards.scryfall.io/large/front/a/8/a8a5d0ba-bcb1-41db-80dd-ad22b8408105.jpg?1561968078', 'https://cards.scryfall.io/png/front/a/8/a8a5d0ba-bcb1-41db-80dd-ad22b8408105.png?1561968078', 'https://cards.scryfall.io/art_crop/front/a/8/a8a5d0ba-bcb1-41db-80dd-ad22b8408105.jpg?1561968078', 'https://cards.scryfall.io/border_crop/front/a/8/a8a5d0ba-bcb1-41db-80dd-ad22b8408105.jpg?1561968078');

/*INSERT INTO [MtG].[ImageURLs] VALUES('', '', null, null, null, null, null, null);
INSERT INTO [MtG].[ImageURLs] VALUES('', '', null, null, null, null, null, null);
INSERT INTO [MtG].[ImageURLs] VALUES('', '', null, null, null, null, null, null);
INSERT INTO [MtG].[ImageURLs] VALUES('', '', null, null, null, null, null, null);
INSERT INTO [MtG].[ImageURLs] VALUES('', '', null, null, null, null, null, null);*/


SELECT * 