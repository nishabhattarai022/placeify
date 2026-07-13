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
CREATE TABLE "admin_audit_log" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "actorAdminId" uuid NOT NULL,
    "actionType" text NOT NULL,
    "targetUserId" uuid,
    "targetVendorId" uuid,
    "targetProductId" bigint,
    "targetComplaintId" uuid,
    "targetPayoutId" bigint,
    "targetRefundId" bigint,
    "previousStatus" text,
    "newStatus" text,
    "reason" text,
    "note" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "admin_audit_log_created_at" ON "admin_audit_log" USING btree ("createdAt");
CREATE INDEX "admin_audit_log_actor_admin_id" ON "admin_audit_log" USING btree ("actorAdminId");
CREATE INDEX "admin_audit_log_action_type" ON "admin_audit_log" USING btree ("actionType");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "admin_audit_log"
    ADD CONSTRAINT "admin_audit_log_fk_0"
    FOREIGN KEY("actorAdminId")
    REFERENCES "admin"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260713023606617', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260713023606617', "timestamp" = now();

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
