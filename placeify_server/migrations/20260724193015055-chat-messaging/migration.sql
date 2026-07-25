BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "chat_message" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "conversationId" uuid NOT NULL,
    "senderId" uuid NOT NULL,
    "receiverId" uuid NOT NULL,
    "message" text NOT NULL,
    "messageType" text NOT NULL DEFAULT 'text'::text,
    "isRead" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "chat_message_conversation_id" ON "chat_message" USING btree ("conversationId");
CREATE INDEX "chat_message_conversation_created" ON "chat_message" USING btree ("conversationId", "createdAt");
CREATE INDEX "chat_message_receiver_unread" ON "chat_message" USING btree ("receiverId", "isRead");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "conversation" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "customerId" uuid NOT NULL,
    "vendorId" uuid NOT NULL,
    "lastMessage" text,
    "lastMessageTime" timestamp without time zone,
    "lastSenderId" uuid,
    "unreadCustomerCount" bigint NOT NULL DEFAULT 0,
    "unreadVendorCount" bigint NOT NULL DEFAULT 0,
    "customerDeletedAt" timestamp without time zone,
    "vendorDeletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "conversation_customer_vendor" ON "conversation" USING btree ("customerId", "vendorId");
CREATE INDEX "conversation_customer_id" ON "conversation" USING btree ("customerId");
CREATE INDEX "conversation_vendor_id" ON "conversation" USING btree ("vendorId");
CREATE INDEX "conversation_last_message_time" ON "conversation" USING btree ("lastMessageTime");


--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260724193015055-chat-messaging', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260724193015055-chat-messaging', "timestamp" = now();

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
