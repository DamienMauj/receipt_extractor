CREATE TABLE IF NOT EXISTS "User" (
    "User_id" UUID PRIMARY KEY,
    "email" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS "Raw_Receipt" (
    "Receipt_id" UUID PRIMARY KEY,
    "Export_datetime" TIMESTAMP NOT NULL,
    "Image" BYTEA NOT NULL
);

CREATE TABLE IF NOT EXISTS "Receipt" (
    "Receipt_id" UUID PRIMARY KEY,
    "Raw_total" VARCHAR(255),
    "Raw_shop_information" VARCHAR(255),
    "Raw_time" VARCHAR(255),
    "Raw_item_purchase" VARCHAR(255),
    "Total" DOUBLE PRECISION,
    "Shop_information" VARCHAR(255),
    "Time" TIMESTAMP,
    "Item_purchase" VARCHAR(255)
);