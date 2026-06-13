BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "refund_request" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "orderId" bigint NOT NULL,
    "reason" text NOT NULL,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "refundAmount" double precision NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "refund_request_user_id" ON "refund_request" USING btree ("userId");
CREATE INDEX "refund_request_order_id" ON "refund_request" USING btree ("orderId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "refund_request"
    ADD CONSTRAINT "refund_request_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "refund_request"
    ADD CONSTRAINT "refund_request_fk_1"
    FOREIGN KEY("orderId")
    REFERENCES "order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260613181356657', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260613181356657', "timestamp" = now();

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
