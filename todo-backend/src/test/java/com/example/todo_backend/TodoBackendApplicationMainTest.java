package com.example.todo_backend;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest(properties = {"spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration"})
@ActiveProfiles("test")
public class TodoBackendApplicationMainTest {

    @Test
    void mainTest() {
        TodoBackendApplication.main(new String[]{});
    }
}
