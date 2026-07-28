BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "refund_request" ADD COLUMN "gatewayStatus" text;
ALTER TABLE "refund_request" ADD COLUMN "gatewayReference" text;
ALTER TABLE "refund_request" ADD COLUMN "gatewayResponse" text;
ALTER TABLE "refund_request" ADD COLUMN "refundCompletedAt" timestamp without time zone;
ALTER TABLE "refund_request" ADD COLUMN "lastGatewayCheckAt" timestamp without time zone;
ALTER TABLE "refund_request" ADD COLUMN "settlementMode" text;

--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260725175621677-esewa-refund-mode-b', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260725175621677-esewa-refund-mode-b', "timestamp" = now();

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
