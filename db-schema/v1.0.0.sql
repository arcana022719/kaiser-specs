-- Kaiser MVP Database Schema (Supabase PostgreSQL)
-- Version: v1.0.0
-- Conventions:
--   * Server-only surrogate primary key: id bigint GENERATED ALWAYS AS IDENTITY
--   * Global identity & relationships: uuid and *_uuid (no server REFERENCES on offline-synced tables)
--   * Soft delete: archived_at timestamptz
--   * Change column: updated_at timestamptz
--   * Privacy by design: raw_signal uses 24h rotating ephemeral_actor_hash (no account_uuid, no raw GPS)

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Enums (idempotent)
-- ---------------------------------------------------------------------------
DO $$ BEGIN
  CREATE TYPE public.zone_density_tier AS ENUM ('urban_campus', 'rural');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE TYPE public.baseline_node_type AS ENUM ('transit_hub', 'bank_atm', 'road_corridor', 'emergency_contact');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE TYPE public.signal_category AS ENUM ('utilities', 'commute', 'atm_cash', 'road_hazard');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE TYPE public.signal_action_type AS ENUM ('report', 'confirm', 'back_to_normal');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE TYPE public.consensus_state AS ENUM ('PENDING', 'CONFIRMED', 'RESOLVED');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- ---------------------------------------------------------------------------
-- 2. Reference & Baseline Tables (Zero-Ping Offline Layer)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.zone (
  id                  bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  uuid                uuid NOT NULL UNIQUE,
  code                text NOT NULL,
  name                text NOT NULL,
  density_tier        public.zone_density_tier NOT NULL DEFAULT 'rural',
  consensus_threshold integer NOT NULL DEFAULT 2,
  center_lat          double precision NOT NULL,
  center_lng          double precision NOT NULL,
  hex_resolution      integer NOT NULL DEFAULT 8,
  created_by          uuid,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  archived_at         timestamptz,
  CONSTRAINT zone_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_zone_code_live
  ON public.zone (code) WHERE archived_at IS NULL;

CREATE TABLE IF NOT EXISTS public.baseline_node (
  id          bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  uuid        uuid NOT NULL UNIQUE,
  zone_uuid   uuid NOT NULL,
  node_type   public.baseline_node_type NOT NULL,
  name        text NOT NULL,
  metadata    jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_by  uuid,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  archived_at timestamptz,
  CONSTRAINT baseline_node_pkey PRIMARY KEY (id)
);
CREATE INDEX IF NOT EXISTS idx_baseline_node_zone
  ON public.baseline_node (zone_uuid) WHERE archived_at IS NULL;

-- ---------------------------------------------------------------------------
-- 3. Crowdsourced Signals & Consensus Aggregates
-- ---------------------------------------------------------------------------
-- Raw signals are hard-deleted upon TTL expiration. No account_uuid or raw GPS stored.
CREATE TABLE IF NOT EXISTS public.raw_signal (
  id                   bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  uuid                 uuid NOT NULL UNIQUE,
  zone_uuid            uuid NOT NULL,
  category             public.signal_category NOT NULL,
  status_enum          text NOT NULL,
  action_type          public.signal_action_type NOT NULL DEFAULT 'report',
  ephemeral_actor_hash text NOT NULL,
  expires_at           timestamptz NOT NULL,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),
  archived_at          timestamptz,
  CONSTRAINT raw_signal_pkey PRIMARY KEY (id)
);
CREATE INDEX IF NOT EXISTS idx_raw_signal_zone_cat
  ON public.raw_signal (zone_uuid, category, status_enum) WHERE archived_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_raw_signal_expires_at
  ON public.raw_signal (expires_at);
CREATE UNIQUE INDEX IF NOT EXISTS idx_raw_signal_actor_dedup
  ON public.raw_signal (zone_uuid, category, status_enum, action_type, ephemeral_actor_hash)
  WHERE archived_at IS NULL;

CREATE TABLE IF NOT EXISTS public.status_aggregate (
  id              bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  uuid            uuid NOT NULL UNIQUE,
  zone_uuid       uuid NOT NULL,
  category        public.signal_category NOT NULL,
  status_enum     text NOT NULL,
  consensus_state public.consensus_state NOT NULL DEFAULT 'PENDING',
  confirm_count   integer NOT NULL DEFAULT 1,
  normal_count    integer NOT NULL DEFAULT 0,
  valid_until     timestamptz NOT NULL,
  resolved_at     timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  archived_at     timestamptz,
  CONSTRAINT status_aggregate_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_status_aggregate_active
  ON public.status_aggregate (zone_uuid, category, status_enum)
  WHERE archived_at IS NULL AND resolved_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_status_aggregate_valid
  ON public.status_aggregate (valid_until)
  WHERE archived_at IS NULL AND resolved_at IS NULL;

-- ---------------------------------------------------------------------------
-- 4. Silent Abuse Enforcement & RA 10173 Compliance
-- ---------------------------------------------------------------------------
-- Server-only internal log; never exposed in public map/feed responses.
CREATE TABLE IF NOT EXISTS public.guideline_strike (
  id               bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  uuid             uuid NOT NULL UNIQUE,
  account_uuid     uuid NOT NULL,
  reason_code      text NOT NULL,
  cooldown_minutes integer NOT NULL,
  cooldown_until   timestamptz NOT NULL,
  issued_by        uuid,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),
  archived_at      timestamptz,
  CONSTRAINT guideline_strike_pkey PRIMARY KEY (id)
);
CREATE INDEX IF NOT EXISTS idx_guideline_strike_account
  ON public.guideline_strike (account_uuid, cooldown_until) WHERE archived_at IS NULL;

CREATE TABLE IF NOT EXISTS public.consent_record (
  id                  bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  uuid                uuid NOT NULL UNIQUE,
  account_uuid        uuid NOT NULL,
  consent_type        text NOT NULL,
  granted             boolean NOT NULL DEFAULT false,
  data_resale_consent boolean NOT NULL DEFAULT false,
  policy_version      text NOT NULL,
  revoked_at          timestamptz,
  created_by          uuid,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  archived_at         timestamptz,
  CONSTRAINT consent_record_pkey PRIMARY KEY (id)
);
CREATE INDEX IF NOT EXISTS idx_consent_record_account
  ON public.consent_record (account_uuid, consent_type) WHERE archived_at IS NULL;

-- ---------------------------------------------------------------------------
-- 5. System Configuration (Settings as Rows)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.system_config (
  id          bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  uuid        uuid NOT NULL UNIQUE,
  feature     text NOT NULL,
  name        text NOT NULL,
  value       text NOT NULL,
  created_by  uuid,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  archived_at timestamptz,
  CONSTRAINT system_config_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_system_config_key_live
  ON public.system_config (feature, name) WHERE archived_at IS NULL;

COMMIT;
