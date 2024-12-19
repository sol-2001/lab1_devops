package com.example.todo_backend.controller;

import com.example.todo_backend.entity.Task;
import com.example.todo_backend.service.TaskService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/tasks")
@CrossOrigin(origins = "*")
public class TaskController {
    private final TaskService service;

    public TaskController(TaskService service) {
        this.service = service;
    }

    @PostMapping
    public Task createTask(@RequestBody Task task) {
        return service.createTask(task.getTitle());
    }

    @GetMapping
    public List<Task> getAllTasks() {
        return service.getAllTasks();
    }
    @GetMapping("/{id}")
    public Task getTask(@PathVariable Long id) {
        return service.getTask(id).orElse(null);
    }

    @PutMapping("/{id}")
    public Task updateTask(@PathVariable Long id, @RequestBody Task task) {
        return service.updateTask(id, task.getTitle(), task.isCompleted()).orElse(null);
    }

    @DeleteMapping("/{id}")
    public void deleteTask(@PathVariable Long id) {
        service.deleteTask(id);
    }
}
