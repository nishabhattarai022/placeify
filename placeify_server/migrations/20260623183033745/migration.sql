BEGIN;

--
-- Product discount fields (deterministic pricing; no text-field parsing).
--
ALTER TABLE "product" ADD COLUMN IF NOT EXISTS "discountPrice" double precision;
ALTER TABLE "product" ADD COLUMN IF NOT EXISTS "discountPercentage" double precision;
ALTER TABLE "product" ADD COLUMN IF NOT EXISTS "featured" boolean NOT NULL DEFAULT false;
ALTER TABLE "product" ADD COLUMN IF NOT EXISTS "isOffer" boolean NOT NULL DEFAULT false;
ALTER TABLE "product" ADD COLUMN IF NOT EXISTS "viewImageUrls" json;

--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260623183033745', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260623183033745', "timestamp" = now();

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
