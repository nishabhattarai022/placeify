BEGIN;

--
-- REPAIR: idempotent schema alignment for dev/test DBs that registered
-- 20260622153000000 without applying 20260622081641288 (and related) DDL.
--

ALTER TABLE "vendor" ADD COLUMN IF NOT EXISTS "contactEmail" text;

CREATE TABLE IF NOT EXISTS "vendor_bank_details" (
    "id" bigserial PRIMARY KEY,
    "vendorId" uuid NOT NULL,
    "accountHolderName" text NOT NULL,
    "bankName" text NOT NULL,
    "accountNumber" text NOT NULL,
    "branchCode" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS "vendor_bank_details_vendor_id"
    ON "vendor_bank_details" USING btree ("vendorId");

DO $$ BEGIN
  ALTER TABLE ONLY "vendor_bank_details"
    ADD CONSTRAINT "vendor_bank_details_fk_0"
    FOREIGN KEY("vendorId")
    REFERENCES "vendor"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

ALTER TABLE "payment_transaction"
  ADD COLUMN IF NOT EXISTS "paymentMethod" text NOT NULL DEFAULT 'mockOnline'::text;

CREATE TABLE IF NOT EXISTS "in_app_notification" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "title" text NOT NULL,
    "message" text NOT NULL,
    "type" text NOT NULL,
    "referenceId" bigint,
    "isRead" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS "in_app_notification_user_id"
    ON "in_app_notification" USING btree ("userId");
CREATE INDEX IF NOT EXISTS "in_app_notification_user_unread"
    ON "in_app_notification" USING btree ("userId", "isRead");

ALTER TABLE "order" ADD COLUMN IF NOT EXISTS "deliveryStatus" text;
ALTER TABLE "order" ADD COLUMN IF NOT EXISTS "paymentStatus" text NOT NULL DEFAULT 'unpaid'::text;
ALTER TABLE "order" ADD COLUMN IF NOT EXISTS "autoExpiresAt" timestamp without time zone;
ALTER TABLE "order" ADD COLUMN IF NOT EXISTS "version" bigint NOT NULL DEFAULT 1;

CREATE INDEX IF NOT EXISTS "order_auto_expires_at"
    ON "order" USING btree ("autoExpiresAt");

CREATE TABLE IF NOT EXISTS "order_status_history" (
    "id" bigserial PRIMARY KEY,
    "orderId" bigint NOT NULL,
    "previousStatus" text,
    "newStatus" text NOT NULL,
    "statusType" text NOT NULL,
    "changedById" uuid,
    "changedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "note" text
);

CREATE INDEX IF NOT EXISTS "order_status_history_order_id"
    ON "order_status_history" USING btree ("orderId");

DO $$ BEGIN
  ALTER TABLE ONLY "in_app_notification"
    ADD CONSTRAINT "in_app_notification_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  ALTER TABLE ONLY "order_status_history"
    ADD CONSTRAINT "order_status_history_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  ALTER TABLE ONLY "order_status_history"
    ADD CONSTRAINT "order_status_history_fk_1"
    FOREIGN KEY("changedById")
    REFERENCES "user"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260624150000000', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260624150000000', "timestamp" = now();

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
