CREATE TABLE IF NOT EXISTS "users" (
    "user_id" UUID PRIMARY KEY,
    "email" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS "raw_Receipt" (
    "receipt_id" UUID PRIMARY KEY,
    "export_datetime" TIMESTAMP NOT NULL,
    "image" BYTEA NOT NULL
);

CREATE TABLE IF NOT EXISTS "receipt" (
    "receipt_id" UUID PRIMARY KEY,
    "user_id" UUID NOT NULL,
    "type" VARCHAR(255),
    "shop_information" TEXT,
    "time" TIMESTAMP,
    "total" DOUBLE PRECISION,
    "item_purchase" TEXT,
    "raw_total" TEXT,
    "raw_shop_information" TEXT,
    "raw_time" TEXT,
    "raw_item_purchase" TEXT,
    "status" VARCHAR(255)
);

Insert into users (user_id, email, password) values (
    'f0a39253-df87-4f42-b8da-a9c893544b2c',
    'damienmaujean@gmail.com',
    'tesp1234');


INSERT INTO public.receipt
(receipt_id, user_id, "type", shop_information, "time", total, item_purchase, raw_total, raw_shop_information, raw_time, raw_item_purchase, status)
VALUES
('f1d126ee-8d1f-4de1-ab1a-a434a868bc00'::uuid, 'f0a39253-df87-4f42-b8da-a9c893544b2c'::uuid, 'grocery', 'LONDON SUPERMARKET LTD', '2024-03-28 10:15:00', 1244.00, 
 '{"disque be pizza a garnir": {"name": "disque be pizza a garnir", "qty": "1", "price": "4.0"}, 
   "espuna 80g trad chorizo": {"name": "espuna 80g trad chorizo", "qty": "1", "price": "58.0"}, 
   "denny white but .mushroom": {"name": "denny white but .mushroom", "qty": "1", "price": "149.95"}, 
   "ch coca zero 1l": {"name": "ch coca zero 1l", "qty": "1", "price": "51.0"}, 
   "veg he 250g rainbow tomato": {"name": "veg he 250g rainbow tomato", "qty": "1", "price": "138.0"}}',
 'Total : 1244.00', 
 'SUPER U - Udigs Ltee Cap Tamarin, Tamarin VAT Reg. N@ : VAT2008575 1 Business Reg. N92: CO6008088 Tel:484 0062 Fax:484 0018', 
 '2024-03-28 10:15:00', 
 'ss pe pea eae LPS Ae) Business Reg, Ng: Tel :484 0062 Fax | Art/EAN 9310072026282 ARN SHAPES CHEDDAR 1 Art/EAN 6001120081577 BEACON MINT IMPERIAL Art/EAN 6001065036397 CADBURY WHISPERS 656 Art/EAN 6091322000049 BIO SAC CAISSE BIO10 Art/EAN 6091322000049 BIO SAC CAISSE BI010 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6001495031689 SEVEN SEAS BLANC 700 Art/EAN 2000104015090 *CONSIGNE 15 Art/EAN 2000104429996 MEN SLIPPER LT-092 Art/EAN 3256221116069 PAIN AU CHOCOLAT P.B — Art/EAN = 5449000133328 | | | COCA COLA ZERO PET 1 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6091009000096 +QFUDOR PROMO PACK X PEVUOITO | C06008088 :484 0018 114,40 T 42.00 T ate) (ela) I) 3.00 T 3.00°7 98.00 T 316.00 T 15.00 E 100,00 T 180.00 T 48.00 T 98.00 T 246.65 Z', 
 'reviewed'),

('f1d126ee-8d1f-4de1-ab1a-a434a868bc08'::uuid, 'f0a39253-df87-4f42-b8da-a9c893544b2c'::uuid, 'stationery', 'ABC Stationery Shop', '2024-03-29 15:30:00', 300.50, 
 '{"pen": {"name": "pen", "qty": "2", "price": "5.25"}, 
   "notebook": {"name": "notebook", "qty": "3", "price": "20.0"}, 
   "pencil": {"name": "pencil", "qty": "1", "price": "2.75"}}',
 'Total : 300.50', 
 'ABC Stationery Shop, 123 Main Street, Cityville, Country',
 '2024-03-29 15:30:00', 
 'ss pe pea eae LPS Ae) Business Reg, Ng: Tel :484 0062 Fax | Art/EAN 9310072026282 ARN SHAPES CHEDDAR 1 Art/EAN 6001120081577 BEACON MINT IMPERIAL Art/EAN 6001065036397 CADBURY WHISPERS 656 Art/EAN 6091322000049 BIO SAC CAISSE BIO10 Art/EAN 6091322000049 BIO SAC CAISSE BI010 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6001495031689 SEVEN SEAS BLANC 700 Art/EAN 2000104015090 *CONSIGNE 15 Art/EAN 2000104429996 MEN SLIPPER LT-092 Art/EAN 3256221116069 PAIN AU CHOCOLAT P.B — Art/EAN = 5449000133328 | | | COCA COLA ZERO PET 1 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6091009000096 +QFUDOR PROMO PACK X PEVUOITO | C06008088 :484 0018 114,40 T 42.00 T ate) (ela) I) 3.00 T 3.00°7 98.00 T 316.00 T 15.00 E 100,00 T 180.00 T 48.00 T 98.00 T 246.65 Z', 
 'reviewed'),
 
 ('f1d126ee-8d1f-4de1-ab1a-a434a868bc09'::uuid, 'f0a39253-df87-4f42-b8da-a9c893544b2c'::uuid, 'electronics', 'Gadget Emporium', '2024-03-30 11:45:00', 1899.99, 
 '{"smartphone": {"name": "smartphone", "qty": "1", "price": "899.99"}, 
   "laptop": {"name": "laptop", "qty": "1", "price": "999.00"}}',
 'Total : 1899.99', 
 'Gadget Emporium, 456 High Street, Techcity, Country',
 '2024-03-30 11:45:00', 
 'ss pe pea eae LPS Ae) Business Reg, Ng: Tel :484 0062 Fax | Art/EAN 9310072026282 ARN SHAPES CHEDDAR 1 Art/EAN 6001120081577 BEACON MINT IMPERIAL Art/EAN 6001065036397 CADBURY WHISPERS 656 Art/EAN 6091322000049 BIO SAC CAISSE BIO10 Art/EAN 6091322000049 BIO SAC CAISSE BI010 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6001495031689 SEVEN SEAS BLANC 700 Art/EAN 2000104015090 *CONSIGNE 15 Art/EAN 2000104429996 MEN SLIPPER LT-092 Art/EAN 3256221116069 PAIN AU CHOCOLAT P.B — Art/EAN = 5449000133328 | | | COCA COLA ZERO PET 1 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6091009000096 +QFUDOR PROMO PACK X PEVUOITO | C06008088 :484 0018 114,40 T 42.00 T ate) (ela) I) 3.00 T 3.00°7 98.00 T 316.00 T 15.00 E 100,00 T 180.00 T 48.00 T 98.00 T 246.65 Z', 
 'reviewed'),

('f1d126ee-8d1f-4de1-ab1a-a434a868bc10'::uuid, 'f0a39253-df87-4f42-b8da-a9c893544b2c'::uuid, 'clothing', 'Fashion Hub', '2024-03-31 14:20:00', 450.75, 
 '{"t-shirt": {"name": "t-shirt", "qty": "2", "price": "25.99"}, 
   "jeans": {"name": "jeans", "qty": "1", "price": "199.99"}, 
   "jacket": {"name": "jacket", "qty": "1", "price": "199.99"}}',
 'Total : 450.75', 
 'Fashion Hub, 789 Fashion Avenue, Trendytown, Country',
 '2024-03-31 14:20:00', 
 'ss pe pea eae LPS Ae) Business Reg, Ng: Tel :484 0062 Fax | Art/EAN 9310072026282 ARN SHAPES CHEDDAR 1 Art/EAN 6001120081577 BEACON MINT IMPERIAL Art/EAN 6001065036397 CADBURY WHISPERS 656 Art/EAN 6091322000049 BIO SAC CAISSE BIO10 Art/EAN 6091322000049 BIO SAC CAISSE BI010 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6001495031689 SEVEN SEAS BLANC 700 Art/EAN 2000104015090 *CONSIGNE 15 Art/EAN 2000104429996 MEN SLIPPER LT-092 Art/EAN 3256221116069 PAIN AU CHOCOLAT P.B — Art/EAN = 5449000133328 | | | COCA COLA ZERO PET 1 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6091009000096 +QFUDOR PROMO PACK X PEVUOITO | C06008088 :484 0018 114,40 T 42.00 T ate) (ela) I) 3.00 T 3.00°7 98.00 T 316.00 T 15.00 E 100,00 T 180.00 T 48.00 T 98.00 T 246.65 Z', 
 'reviewed'),

('f1d126ee-8d1f-4de1-ab1a-a434a868bc11'::uuid, 'f0a39253-df87-4f42-b8da-a9c893544b2c'::uuid, 'grocery', 'FreshMart', '2024-04-01 08:00:00', 85.20, 
 '{"eggs": {"name": "eggs", "qty": "1 dozen", "price": "4.50"}, 
   "milk": {"name": "milk", "qty": "2 litres", "price": "3.25"}, 
   "bread": {"name": "bread", "qty": "1 loaf", "price": "2.99"}, 
   "apples": {"name": "apples", "qty": "5", "price": "6.75"}, 
   "bananas": {"name": "bananas", "qty": "6", "price": "5.95"}}',
 'Total : 85.20', 
 'FreshMart, 321 Fresh Street, Green Valley, Country',
 '2024-04-01 08:00:00', 
 'ss pe pea eae LPS Ae) Business Reg, Ng: Tel :484 0062 Fax | Art/EAN 9310072026282 ARN SHAPES CHEDDAR 1 Art/EAN 6001120081577 BEACON MINT IMPERIAL Art/EAN 6001065036397 CADBURY WHISPERS 656 Art/EAN 6091322000049 BIO SAC CAISSE BIO10 Art/EAN 6091322000049 BIO SAC CAISSE BI010 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6001495031689 SEVEN SEAS BLANC 700 Art/EAN 2000104015090 *CONSIGNE 15 Art/EAN 2000104429996 MEN SLIPPER LT-092 Art/EAN 3256221116069 PAIN AU CHOCOLAT P.B — Art/EAN = 5449000133328 | | | COCA COLA ZERO PET 1 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6091009000096 +QFUDOR PROMO PACK X PEVUOITO | C06008088 :484 0018 114,40 T 42.00 T ate) (ela) I) 3.00 T 3.00°7 98.00 T 316.00 T 15.00 E 100,00 T 180.00 T 48.00 T 98.00 T 246.65 Z', 
 'reviewed'),
 
 ('f1d126ee-8d1f-4de1-ab1a-a434a868bc12'::uuid, 'f0a39253-df87-4f42-b8da-a9c893544b2c'::uuid, 'electronics', 'Tech Zone', '2024-04-02 13:45:00', 1299.99, 
 '{"smartwatch": {"name": "smartwatch", "qty": "1", "price": "299.99"}, 
   "headphones": {"name": "headphones", "qty": "1", "price": "149.00"}, 
   "tablet": {"name": "tablet", "qty": "1", "price": "850.00"}}',
 'Total : 1299.99', 
 'Tech Zone, 789 Tech Street, Technocity, Country',
 '2024-04-02 13:45:00', 
 'ss pe pea eae LPS Ae) Business Reg, Ng: Tel :484 0062 Fax | Art/EAN 9310072026282 ARN SHAPES CHEDDAR 1 Art/EAN 6001120081577 BEACON MINT IMPERIAL Art/EAN 6001065036397 CADBURY WHISPERS 656 Art/EAN 6091322000049 BIO SAC CAISSE BIO10 Art/EAN 6091322000049 BIO SAC CAISSE BI010 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6001495031689 SEVEN SEAS BLANC 700 Art/EAN 2000104015090 *CONSIGNE 15 Art/EAN 2000104429996 MEN SLIPPER LT-092 Art/EAN 3256221116069 PAIN AU CHOCOLAT P.B — Art/EAN = 5449000133328 | | | COCA COLA ZERO PET 1 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6091009000096 +QFUDOR PROMO PACK X PEVUOITO | C06008088 :484 0018 114,40 T 42.00 T ate) (ela) I) 3.00 T 3.00°7 98.00 T 316.00 T 15.00 E 100,00 T 180.00 T 48.00 T 98.00 T 246.65 Z', 
 'reviewed'),

('f1d126ee-8d1f-4de1-ab1a-a434a868bc13'::uuid, 'f0a39253-df87-4f42-b8da-a9c893544b2c'::uuid, 'furniture', 'Home Decor', '2024-04-03 16:30:00', 2150.00, 
 '{"sofa": {"name": "sofa", "qty": "1", "price": "1500.00"}, 
   "coffee table": {"name": "coffee table", "qty": "1", "price": "650.00"}}',
 'Total : 2150.00', 
 'Home Decor, 456 Decor Street, Decorville, Country',
 '2024-04-03 16:30:00', 
 'ss pe pea eae LPS Ae) Business Reg, Ng: Tel :484 0062 Fax | Art/EAN 9310072026282 ARN SHAPES CHEDDAR 1 Art/EAN 6001120081577 BEACON MINT IMPERIAL Art/EAN 6001065036397 CADBURY WHISPERS 656 Art/EAN 6091322000049 BIO SAC CAISSE BIO10 Art/EAN 6091322000049 BIO SAC CAISSE BI010 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6001495031689 SEVEN SEAS BLANC 700 Art/EAN 2000104015090 *CONSIGNE 15 Art/EAN 2000104429996 MEN SLIPPER LT-092 Art/EAN 3256221116069 PAIN AU CHOCOLAT P.B — Art/EAN = 5449000133328 | | | COCA COLA ZERO PET 1 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6091009000096 +QFUDOR PROMO PACK X PEVUOITO | C06008088 :484 0018 114,40 T 42.00 T ate) (ela) I) 3.00 T 3.00°7 98.00 T 316.00 T 15.00 E 100,00 T 180.00 T 48.00 T 98.00 T 246.65 Z', 
 'reviewed'),

('f1d126ee-8d1f-4de1-ab1a-a434a868bc14'::uuid, 'f0a39253-df87-4f42-b8da-a9c893544b2c'::uuid, 'cosmetics', 'Beauty Palace', '2024-04-04 10:00:00', 75.50, 
 '{"lipstick": {"name": "lipstick", "qty": "1", "price": "15.00"}, 
   "foundation": {"name": "foundation", "qty": "1", "price": "25.00"}, 
   "mascara": {"name": "mascara", "qty": "1", "price": "20.00"}, 
   "eyeshadow palette": {"name": "eyeshadow palette", "qty": "1", "price": "15.50"}}',
 'Total : 75.50', 
 'Beauty Palace, 789 Beauty Street, Beautytown, Country',
 '2024-04-04 10:00:00', 
 'ss pe pea eae LPS Ae) Business Reg, Ng: Tel :484 0062 Fax | Art/EAN 9310072026282 ARN SHAPES CHEDDAR 1 Art/EAN 6001120081577 BEACON MINT IMPERIAL Art/EAN 6001065036397 CADBURY WHISPERS 656 Art/EAN 6091322000049 BIO SAC CAISSE BIO10 Art/EAN 6091322000049 BIO SAC CAISSE BI010 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6001495031689 SEVEN SEAS BLANC 700 Art/EAN 2000104015090 *CONSIGNE 15 Art/EAN 2000104429996 MEN SLIPPER LT-092 Art/EAN 3256221116069 PAIN AU CHOCOLAT P.B — Art/EAN = 5449000133328 | | | COCA COLA ZERO PET 1 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6091009000096 +QFUDOR PROMO PACK X PEVUOITO | C06008088 :484 0018 114,40 T 42.00 T ate) (ela) I) 3.00 T 3.00°7 98.00 T 316.00 T 15.00 E 100,00 T 180.00 T 48.00 T 98.00 T 246.65 Z', 
 'reviewed');


-- For testing purposes

INSERT INTO public.receipt
(receipt_id, user_id, "type", shop_information, "time", total, item_purchase, raw_total, raw_shop_information, raw_time, raw_item_purchase, status)
VALUES
('f1d126ee-8d1f-4de1-ab1a-a434a868bc90'::uuid, '0b158bbc-3842-4dc2-b8dc-8dec91f4a92a'::uuid, 'grocery', 'LONDON SUPERMARKET LTD', '2024-03-28 10:15:00', 1244.00, 
 '{"disque be pizza a garnir": {"name": "disque be pizza a garnir", "qty": "1", "price": "4.0"}, 
   "espuna 80g trad chorizo": {"name": "espuna 80g trad chorizo", "qty": "1", "price": "58.0"}, 
   "denny white but .mushroom": {"name": "denny white but .mushroom", "qty": "1", "price": "149.95"}, 
   "ch coca zero 1l": {"name": "ch coca zero 1l", "qty": "1", "price": "51.0"}, 
   "veg he 250g rainbow tomato": {"name": "veg he 250g rainbow tomato", "qty": "1", "price": "138.0"}}',
 'Total : 1244.00', 
 'SUPER U - Udigs Ltee Cap Tamarin, Tamarin VAT Reg. N@ : VAT2008575 1 Business Reg. N92: CO6008088 Tel:484 0062 Fax:484 0018', 
 '2024-03-28 10:15:00', 
 'ss pe pea eae LPS Ae) Business Reg, Ng: Tel :484 0062 Fax | Art/EAN 9310072026282 ARN SHAPES CHEDDAR 1 Art/EAN 6001120081577 BEACON MINT IMPERIAL Art/EAN 6001065036397 CADBURY WHISPERS 656 Art/EAN 6091322000049 BIO SAC CAISSE BIO10 Art/EAN 6091322000049 BIO SAC CAISSE BI010 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6001495031689 SEVEN SEAS BLANC 700 Art/EAN 2000104015090 *CONSIGNE 15 Art/EAN 2000104429996 MEN SLIPPER LT-092 Art/EAN 3256221116069 PAIN AU CHOCOLAT P.B — Art/EAN = 5449000133328 | | | COCA COLA ZERO PET 1 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6091009000096 +QFUDOR PROMO PACK X PEVUOITO | C06008088 :484 0018 114,40 T 42.00 T ate) (ela) I) 3.00 T 3.00°7 98.00 T 316.00 T 15.00 E 100,00 T 180.00 T 48.00 T 98.00 T 246.65 Z', 
 'reviewed'),

('f1d126ee-8d1f-4de1-ab1a-a434a868bc91'::uuid, '0b158bbc-3842-4dc2-b8dc-8dec91f4a92a'::uuid, 'stationery', 'ABC Stationery Shop', '2024-03-29 15:30:00', 300.50, 
 '{"pen": {"name": "pen", "qty": "2", "price": "5.25"}, 
   "notebook": {"name": "notebook", "qty": "3", "price": "20.0"}, 
   "pencil": {"name": "pencil", "qty": "1", "price": "2.75"}}',
 'Total : 300.50', 
 'ABC Stationery Shop, 123 Main Street, Cityville, Country',
 '2024-03-29 15:30:00', 
 'ss pe pea eae LPS Ae) Business Reg, Ng: Tel :484 0062 Fax | Art/EAN 9310072026282 ARN SHAPES CHEDDAR 1 Art/EAN 6001120081577 BEACON MINT IMPERIAL Art/EAN 6001065036397 CADBURY WHISPERS 656 Art/EAN 6091322000049 BIO SAC CAISSE BIO10 Art/EAN 6091322000049 BIO SAC CAISSE BI010 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6001495031689 SEVEN SEAS BLANC 700 Art/EAN 2000104015090 *CONSIGNE 15 Art/EAN 2000104429996 MEN SLIPPER LT-092 Art/EAN 3256221116069 PAIN AU CHOCOLAT P.B — Art/EAN = 5449000133328 | | | COCA COLA ZERO PET 1 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6091009000096 +QFUDOR PROMO PACK X PEVUOITO | C06008088 :484 0018 114,40 T 42.00 T ate) (ela) I) 3.00 T 3.00°7 98.00 T 316.00 T 15.00 E 100,00 T 180.00 T 48.00 T 98.00 T 246.65 Z', 
 'reviewed'),
 
 ('f1d126ee-8d1f-4de1-ab1a-a434a868bc92'::uuid, '0b158bbc-3842-4dc2-b8dc-8dec91f4a92a'::uuid, 'electronics', 'Gadget Emporium', '2024-03-30 11:45:00', 1899.99, 
 '{"smartphone": {"name": "smartphone", "qty": "1", "price": "899.99"}, 
   "laptop": {"name": "laptop", "qty": "1", "price": "999.00"}}',
 'Total : 1899.99', 
 'Gadget Emporium, 456 High Street, Techcity, Country',
 '2024-03-30 11:45:00', 
 'ss pe pea eae LPS Ae) Business Reg, Ng: Tel :484 0062 Fax | Art/EAN 9310072026282 ARN SHAPES CHEDDAR 1 Art/EAN 6001120081577 BEACON MINT IMPERIAL Art/EAN 6001065036397 CADBURY WHISPERS 656 Art/EAN 6091322000049 BIO SAC CAISSE BIO10 Art/EAN 6091322000049 BIO SAC CAISSE BI010 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6001495031689 SEVEN SEAS BLANC 700 Art/EAN 2000104015090 *CONSIGNE 15 Art/EAN 2000104429996 MEN SLIPPER LT-092 Art/EAN 3256221116069 PAIN AU CHOCOLAT P.B — Art/EAN = 5449000133328 | | | COCA COLA ZERO PET 1 Art/EAN 6091020010562 PHOENIX FRESH BEER C Art/EAN 6091009000096 +QFUDOR PROMO PACK X PEVUOITO | C06008088 :484 0018 114,40 T 42.00 T ate) (ela) I) 3.00 T 3.00°7 98.00 T 316.00 T 15.00 E 100,00 T 180.00 T 48.00 T 98.00 T 246.65 Z', 
 'reviewed');
 