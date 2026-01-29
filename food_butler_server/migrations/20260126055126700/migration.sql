BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "journal_entries" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "restaurantId" bigint NOT NULL,
    "tourId" bigint,
    "tourStopId" bigint,
    "rating" bigint NOT NULL,
    "notes" text,
    "visitedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "journal_entry_user_id_idx" ON "journal_entries" USING btree ("userId");
CREATE INDEX "journal_entry_restaurant_id_idx" ON "journal_entries" USING btree ("restaurantId");
CREATE INDEX "journal_entry_tour_id_idx" ON "journal_entries" USING btree ("tourId");
CREATE INDEX "journal_entry_visited_at_idx" ON "journal_entries" USING btree ("visitedAt");
CREATE INDEX "journal_entry_user_visited_idx" ON "journal_entries" USING btree ("userId", "visitedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "journal_photos" (
    "id" bigserial PRIMARY KEY,
    "journalEntryId" bigint NOT NULL,
    "originalUrl" text NOT NULL,
    "thumbnailUrl" text NOT NULL,
    "displayOrder" bigint NOT NULL,
    "uploadedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "journal_photo_entry_id_idx" ON "journal_photos" USING btree ("journalEntryId");
CREATE INDEX "journal_photo_entry_order_idx" ON "journal_photos" USING btree ("journalEntryId", "displayOrder");


--
-- MIGRATION VERSION FOR food_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('food_butler', '20260126055126700', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260126055126700', "timestamp" = now();

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
