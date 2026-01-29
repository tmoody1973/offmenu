BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "saved_restaurants" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "name" text NOT NULL,
    "placeId" text,
    "address" text,
    "cuisineType" text,
    "imageUrl" text,
    "rating" double precision,
    "priceLevel" bigint,
    "notes" text,
    "userRating" bigint,
    "source" text NOT NULL,
    "savedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "saved_restaurant_user_idx" ON "saved_restaurants" USING btree ("userId");
CREATE UNIQUE INDEX "saved_restaurant_user_place_idx" ON "saved_restaurants" USING btree ("userId", "placeId");


--
-- MIGRATION VERSION FOR food_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('food_butler', '20260129134907549', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129134907549', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
