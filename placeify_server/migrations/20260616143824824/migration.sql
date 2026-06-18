BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "order" ADD COLUMN "rejectionReason" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "order_delivery_update" (
    "id" bigserial PRIMARY KEY,
    "orderId" bigint NOT NULL,
    "vendorId" uuid NOT NULL,
    "stage" text NOT NULL,
    "note" text,
    "photoUrl" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "order_delivery_update_order_vendor" ON "order_delivery_update" USING btree ("orderId", "vendorId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "order_delivery_update"
    ADD CONSTRAINT "order_delivery_update_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "order_delivery_update"
    ADD CONSTRAINT "order_delivery_update_fk_1"
    FOREIGN KEY("vendorId")
    REFERENCES "vendor"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260616143824824', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260616143824824', "timestamp" = now();

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
