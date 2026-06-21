BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "vendor_document" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "vendorId" uuid,
    "documentType" text NOT NULL,
    "fileUrl" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "vendor_document_user_type" ON "vendor_document" USING btree ("userId", "documentType");
CREATE INDEX "vendor_document_vendor_id" ON "vendor_document" USING btree ("vendorId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "vendor_document"
    ADD CONSTRAINT "vendor_document_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "vendor_document"
    ADD CONSTRAINT "vendor_document_fk_1"
    FOREIGN KEY("vendorId")
    REFERENCES "vendor"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260618111046000', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260618111046000', "timestamp" = now();

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
