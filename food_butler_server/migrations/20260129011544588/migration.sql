BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "daily_stories" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "storyDate" text NOT NULL,
    "city" text NOT NULL,
    "state" text,
    "country" text,
    "headline" text NOT NULL,
    "subheadline" text NOT NULL,
    "bodyText" text,
    "restaurantName" text NOT NULL,
    "restaurantAddress" text,
    "restaurantPlaceId" text,
    "heroImageUrl" text NOT NULL,
    "thumbnailUrl" text,
    "storyType" text NOT NULL,
    "cuisineType" text,
    "sourceUrl" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "daily_story_user_date_idx" ON "daily_stories" USING btree ("userId", "storyDate");


--
-- MIGRATION VERSION FOR food_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('food_butler', '20260129011544588', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129011544588', "timestamp" = now();

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
