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
    "type" VARCHAR(255),
    "shop_information" VARCHAR(255),
    "time" TIMESTAMP,
    "total" DOUBLE PRECISION,
    "item_purchase" VARCHAR(255),
    "raw_total" VARCHAR(255),
    "raw_shop_information" VARCHAR(255),
    "raw_time" VARCHAR(255),
    "raw_item_purchase" VARCHAR(255),
    "status" VARCHAR(255)
);