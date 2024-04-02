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