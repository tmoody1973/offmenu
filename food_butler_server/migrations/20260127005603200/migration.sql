BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "curated_maps" (
    "id" bigserial PRIMARY KEY,
    "userId" text,
    "isUserCreated" boolean NOT NULL,
    "cityName" text NOT NULL,
    "stateOrRegion" text,
    "country" text NOT NULL,
    "title" text NOT NULL,
    "slug" text NOT NULL,
    "category" text NOT NULL,
    "cuisineType" text,
    "shortDescription" text NOT NULL,
    "introText" text,
    "coverImageUrl" text,
    "restaurantCount" bigint NOT NULL,
    "lastUpdatedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "isPublished" boolean NOT NULL
);

-- Indexes
CREATE INDEX "curated_map_city_idx" ON "curated_maps" USING btree ("cityName");
CREATE UNIQUE INDEX "curated_map_slug_idx" ON "curated_maps" USING btree ("slug");
CREATE INDEX "curated_map_category_idx" ON "curated_maps" USING btree ("category");
CREATE INDEX "curated_map_city_category_idx" ON "curated_maps" USING btree ("cityName", "category");
CREATE INDEX "curated_map_user_id_idx" ON "curated_maps" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "favorite_cities" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "cityName" text NOT NULL,
    "stateOrRegion" text,
    "country" text NOT NULL,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "isHomeCity" boolean NOT NULL,
    "displayOrder" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "favorite_city_user_id_idx" ON "favorite_cities" USING btree ("userId");
CREATE INDEX "favorite_city_user_order_idx" ON "favorite_cities" USING btree ("userId", "displayOrder");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "map_restaurants" (
    "id" bigserial PRIMARY KEY,
    "mapId" bigint NOT NULL,
    "name" text NOT NULL,
    "googlePlaceId" text,
    "editorialDescription" text NOT NULL,
    "whyNotable" text,
    "mustOrderDishes" text,
    "priceLevel" bigint,
    "cuisineTypes" text,
    "address" text NOT NULL,
    "city" text NOT NULL,
    "stateOrRegion" text,
    "postalCode" text,
    "phoneNumber" text,
    "websiteUrl" text,
    "reservationUrl" text,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "primaryPhotoUrl" text,
    "additionalPhotosJson" text,
    "googleRating" double precision,
    "googleReviewCount" bigint,
    "displayOrder" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "map_restaurant_map_id_idx" ON "map_restaurants" USING btree ("mapId");
CREATE INDEX "map_restaurant_place_id_idx" ON "map_restaurants" USING btree ("googlePlaceId");
CREATE INDEX "map_restaurant_city_idx" ON "map_restaurants" USING btree ("city");


--
-- MIGRATION VERSION FOR food_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('food_butler', '20260127005603200', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260127005603200', "timestamp" = now();

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
