BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE IF NOT EXISTS "email_verification_pending" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "email" text NOT NULL,
    "accountRequestId" uuid NOT NULL,
    "verificationCode" text NOT NULL,
    "tokenHash" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "used" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX IF NOT EXISTS "email_verification_pending_token_hash" ON "email_verification_pending" USING btree ("tokenHash");
CREATE INDEX IF NOT EXISTS "email_verification_pending_email" ON "email_verification_pending" USING btree ("email");
CREATE INDEX IF NOT EXISTS "email_verification_pending_expires_at" ON "email_verification_pending" USING btree ("expiresAt");
CREATE INDEX IF NOT EXISTS "email_verification_pending_used" ON "email_verification_pending" USING btree ("used");

--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260715172437650-email-verification-pending', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260715172437650-email-verification-pending', "timestamp" = now();

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
