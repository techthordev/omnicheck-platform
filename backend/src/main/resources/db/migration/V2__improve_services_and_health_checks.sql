-- V2__improve_services_and_health_checks.sql

-- Services improvements
ALTER TABLE services
    ALTER COLUMN name TYPE VARCHAR(120);

ALTER TABLE services
    ADD CONSTRAINT services_url_unique UNIQUE (url);

ALTER TABLE services
    ADD CONSTRAINT services_url_check CHECK (url ~* '^https?://');

ALTER TABLE services
    ALTER COLUMN description TYPE TEXT;

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_services_updated_at ON services;

CREATE TRIGGER update_services_updated_at
    BEFORE UPDATE ON services
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Health checks improvements
ALTER TABLE health_checks
    RENAME COLUMN message TO error_message;

ALTER TABLE health_checks
    ALTER COLUMN status TYPE VARCHAR(20),
    ADD CONSTRAINT health_checks_status_check CHECK (status IN ('UP', 'DOWN', 'DEGRADED', 'UNKNOWN', 'MAINTENANCE'));

ALTER TABLE health_checks
    ALTER COLUMN http_status TYPE SMALLINT;

ALTER TABLE health_checks
    RENAME COLUMN response_ms TO latency_ms;

ALTER TABLE health_checks
    ADD CONSTRAINT health_checks_latency_ms_check CHECK (latency_ms >= 0);

CREATE INDEX IF NOT EXISTS idx_health_checks_status ON health_checks(status);