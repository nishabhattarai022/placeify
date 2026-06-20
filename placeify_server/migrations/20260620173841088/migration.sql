BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "payment_transaction" (
    "id" bigserial PRIMARY KEY,
    "orderId" bigint NOT NULL,
    "userId" uuid NOT NULL,
    "provider" text NOT NULL,
    "providerTransactionId" text NOT NULL,
    "amount" double precision NOT NULL,
    "currency" text NOT NULL DEFAULT 'NPR'::text,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "note" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "payment_transaction_order_id" ON "payment_transaction" USING btree ("orderId");
CREATE INDEX "payment_transaction_user_id" ON "payment_transaction" USING btree ("userId");
CREATE INDEX "payment_transaction_status" ON "payment_transaction" USING btree ("status");
CREATE UNIQUE INDEX "payment_transaction_provider_tx" ON "payment_transaction" USING btree ("providerTransactionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "vendor_payout" (
    "id" bigserial PRIMARY KEY,
    "vendorId" uuid NOT NULL,
    "amount" double precision NOT NULL,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "payoutMethod" text NOT NULL,
    "reference" text NOT NULL,
    "scheduledAt" timestamp without time zone,
    "paidAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "vendor_payout_vendor_id" ON "vendor_payout" USING btree ("vendorId");
CREATE INDEX "vendor_payout_status" ON "vendor_payout" USING btree ("status");
CREATE UNIQUE INDEX "vendor_payout_reference" ON "vendor_payout" USING btree ("reference");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "payment_transaction"
    ADD CONSTRAINT "payment_transaction_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "payment_transaction"
    ADD CONSTRAINT "payment_transaction_fk_1"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "vendor_payout"
    ADD CONSTRAINT "vendor_payout_fk_0"
    FOREIGN KEY("vendorId")
    REFERENCES "vendor"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260620173841088', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260620173841088', "timestamp" = now();

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
