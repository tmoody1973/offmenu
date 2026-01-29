BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "award_import_logs" (
    "id" bigserial PRIMARY KEY,
    "importType" text NOT NULL,
    "fileName" text NOT NULL,
    "recordsImported" bigint NOT NULL,
    "recordsMatched" bigint NOT NULL,
    "recordsPendingReview" bigint NOT NULL,
    "importedByUserId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "award_import_log_type_idx" ON "award_import_logs" USING btree ("importType");
CREATE INDEX "award_import_log_created_idx" ON "award_import_logs" USING btree ("createdAt");
CREATE INDEX "award_import_log_user_idx" ON "award_import_logs" USING btree ("importedByUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "james_beard_awards" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "city" text NOT NULL,
    "category" text NOT NULL,
    "distinctionLevel" text NOT NULL,
    "awardYear" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "james_beard_name_city_idx" ON "james_beard_awards" USING btree ("name", "city");
CREATE INDEX "james_beard_category_idx" ON "james_beard_awards" USING btree ("category");
CREATE INDEX "james_beard_distinction_idx" ON "james_beard_awards" USING btree ("distinctionLevel");
CREATE INDEX "james_beard_year_idx" ON "james_beard_awards" USING btree ("awardYear");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "michelin_awards" (
    "id" bigserial PRIMARY KEY,
    "restaurantName" text NOT NULL,
    "city" text NOT NULL,
    "address" text,
    "latitude" double precision,
    "longitude" double precision,
    "designation" text NOT NULL,
    "awardYear" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "michelin_name_city_idx" ON "michelin_awards" USING btree ("restaurantName", "city");
CREATE INDEX "michelin_designation_idx" ON "michelin_awards" USING btree ("designation");
CREATE INDEX "michelin_year_idx" ON "michelin_awards" USING btree ("awardYear");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "restaurant_award_links" (
    "id" bigserial PRIMARY KEY,
    "restaurantId" bigint NOT NULL,
    "awardType" text NOT NULL,
    "awardId" bigint NOT NULL,
    "matchConfidenceScore" double precision NOT NULL,
    "matchStatus" text NOT NULL,
    "matchedByUserId" bigint,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "restaurant_award_link_restaurant_idx" ON "restaurant_award_links" USING btree ("restaurantId");
CREATE INDEX "restaurant_award_link_status_idx" ON "restaurant_award_links" USING btree ("matchStatus");
CREATE INDEX "restaurant_award_link_type_award_idx" ON "restaurant_award_links" USING btree ("awardType", "awardId");


--
-- MIGRATION VERSION FOR food_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('food_butler', '20260126022644361', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260126022644361', "timestamp" = now();

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
