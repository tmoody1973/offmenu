BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "restaurants" ADD COLUMN "description" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "tour_requests" ADD COLUMN "specificDish" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "tour_results" ADD COLUMN "tourTitle" text;
ALTER TABLE "tour_results" ADD COLUMN "tourIntroduction" text;
ALTER TABLE "tour_results" ADD COLUMN "tourVibe" text;
ALTER TABLE "tour_results" ADD COLUMN "tourClosing" text;
ALTER TABLE "tour_results" ADD COLUMN "curatedTourJson" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_profiles" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "foodPhilosophy" text,
    "adventureLevel" text,
    "familiarCuisines" text,
    "wantToTryCuisines" text,
    "dietaryRestrictions" text,
    "homeCity" text,
    "homeState" text,
    "homeCountry" text,
    "homeLatitude" double precision,
    "homeLongitude" double precision,
    "onboardingCompleted" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_profile_user_id_idx" ON "user_profiles" USING btree ("userId");
CREATE INDEX "user_profile_home_city_idx" ON "user_profiles" USING btree ("homeCity");


--
-- MIGRATION VERSION FOR food_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('food_butler', '20260127002850198', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260127002850198', "timestamp" = now();

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
