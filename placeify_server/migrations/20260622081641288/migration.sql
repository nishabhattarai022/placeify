BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "in_app_notification" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "title" text NOT NULL,
    "message" text NOT NULL,
    "type" text NOT NULL,
    "referenceId" bigint,
    "isRead" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "in_app_notification_user_id" ON "in_app_notification" USING btree ("userId");
CREATE INDEX "in_app_notification_user_unread" ON "in_app_notification" USING btree ("userId", "isRead");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "order" ADD COLUMN "deliveryStatus" text;
ALTER TABLE "order" ADD COLUMN "paymentStatus" text NOT NULL DEFAULT 'unpaid'::text;
ALTER TABLE "order" ADD COLUMN "autoExpiresAt" timestamp without time zone;
ALTER TABLE "order" ADD COLUMN "version" bigint NOT NULL DEFAULT 1;
CREATE INDEX "order_auto_expires_at" ON "order" USING btree ("autoExpiresAt");
--
-- ACTION CREATE TABLE
--
CREATE TABLE "order_status_history" (
    "id" bigserial PRIMARY KEY,
    "orderId" bigint NOT NULL,
    "previousStatus" text,
    "newStatus" text NOT NULL,
    "statusType" text NOT NULL,
    "changedById" uuid,
    "changedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "note" text
);

-- Indexes
CREATE INDEX "order_status_history_order_id" ON "order_status_history" USING btree ("orderId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "in_app_notification"
    ADD CONSTRAINT "in_app_notification_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "order_status_history"
    ADD CONSTRAINT "order_status_history_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "order_status_history"
    ADD CONSTRAINT "order_status_history_fk_1"
    FOREIGN KEY("changedById")
    REFERENCES "user"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260622081641288', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260622081641288', "timestamp" = now();

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
