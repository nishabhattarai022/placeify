BEGIN;

--
-- ACTION ALTER TABLE
--
CREATE INDEX IF NOT EXISTS "order_vendor_payment_created_at" ON "order_vendor_payment" USING btree ("createdAt");
CREATE INDEX IF NOT EXISTS "order_vendor_payment_vendor_created" ON "order_vendor_payment" USING btree ("vendorId", "createdAt");
CREATE INDEX IF NOT EXISTS "order_vendor_payment_vendor_status" ON "order_vendor_payment" USING btree ("vendorId", "status");
CREATE INDEX IF NOT EXISTS "order_vendor_payment_order_id" ON "order_vendor_payment" USING btree ("orderId");
--
-- ACTION ALTER TABLE
--
CREATE INDEX IF NOT EXISTS "payment_transaction_created_at" ON "payment_transaction" USING btree ("createdAt");
CREATE INDEX IF NOT EXISTS "payment_transaction_user_created" ON "payment_transaction" USING btree ("userId", "createdAt");
CREATE INDEX IF NOT EXISTS "payment_transaction_status_created" ON "payment_transaction" USING btree ("status", "createdAt");

--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260723180342347-payment-ledger-indexes', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260723180342347-payment-ledger-indexes', "timestamp" = now();

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
