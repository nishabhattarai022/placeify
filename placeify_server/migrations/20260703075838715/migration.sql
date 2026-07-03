BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "product" ADD COLUMN "averageRating" double precision NOT NULL DEFAULT 0;
ALTER TABLE "product" ADD COLUMN "reviewCount" bigint NOT NULL DEFAULT 0;

--
-- Backfill rating aggregates for products that already have reviews.
--
UPDATE "product" AS p
SET
  "reviewCount" = stats.review_count,
  "averageRating" = stats.average_rating
FROM (
  SELECT
    "productId",
    COUNT(*)::bigint AS review_count,
    COALESCE(AVG("rating")::double precision, 0) AS average_rating
  FROM "review"
  GROUP BY "productId"
) AS stats
WHERE p.id = stats."productId";

--
-- MIGRATION VERSION FOR placeify
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('placeify', '20260703075838715', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260703075838715', "timestamp" = now();

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
