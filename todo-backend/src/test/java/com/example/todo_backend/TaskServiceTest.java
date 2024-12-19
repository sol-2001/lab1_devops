package com.example.todo_backend;

import com.example.todo_backend.entity.Task;
import com.example.todo_backend.repository.TaskRepository;
import com.example.todo_backend.service.TaskService;
import org.aspectj.lang.annotation.Before;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.util.Optional;

public class TaskServiceTest {

    private TaskRepository repo = Mockito.mock(TaskRepository.class);
    private TaskService service = new TaskService(repo);

    @BeforeEach()
    void setup() {
        Mockito.reset(repo);
    }

    @Test
    void testCreateTask() {
        Task mockTask = new Task(1L, "Test task", false);
        Mockito.when(repo.save(Mockito.any(Task.class))).thenReturn(mockTask);

        Task created = service.createTask("Test task");
        Assertions.assertEquals("Test task", created.getTitle());
    }

    @Test
    void testUpdateTask() {
        Task existing = new Task(1L, "Old title", false);
        Mockito.when(repo.findById(1L)).thenReturn(Optional.of(existing));
        Mockito.when(repo.save(Mockito.any(Task.class))).thenAnswer(i -> i.getArguments()[0]);

        Optional<Task> updated = service.updateTask(1L, "New title", true);
        Assertions.assertTrue(updated.isPresent());
        Assertions.assertEquals("New title", updated.get().getTitle());
        Assertions.assertTrue(updated.get().isCompleted());
    }
}
