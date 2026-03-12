-- ============================================================
-- V1__init.sql
-- OmniCheck Platform – Initial Schema
-- ============================================================

-- ------------------------------------------------------------
-- EXTENSION
-- ------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ------------------------------------------------------------
-- SERVICES (monitored endpoints / hosts)
-- ------------------------------------------------------------
CREATE TABLE services (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        VARCHAR(100)  NOT NULL,
    url         VARCHAR(500)  NOT NULL,
    description VARCHAR(500),
    enabled     BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- ------------------------------------------------------------
-- HEALTH_CHECKS (result of each check run)
-- ------------------------------------------------------------
CREATE TABLE health_checks (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    service_id  UUID          NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    status      VARCHAR(20)   NOT NULL,   -- UP | DOWN | DEGRADED | UNKNOWN
    http_status INTEGER,
    response_ms INTEGER,
    message     TEXT,
    checked_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_health_checks_service_id ON health_checks(service_id);
CREATE INDEX idx_health_checks_checked_at ON health_checks(checked_at DESC);

-- ------------------------------------------------------------
-- SEED DATA (dev only)
-- ------------------------------------------------------------
INSERT INTO services (name, url, description) VALUES
    ('Backend API', 'http://localhost:8080/actuator/health', 'Spring Boot backend'),
    ('Frontend',    'http://localhost:4200',                 'Angular SPA');