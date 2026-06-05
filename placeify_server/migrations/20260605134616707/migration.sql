BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION DROP TABLE
--
DROP TABLE "cart_item" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "ar_session" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "product" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "customization_request" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "vendor_profile" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "purchase_order_item" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "review" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "purchase_order" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "app_user" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ar_session" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "productId" bigint NOT NULL,
    "startedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deviceInfo" text,
    "snapshotUrl" text
);

-- Indexes
CREATE INDEX "ar_session_user_id" ON "ar_session" USING btree ("userId");
CREATE INDEX "ar_session_product_id" ON "ar_session" USING btree ("productId");

--
-- ACTION DROP TABLE
--
DROP TABLE "cart" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "cart" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "cart_user_id" ON "cart" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "cart_item" (
    "id" bigserial PRIMARY KEY,
    "cartId" bigint NOT NULL,
    "productId" bigint NOT NULL,
    "quantity" bigint NOT NULL DEFAULT 1,
    "unitPrice" double precision NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "cart_item_cart_product" ON "cart_item" USING btree ("cartId", "productId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "customization_request" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "vendorId" uuid NOT NULL,
    "productId" bigint NOT NULL,
    "description" text NOT NULL,
    "attachmentUrl" text,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "customization_request_vendor_id" ON "customization_request" USING btree ("vendorId");
CREATE INDEX "customization_request_user_id" ON "customization_request" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "totalAmount" double precision NOT NULL,
    "shippingAddress" text NOT NULL,
    "placedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "order_user_id" ON "order" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order_item" (
    "id" bigserial PRIMARY KEY,
    "orderId" bigint NOT NULL,
    "productId" bigint NOT NULL,
    "vendorId" uuid NOT NULL,
    "quantity" bigint NOT NULL,
    "unitPrice" double precision NOT NULL
);

-- Indexes
CREATE INDEX "order_item_order_id" ON "order_item" USING btree ("orderId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "product" (
    "id" bigserial PRIMARY KEY,
    "vendorId" uuid NOT NULL,
    "categoryId" bigint,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "price" double precision NOT NULL,
    "model3dUrl" text,
    "thumbnailUrl" text,
    "status" text NOT NULL DEFAULT 'active'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "product_vendor_id" ON "product" USING btree ("vendorId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "review" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "productId" bigint NOT NULL,
    "orderId" bigint NOT NULL,
    "rating" bigint NOT NULL,
    "comment" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "review_user_product_order" ON "review" USING btree ("userId", "productId", "orderId");
CREATE INDEX "review_product_id" ON "review" USING btree ("productId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "name" text NOT NULL,
    "phone" text,
    "address" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "user_auth_user_id" ON "user" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "vendor" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "shopName" text NOT NULL,
    "description" text,
    "logoUrl" text,
    "rating" double precision NOT NULL DEFAULT 0,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "vendor_user_id" ON "vendor" USING btree ("userId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ar_session"
    ADD CONSTRAINT "ar_session_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "ar_session"
    ADD CONSTRAINT "ar_session_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "cart"
    ADD CONSTRAINT "cart_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "cart_item"
    ADD CONSTRAINT "cart_item_fk_0"
    FOREIGN KEY("cartId")
    REFERENCES "cart"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "cart_item"
    ADD CONSTRAINT "cart_item_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "customization_request"
    ADD CONSTRAINT "customization_request_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "customization_request"
    ADD CONSTRAINT "customization_request_fk_1"
    FOREIGN KEY("vendorId")
    REFERENCES "vendor"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "customization_request"
    ADD CONSTRAINT "customization_request_fk_2"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "order"
    ADD CONSTRAINT "order_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "order_item"
    ADD CONSTRAINT "order_item_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "order_item"
    ADD CONSTRAINT "order_item_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "order_item"
    ADD CONSTRAINT "order_item_fk_2"
    FOREIGN KEY("vendorId")
    REFERENCES "vendor"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "product"
    ADD CONSTRAINT "product_fk_0"
    FOREIGN KEY("vendorId")
    REFERENCES "vendor"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "product"
    ADD CONSTRAINT "product_fk_1"
    FOREIGN KEY("categoryId")
    REFERENCES "category"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "review"
    ADD CONSTRAINT "review_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "review"
    ADD CONSTRAINT "review_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "review"
    ADD CONSTRAINT "review_fk_2"
    FOREIGN KEY("orderId")
    REFERENCES "order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user"
    ADD CONSTRAINT "user_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "vendor"
    ADD CONSTRAINT "vendor_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260605134616707', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260605134616707', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();


COMMIT;
