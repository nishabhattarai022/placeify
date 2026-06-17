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
-- ACTION CREATE TABLE
--
CREATE TABLE "app_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "name" text NOT NULL,
    "role" text NOT NULL DEFAULT 'customer'::text,
    "phone" text,
    "address" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "app_user_auth_user_id" ON "app_user" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "cart_item" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "productId" bigint NOT NULL,
    "quantity" bigint NOT NULL DEFAULT 1,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "cart_item_auth_user_product" ON "cart_item" USING btree ("authUserId", "productId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "category" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "category_name" ON "category" USING btree ("name");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "customization_request" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "vendorId" uuid NOT NULL,
    "productId" bigint,
    "title" text NOT NULL,
    "message" text NOT NULL,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "customization_request_vendor_id" ON "customization_request" USING btree ("vendorId");
CREATE INDEX "customization_request_auth_user_id" ON "customization_request" USING btree ("authUserId");

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
    "imageUrls" json NOT NULL,
    "model3dUrl" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "product_vendor_id" ON "product" USING btree ("vendorId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "purchase_order" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "vendorId" uuid NOT NULL,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "totalAmount" double precision NOT NULL,
    "shippingAddress" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "purchase_order_auth_user_id" ON "purchase_order" USING btree ("authUserId");
CREATE INDEX "purchase_order_vendor_id" ON "purchase_order" USING btree ("vendorId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "purchase_order_item" (
    "id" bigserial PRIMARY KEY,
    "orderId" bigint NOT NULL,
    "productId" bigint,
    "quantity" bigint NOT NULL,
    "unitPrice" double precision NOT NULL
);

-- Indexes
CREATE INDEX "purchase_order_item_order_id" ON "purchase_order_item" USING btree ("orderId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "review" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "productId" bigint NOT NULL,
    "rating" bigint NOT NULL,
    "comment" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "review_auth_user_product" ON "review" USING btree ("authUserId", "productId");
CREATE INDEX "review_product_id" ON "review" USING btree ("productId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "vendor_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "shopName" text NOT NULL,
    "description" text,
    "address" text,
    "isApproved" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "vendor_profile_auth_user_id" ON "vendor_profile" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "wishlist_item" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "productId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "wishlist_item_auth_user_product" ON "wishlist_item" USING btree ("authUserId", "productId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "app_user"
    ADD CONSTRAINT "app_user_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "cart_item"
    ADD CONSTRAINT "cart_item_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
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
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "customization_request"
    ADD CONSTRAINT "customization_request_fk_1"
    FOREIGN KEY("vendorId")
    REFERENCES "vendor_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "customization_request"
    ADD CONSTRAINT "customization_request_fk_2"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "product"
    ADD CONSTRAINT "product_fk_0"
    FOREIGN KEY("vendorId")
    REFERENCES "vendor_profile"("id")
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
ALTER TABLE ONLY "purchase_order"
    ADD CONSTRAINT "purchase_order_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "purchase_order"
    ADD CONSTRAINT "purchase_order_fk_1"
    FOREIGN KEY("vendorId")
    REFERENCES "vendor_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "purchase_order_item"
    ADD CONSTRAINT "purchase_order_item_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "purchase_order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "purchase_order_item"
    ADD CONSTRAINT "purchase_order_item_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "review"
    ADD CONSTRAINT "review_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "review"
    ADD CONSTRAINT "review_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "vendor_profile"
    ADD CONSTRAINT "vendor_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "wishlist_item"
    ADD CONSTRAINT "wishlist_item_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "wishlist_item"
    ADD CONSTRAINT "wishlist_item_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260605131448485', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260605131448485', "timestamp" = now();

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
