package com.example.todo_backend;

import com.example.todo_backend.controller.TaskController;
import com.example.todo_backend.entity.Task;
import com.example.todo_backend.service.TaskService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.Arrays;
import java.util.Optional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@ActiveProfiles("test")
class TaskControllerTest {

    @Mock
    private TaskService taskService;

    private TaskController controller;

    private MockMvc mockMvc;

    @BeforeEach
    void setup() {
        controller = new TaskController(taskService);
        mockMvc = MockMvcBuilders.standaloneSetup(controller).build();
    }

    @Test
    void testGetAllTasks() throws Exception {
        Task t1 = new Task(1L, "Task 1", false);
        Task t2 = new Task(2L, "Task 2", true);

        Mockito.when(taskService.getAllTasks()).thenReturn(Arrays.asList(t1, t2));

        mockMvc.perform(get("/tasks"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(1))
                .andExpect(jsonPath("$[0].title").value("Task 1"))
                .andExpect(jsonPath("$[0].completed").value(false))
                .andExpect(jsonPath("$[1].id").value(2))
                .andExpect(jsonPath("$[1].title").value("Task 2"))
                .andExpect(jsonPath("$[1].completed").value(true));
    }

    @Test
    void testCreateTask() throws Exception {
        Task mockTask = new Task(10L, "New Task", false);

        // Когда сервису дадим "New Task", он вернёт mockTask
        Mockito.when(taskService.createTask("New Task")).thenReturn(mockTask);

        // POST /tasks
        mockMvc.perform(post("/tasks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"New Task\",\"completed\":false}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(10))
                .andExpect(jsonPath("$.title").value("New Task"))
                .andExpect(jsonPath("$.completed").value(false));
    }

    @Test
    void testGetTask() throws Exception {
        Task mockTask = new Task(5L, "Some Task", false);

        Mockito.when(taskService.getTask(5L)).thenReturn(Optional.of(mockTask));

        mockMvc.perform(get("/tasks/5"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(5))
                .andExpect(jsonPath("$.title").value("Some Task"))
                .andExpect(jsonPath("$.completed").value(false));
    }

    @Test
    void testUpdateTask() throws Exception {
        Mockito.when(taskService.updateTask(7L, "New Title", true))
                .thenReturn(Optional.of(new Task(7L, "New Title", true)));

        mockMvc.perform(put("/tasks/7")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"New Title\",\"completed\":true}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(7))
                .andExpect(jsonPath("$.title").value("New Title"))
                .andExpect(jsonPath("$.completed").value(true));
    }

    @Test
    void testDeleteTask() throws Exception {
        // deleteTask ничего не возвращает, проверяем, что HTTP вернёт 200
        mockMvc.perform(delete("/tasks/12"))
                .andExpect(status().isOk());

        // verify, что сервис вызвал deleteTask(12)
        Mockito.verify(taskService).deleteTask(12L);
    }
}
