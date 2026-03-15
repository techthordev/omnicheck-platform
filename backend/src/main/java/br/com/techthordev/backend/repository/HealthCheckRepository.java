package br.com.techthordev.backend.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import br.com.techthordev.backend.entities.HealthCheck;
import br.com.techthordev.backend.entities.HealthStatus;

public interface HealthCheckRepository extends JpaRepository<HealthCheck, UUID> {

	List<HealthCheck> findByServiceId(UUID serviceId);
	
	List<HealthCheck> findByServiceIdOrderByCheckedAtDesc(UUID serviceId);
	
	List<HealthCheck> findByStatus(HealthStatus status);
	
}