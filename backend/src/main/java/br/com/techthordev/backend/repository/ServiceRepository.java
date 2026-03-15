package br.com.techthordev.backend.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import br.com.techthordev.backend.entities.Service;

public interface ServiceRepository extends JpaRepository<Service, UUID> {

    Optional<Service> findByUrl(String url);
    
    List<Service> findByEnabledTrue();
	
}