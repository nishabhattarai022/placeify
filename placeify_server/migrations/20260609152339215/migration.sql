BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "product" ADD COLUMN "materials" text;
ALTER TABLE "product" ADD COLUMN "widthCm" double precision;
ALTER TABLE "product" ADD COLUMN "depthCm" double precision;
ALTER TABLE "product" ADD COLUMN "heightCm" double precision;
ALTER TABLE "product" ADD COLUMN "weightKg" double precision;
ALTER TABLE "product" ADD COLUMN "assemblyNote" text;
ALTER TABLE "product" ADD COLUMN "careInstructions" text;
ALTER TABLE "product" ADD COLUMN "warranty" text;

--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260609152339215', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260609152339215', "timestamp" = now();

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
