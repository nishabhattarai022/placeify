BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "product" ADD COLUMN "model3dStatus" text DEFAULT 'none'::text;
ALTER TABLE "product" ADD COLUMN "model3dError" text;

-- Existing GLBs are already AR-ready.
UPDATE "product"
SET "model3dStatus" = 'ready'
WHERE "model3dUrl" IS NOT NULL AND btrim("model3dUrl") <> '';

--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260713111906994-model3d-status', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260713111906994-model3d-status', "timestamp" = now();

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
