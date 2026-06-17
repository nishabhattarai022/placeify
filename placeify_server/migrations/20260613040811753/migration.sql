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
-- ACTION DROP TABLE
--
DROP TABLE "admin" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "admin" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "fullName" text NOT NULL,
    "email" text NOT NULL,
    "phoneNumber" text,
    "adminType" text NOT NULL DEFAULT 'moderator'::text,
    "isActive" boolean NOT NULL DEFAULT true,
    "lastLoginAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "admin_user_id" ON "admin" USING btree ("userId");
CREATE UNIQUE INDEX "admin_email" ON "admin" USING btree ("email");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "complaint" ADD COLUMN "resolvedById" uuid;
ALTER TABLE "complaint" ADD COLUMN "resolvedAt" timestamp without time zone;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "product" DROP CONSTRAINT IF EXISTS "product_fk_2";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "user" ADD COLUMN "approvedById" uuid;
ALTER TABLE "user" ADD COLUMN "statusChangedById" uuid;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "vendor" DROP CONSTRAINT IF EXISTS "vendor_fk_1";
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "admin"
    ADD CONSTRAINT "admin_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "complaint"
    ADD CONSTRAINT "complaint_fk_2"
    FOREIGN KEY("resolvedById")
    REFERENCES "admin"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "product"
    ADD CONSTRAINT "product_fk_2"
    FOREIGN KEY("removedById")
    REFERENCES "admin"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user"
    ADD CONSTRAINT "user_fk_1"
    FOREIGN KEY("approvedById")
    REFERENCES "admin"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "user"
    ADD CONSTRAINT "user_fk_2"
    FOREIGN KEY("statusChangedById")
    REFERENCES "admin"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "vendor"
    ADD CONSTRAINT "vendor_fk_1"
    FOREIGN KEY("approvedById")
    REFERENCES "admin"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260613040811753', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260613040811753', "timestamp" = now();

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
