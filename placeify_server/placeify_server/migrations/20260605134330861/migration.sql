BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "app_user" DROP COLUMN "role";
--
-- ACTION CREATE TABLE
--
CREATE TABLE "ar_session" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "productId" bigint NOT NULL,
    "startedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deviceInfo" text,
    "snapshotUrl" text
);

-- Indexes
CREATE INDEX "ar_session_auth_user_id" ON "ar_session" USING btree ("authUserId");
CREATE INDEX "ar_session_product_id" ON "ar_session" USING btree ("productId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "cart" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "cart_auth_user_id" ON "cart" USING btree ("authUserId");

--
-- ACTION DROP TABLE
--
DROP TABLE "cart_item" CASCADE;

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
-- ACTION ALTER TABLE
--
ALTER TABLE "category" ADD COLUMN "description" text;
--
-- ACTION DROP TABLE
--
DROP TABLE "customization_request" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "customization_request" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "vendorId" uuid NOT NULL,
    "productId" bigint NOT NULL,
    "description" text NOT NULL,
    "attachmentUrl" text,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "customization_request_vendor_id" ON "customization_request" USING btree ("vendorId");
CREATE INDEX "customization_request_auth_user_id" ON "customization_request" USING btree ("authUserId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "product" DROP COLUMN "imageUrls";
ALTER TABLE "product" DROP COLUMN "isActive";
ALTER TABLE "product" ADD COLUMN "thumbnailUrl" text;
ALTER TABLE "product" ADD COLUMN "status" text NOT NULL DEFAULT 'active'::text;
--
-- ACTION ALTER TABLE
--
DROP INDEX "purchase_order_vendor_id";
ALTER TABLE "purchase_order" DROP CONSTRAINT IF EXISTS "purchase_order_fk_1";
ALTER TABLE "purchase_order" DROP COLUMN "vendorId";
ALTER TABLE "purchase_order" DROP COLUMN "createdAt";
ALTER TABLE "purchase_order" ADD COLUMN "placedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP;
--
-- ACTION DROP TABLE
--
DROP TABLE "purchase_order_item" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "purchase_order_item" (
    "id" bigserial PRIMARY KEY,
    "orderId" bigint NOT NULL,
    "productId" bigint NOT NULL,
    "vendorId" uuid NOT NULL,
    "quantity" bigint NOT NULL,
    "unitPrice" double precision NOT NULL
);

-- Indexes
CREATE INDEX "purchase_order_item_order_id" ON "purchase_order_item" USING btree ("orderId");

--
-- ACTION DROP TABLE
--
DROP TABLE "review" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "review" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "productId" bigint NOT NULL,
    "orderId" bigint NOT NULL,
    "rating" bigint NOT NULL,
    "comment" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "review_auth_user_product_order" ON "review" USING btree ("authUserId", "productId", "orderId");
CREATE INDEX "review_product_id" ON "review" USING btree ("productId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "vendor_profile" DROP COLUMN "address";
ALTER TABLE "vendor_profile" DROP COLUMN "isApproved";
ALTER TABLE "vendor_profile" ADD COLUMN "logoUrl" text;
ALTER TABLE "vendor_profile" ADD COLUMN "rating" double precision NOT NULL DEFAULT 0;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ar_session"
    ADD CONSTRAINT "ar_session_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
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
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
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
ALTER TABLE ONLY "purchase_order_item"
    ADD CONSTRAINT "purchase_order_item_fk_2"
    FOREIGN KEY("vendorId")
    REFERENCES "vendor_profile"("id")
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
ALTER TABLE ONLY "review"
    ADD CONSTRAINT "review_fk_2"
    FOREIGN KEY("orderId")
    REFERENCES "purchase_order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260605134330861', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260605134330861', "timestamp" = now();

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
