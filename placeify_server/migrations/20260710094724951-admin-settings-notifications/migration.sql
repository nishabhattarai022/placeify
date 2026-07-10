BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "admin" ADD COLUMN "newApplicationAlerts" boolean NOT NULL DEFAULT true;
ALTER TABLE "admin" ADD COLUMN "systemAlerts" boolean NOT NULL DEFAULT true;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "in_app_notification" ADD COLUMN "referenceKey" text;

--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260710094724951-admin-settings-notifications', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260710094724951-admin-settings-notifications', "timestamp" = now();

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
