BEGIN;

--
-- ACTION ALTER TABLE
--
CREATE INDEX "order_status" ON "order" USING btree ("status");
--
-- ACTION ALTER TABLE
--
CREATE INDEX "order_item_vendor_id" ON "order_item" USING btree ("vendorId");
CREATE INDEX "order_item_vendor_order" ON "order_item" USING btree ("vendorId", "orderId");
--
-- ACTION ALTER TABLE
--
CREATE INDEX "product_category_id" ON "product" USING btree ("categoryId");
--
-- ACTION ALTER TABLE
--
CREATE INDEX "refund_request_status" ON "refund_request" USING btree ("status");

--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260620165547527', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260620165547527', "timestamp" = now();

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
