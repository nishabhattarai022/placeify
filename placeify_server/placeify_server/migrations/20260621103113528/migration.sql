BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "vendor_bank_details" (
    "id" bigserial PRIMARY KEY,
    "vendorId" uuid NOT NULL,
    "accountHolderName" text NOT NULL,
    "bankName" text NOT NULL,
    "accountNumber" text NOT NULL,
    "branchCode" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "vendor_bank_details_vendor_id" ON "vendor_bank_details" USING btree ("vendorId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "vendor_bank_details"
    ADD CONSTRAINT "vendor_bank_details_fk_0"
    FOREIGN KEY("vendorId")
    REFERENCES "vendor"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260621103113528', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260621103113528', "timestamp" = now();

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
