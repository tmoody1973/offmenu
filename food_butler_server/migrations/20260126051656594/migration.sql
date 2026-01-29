BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "narrative_caches" (
    "id" bigserial PRIMARY KEY,
    "tourId" bigint NOT NULL,
    "userId" text,
    "narrativeType" text NOT NULL,
    "stopIndex" bigint,
    "content" text NOT NULL,
    "generatedAt" timestamp without time zone NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "cacheHitCount" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "narrative_cache_lookup_idx" ON "narrative_caches" USING btree ("tourId", "userId", "narrativeType", "stopIndex");
CREATE INDEX "narrative_cache_expires_idx" ON "narrative_caches" USING btree ("expiresAt");
CREATE INDEX "narrative_cache_tour_idx" ON "narrative_caches" USING btree ("tourId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "narrative_regenerate_limits" (
    "id" bigserial PRIMARY KEY,
    "tourId" bigint NOT NULL,
    "userId" text NOT NULL,
    "limitDate" timestamp without time zone NOT NULL,
    "attemptCount" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "narrative_regenerate_lookup_idx" ON "narrative_regenerate_limits" USING btree ("tourId", "userId", "limitDate");
CREATE INDEX "narrative_regenerate_date_idx" ON "narrative_regenerate_limits" USING btree ("limitDate");


--
-- MIGRATION VERSION FOR food_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('food_butler', '20260126051656594', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260126051656594', "timestamp" = now();

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
