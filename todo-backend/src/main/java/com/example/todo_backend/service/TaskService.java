package com.example.todo_backend.service;

import com.example.todo_backend.entity.Task;
import com.example.todo_backend.repository.TaskRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TaskService {
    private final TaskRepository repo;

    public TaskService(TaskRepository repo) {
        this.repo = repo;
    }

    public Task createTask(String title) {
        return repo.save(new Task(null, title, false));
    }

    public List<Task> getAllTasks() {
        return repo.findAll();
    }

    public Optional<Task> getTask(Long id) {
        return repo.findById(id);
    }

    public Optional<Task> updateTask(Long id, String title, boolean completed) {
        return repo.findById(id).map(t -> {
            t.setTitle(title);
            t.setCompleted(completed);
            return repo.save(t);
        });
    }

    public void deleteTask(Long id) {
        repo.deleteById(id);
    }
}
