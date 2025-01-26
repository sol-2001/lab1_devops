package com.example.todo_backend;

import com.example.todo_backend.entity.Task;
import com.example.todo_backend.repository.TaskRepository;
import com.example.todo_backend.service.TaskService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.test.context.ActiveProfiles;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@ActiveProfiles("test")
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


    @Test
    void testGetAllTasks() {
        Task t1 = new Task(1L, "Task 1", false);
        Task t2 = new Task(2L, "Task 2", true);

        Mockito.when(repo.findAll()).thenReturn(Arrays.asList(t1, t2));

        List<Task> tasks = service.getAllTasks();
        Assertions.assertEquals(2, tasks.size());
        Assertions.assertEquals("Task 1", tasks.get(0).getTitle());
        Assertions.assertFalse(tasks.get(0).isCompleted());
        Assertions.assertEquals("Task 2", tasks.get(1).getTitle());
        Assertions.assertTrue(tasks.get(1).isCompleted());
    }

    @Test
    void testGetTask() {
        Task t = new Task(1L, "Some title", false);
        Mockito.when(repo.findById(1L)).thenReturn(Optional.of(t));

        Optional<Task> result = service.getTask(1L);
        Assertions.assertTrue(result.isPresent());
        Assertions.assertEquals("Some title", result.get().getTitle());
        Assertions.assertFalse(result.get().isCompleted());
    }

    @Test
    void testGetTaskNotFound() {
        Mockito.when(repo.findById(999L)).thenReturn(Optional.empty());

        Optional<Task> result = service.getTask(999L);
        Assertions.assertFalse(result.isPresent());
    }

    @Test
    void testDeleteTask() {
        service.deleteTask(123L);
        Mockito.verify(repo).deleteById(123L);
    }
}
