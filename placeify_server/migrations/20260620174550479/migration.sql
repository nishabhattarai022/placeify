BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order_vendor_payment" (
    "id" bigserial PRIMARY KEY,
    "orderId" bigint NOT NULL,
    "vendorId" uuid NOT NULL,
    "amount" double precision NOT NULL,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "note" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "order_vendor_payment_order_vendor" ON "order_vendor_payment" USING btree ("orderId", "vendorId");
CREATE INDEX "order_vendor_payment_vendor_id" ON "order_vendor_payment" USING btree ("vendorId");
CREATE INDEX "order_vendor_payment_status" ON "order_vendor_payment" USING btree ("status");

--
-- ACTION ALTER TABLE
--
DROP INDEX "payment_transaction_order_id";
CREATE UNIQUE INDEX "payment_transaction_order_id" ON "payment_transaction" USING btree ("orderId");
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "order_vendor_payment"
    ADD CONSTRAINT "order_vendor_payment_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "order_vendor_payment"
    ADD CONSTRAINT "order_vendor_payment_fk_1"
    FOREIGN KEY("vendorId")
    REFERENCES "vendor"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260620174550479', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260620174550479', "timestamp" = now();

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
