package br.com.techthordev.backend.entities;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "health_checks")
public class HealthCheck {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "service_id", nullable = false)
    private Service service;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private HealthStatus status;

    @Column
    private Short httpStatus;

    @Column
    private Integer latencyMs;

    @Column(columnDefinition = "TEXT")
    private String errorMessage;

    @Column(nullable = false, updatable = false)
    private Instant checkedAt;

    @PrePersist
    private void onCreate() {
        checkedAt = Instant.now();
    }

    public HealthCheck() {}

    public HealthCheck(Service service, HealthStatus status, Short httpStatus,
                       Integer latencyMs, String errorMessage) {
        this.service = service;
        this.status = status;
        this.httpStatus = httpStatus;
        this.latencyMs = latencyMs;
        this.errorMessage = errorMessage;
    }

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Service getService() { return service; }
    public void setService(Service service) { this.service = service; }

    public HealthStatus getStatus() { return status; }
    public void setStatus(HealthStatus status) { this.status = status; }

    public Short getHttpStatus() { return httpStatus; }
    public void setHttpStatus(Short httpStatus) { this.httpStatus = httpStatus; }

    public Integer getLatencyMs() { return latencyMs; }
    public void setLatencyMs(Integer latencyMs) { this.latencyMs = latencyMs; }

    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }

    public Instant getCheckedAt() { return checkedAt; }
}