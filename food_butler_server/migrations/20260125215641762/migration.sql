BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "awards" (
    "id" bigserial PRIMARY KEY,
    "restaurantFsqId" text NOT NULL,
    "awardType" text NOT NULL,
    "awardLevel" text NOT NULL,
    "year" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "award_restaurant_idx" ON "awards" USING btree ("restaurantFsqId");
CREATE INDEX "award_type_idx" ON "awards" USING btree ("awardType");
CREATE INDEX "award_year_idx" ON "awards" USING btree ("year");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "cached_foursquare_responses" (
    "id" bigserial PRIMARY KEY,
    "cacheKey" text NOT NULL,
    "responseData" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "cached_foursquare_cache_key_unique_idx" ON "cached_foursquare_responses" USING btree ("cacheKey");
CREATE INDEX "cached_foursquare_expires_idx" ON "cached_foursquare_responses" USING btree ("expiresAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "cached_routes" (
    "id" bigserial PRIMARY KEY,
    "waypointsHash" text NOT NULL,
    "transportMode" text NOT NULL,
    "polyline" text NOT NULL,
    "distanceMeters" bigint NOT NULL,
    "durationSeconds" bigint NOT NULL,
    "legsJson" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "cached_route_hash_mode_unique_idx" ON "cached_routes" USING btree ("waypointsHash", "transportMode");
CREATE INDEX "cached_route_expires_idx" ON "cached_routes" USING btree ("expiresAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "restaurants" (
    "id" bigserial PRIMARY KEY,
    "fsqId" text NOT NULL,
    "name" text NOT NULL,
    "address" text NOT NULL,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "priceTier" bigint NOT NULL,
    "rating" double precision,
    "cuisineTypes" json NOT NULL,
    "hours" text,
    "dishData" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "restaurant_fsq_id_unique_idx" ON "restaurants" USING btree ("fsqId");
CREATE INDEX "restaurant_coordinates_idx" ON "restaurants" USING btree ("latitude", "longitude");
CREATE INDEX "restaurant_price_tier_idx" ON "restaurants" USING btree ("priceTier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "tour_requests" (
    "id" bigserial PRIMARY KEY,
    "startLatitude" double precision NOT NULL,
    "startLongitude" double precision NOT NULL,
    "startAddress" text,
    "numStops" bigint NOT NULL,
    "transportMode" text NOT NULL,
    "cuisinePreferences" json,
    "awardOnly" boolean NOT NULL,
    "startTime" timestamp without time zone NOT NULL,
    "endTime" timestamp without time zone,
    "budgetTier" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "tour_request_created_idx" ON "tour_requests" USING btree ("createdAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "tour_results" (
    "id" bigserial PRIMARY KEY,
    "requestId" bigint NOT NULL,
    "stopsJson" text NOT NULL,
    "confidenceScore" bigint NOT NULL,
    "routePolyline" text NOT NULL,
    "routeLegsJson" text NOT NULL,
    "totalDistanceMeters" bigint NOT NULL,
    "totalDurationSeconds" bigint NOT NULL,
    "isPartialTour" boolean NOT NULL,
    "warningMessage" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "tour_result_request_idx" ON "tour_results" USING btree ("requestId");
CREATE INDEX "tour_result_created_idx" ON "tour_results" USING btree ("createdAt");


--
-- MIGRATION VERSION FOR food_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('food_butler', '20260125215641762', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260125215641762', "timestamp" = now();

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
