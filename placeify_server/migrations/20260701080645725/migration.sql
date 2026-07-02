BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "special_offer" (
    "id" bigserial PRIMARY KEY,
    "productId" bigint NOT NULL,
    "originalPrice" double precision NOT NULL,
    "discountedPrice" double precision NOT NULL,
    "tagline" text NOT NULL,
    "cardColorHex" text NOT NULL DEFAULT '#A8B5A0'::text,
    "isActive" boolean NOT NULL DEFAULT true,
    "displayOrder" bigint NOT NULL DEFAULT 0,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "special_offer_product_id" ON "special_offer" USING btree ("productId");
CREATE INDEX "special_offer_active_order" ON "special_offer" USING btree ("isActive", "displayOrder");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "special_offer"
    ADD CONSTRAINT "special_offer_fk_0"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260701080645725', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260701080645725', "timestamp" = now();

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
