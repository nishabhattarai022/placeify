BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "complaint" (
    "id" bigserial PRIMARY KEY,
    "productId" bigint NOT NULL,
    "reportedById" uuid NOT NULL,
    "reason" text NOT NULL,
    "description" text NOT NULL,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "complaint_product_id" ON "complaint" USING btree ("productId");
CREATE INDEX "complaint_reported_by_id" ON "complaint" USING btree ("reportedById");
CREATE INDEX "complaint_status" ON "complaint" USING btree ("status");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "product" ADD COLUMN "removedReason" text;
ALTER TABLE "product" ADD COLUMN "removedById" uuid;
ALTER TABLE "product" ADD COLUMN "removedAt" timestamp without time zone;
ALTER TABLE "product" ADD COLUMN "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP;
CREATE INDEX "product_status" ON "product" USING btree ("status");
--
-- ACTION ALTER TABLE
--
ALTER TABLE "user" ADD COLUMN "email" text;
ALTER TABLE "user" ADD COLUMN "profileImageUrl" text;
ALTER TABLE "user" ADD COLUMN "status" text NOT NULL DEFAULT 'approved'::text;
ALTER TABLE "user" ADD COLUMN "isActive" boolean NOT NULL DEFAULT true;
ALTER TABLE "user" ADD COLUMN "deletedAt" timestamp without time zone;
ALTER TABLE "user" ADD COLUMN "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP;
CREATE UNIQUE INDEX "user_email" ON "user" USING btree ("email");
CREATE INDEX "user_role" ON "user" USING btree ("role");
CREATE INDEX "user_status" ON "user" USING btree ("status");
--
-- ACTION ALTER TABLE
--
ALTER TABLE "vendor" ADD COLUMN "businessAddress" text;
ALTER TABLE "vendor" ADD COLUMN "approvedById" uuid;
ALTER TABLE "vendor" ADD COLUMN "approvedAt" timestamp without time zone;
ALTER TABLE "vendor" ADD COLUMN "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP;
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

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "product"
    ADD CONSTRAINT "product_fk_2"
    FOREIGN KEY("removedById")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "vendor"
    ADD CONSTRAINT "vendor_fk_1"
    FOREIGN KEY("approvedById")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260613034522382', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260613034522382', "timestamp" = now();

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
