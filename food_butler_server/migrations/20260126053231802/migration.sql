BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "reservation_click_events" (
    "id" bigserial PRIMARY KEY,
    "restaurantId" bigint NOT NULL,
    "linkType" text NOT NULL,
    "userId" text,
    "launchSuccess" boolean NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "reservation_click_restaurant_idx" ON "reservation_click_events" USING btree ("restaurantId");
CREATE INDEX "reservation_click_timestamp_idx" ON "reservation_click_events" USING btree ("timestamp");
CREATE INDEX "reservation_click_link_type_idx" ON "reservation_click_events" USING btree ("linkType");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "restaurants" ADD COLUMN "opentableId" text;
ALTER TABLE "restaurants" ADD COLUMN "opentableSlug" text;
ALTER TABLE "restaurants" ADD COLUMN "phone" text;
ALTER TABLE "restaurants" ADD COLUMN "websiteUrl" text;
CREATE INDEX "restaurant_opentable_id_idx" ON "restaurants" USING btree ("opentableId");

--
-- MIGRATION VERSION FOR food_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('food_butler', '20260126053231802', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260126053231802', "timestamp" = now();

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
