-- ============================================================
-- V1__init.sql
-- OmniCheck Platform – Initial Schema
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ------------------------------------------------------------
-- SERVICES
-- ------------------------------------------------------------
CREATE TABLE services (
    id          UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        VARCHAR(120) NOT NULL,
    url         VARCHAR(500) NOT NULL,
    description TEXT,
    enabled     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    CONSTRAINT services_url_unique UNIQUE (url),
    CONSTRAINT services_url_check  CHECK  (url ~* '^https?://')
);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_services_updated_at
    BEFORE UPDATE ON services
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ------------------------------------------------------------
-- HEALTH_CHECKS
-- ------------------------------------------------------------
CREATE TABLE health_checks (
    id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    service_id    UUID        NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    status        VARCHAR(20) NOT NULL,
    http_status   SMALLINT,
    latency_ms    INTEGER,
    error_message TEXT,
    checked_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT health_checks_status_check
        CHECK (status IN ('UP', 'DOWN', 'DEGRADED', 'UNKNOWN', 'MAINTENANCE')),
    CONSTRAINT health_checks_latency_ms_check
        CHECK (latency_ms >= 0)
);

CREATE INDEX idx_health_checks_service_id ON health_checks(service_id);
CREATE INDEX idx_health_checks_checked_at ON health_checks(checked_at DESC);
CREATE INDEX idx_health_checks_status     ON health_checks(status);

-- ------------------------------------------------------------
-- SEED DATA (dev only)
-- ------------------------------------------------------------
INSERT INTO services (name, url, description) VALUES
    ('Backend API', 'http://localhost:8080/actuator/health', 'Spring Boot backend'),
    ('Frontend',    'http://localhost:4200',                 'Angular SPA');