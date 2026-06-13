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
DROP TABLE "complaint" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "complaint" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "productId" bigint NOT NULL,
    "reportedById" uuid NOT NULL,
    "reason" text NOT NULL,
    "description" text,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "resolvedById" uuid,
    "resolvedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "complaint_product_id" ON "complaint" USING btree ("productId");
CREATE INDEX "complaint_reported_by_id" ON "complaint" USING btree ("reportedById");
CREATE INDEX "complaint_status" ON "complaint" USING btree ("status");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "complaint"
    ADD CONSTRAINT "complaint_fk_0"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "complaint"
    ADD CONSTRAINT "complaint_fk_1"
    FOREIGN KEY("reportedById")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "complaint"
    ADD CONSTRAINT "complaint_fk_2"
    FOREIGN KEY("resolvedById")
    REFERENCES "admin"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260613042420270', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260613042420270', "timestamp" = now();

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
