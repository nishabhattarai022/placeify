BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notification_preference" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "orderUpdates" boolean NOT NULL DEFAULT true,
    "refundStatus" boolean NOT NULL DEFAULT true,
    "arReminders" boolean NOT NULL DEFAULT true,
    "priceDropAlerts" boolean NOT NULL DEFAULT false,
    "vendorMessages" boolean NOT NULL DEFAULT true,
    "promotions" boolean NOT NULL DEFAULT false,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "notification_preference_user_id" ON "notification_preference" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "wishlist_item" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "productId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "wishlist_item_user_product" ON "wishlist_item" USING btree ("userId", "productId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "notification_preference"
    ADD CONSTRAINT "notification_preference_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "wishlist_item"
    ADD CONSTRAINT "wishlist_item_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
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
    VALUES ('placeify', '20260608163856353', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260608163856353', "timestamp" = now();

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
