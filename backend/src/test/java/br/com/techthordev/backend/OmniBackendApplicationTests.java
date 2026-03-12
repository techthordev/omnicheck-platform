package br.com.techthordev.backend;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

@SpringBootTest
@TestPropertySource(properties = {
    "spring.autoconfigure.exclude=" +
    "org.springframework.boot.jdbc.autoconfigure.DataSourceAutoConfiguration," +
    "org.springframework.boot.flyway.autoconfigure.FlywayAutoConfiguration," +
    "org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration"
})
class OmniBackendApplicationTests {

    @Test
    void contextLoads() {
    }
}