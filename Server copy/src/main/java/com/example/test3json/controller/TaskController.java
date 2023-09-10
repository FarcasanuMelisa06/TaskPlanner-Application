package com.example.test3json.controller;

import com.example.test3json.model.Task;
import com.example.test3json.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api")
public class TaskController {

    private final TaskRepository taskRepository;

    @Autowired
    public TaskController(TaskRepository taskRepository) {
        this.taskRepository = taskRepository;
    }

    //returneaza toate sarcinile din baza de date
    @GetMapping("/tasks")
    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    @PostMapping("/addTask")
    public ResponseEntity<Task> addTask(@RequestBody Task newTask) {
        // Setează starea implicită a sarcinii la "active"
        newTask.setStatus("active");



        // Salvează noua sarcină în baza de date
        Task savedTask = taskRepository.save(newTask);

        // Returnează răspunsul 200 OK și noua sarcină creată
        return ResponseEntity.ok(savedTask);
    }

    // Metoda pentru editarea unei sarcini existente
    @PutMapping("/edit/{taskId}")
    public ResponseEntity<Task> editTask(@PathVariable Long taskId, @RequestBody Task updatedTask) {
        Optional<Task> existingTaskOptional = taskRepository.findById(taskId);

        if (existingTaskOptional.isPresent()) {
            Task existingTask = existingTaskOptional.get();
            existingTask.setTitle(updatedTask.getTitle());
            existingTask.setDescription(updatedTask.getDescription());
            existingTask.setPriority(updatedTask.getPriority());
            existingTask.setDueDate(updatedTask.getDueDate());
            existingTask.setStatus(updatedTask.getStatus());

            Task updatedTaskEntity = taskRepository.save(existingTask);

            return ResponseEntity.ok(updatedTaskEntity);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    @DeleteMapping("/delete/{taskId}")
    public ResponseEntity<String> deleteTask(@PathVariable Long taskId) {
        Optional<Task> taskOptional = taskRepository.findById(taskId);

        if (taskOptional.isPresent()) {
            taskRepository.deleteById(taskId);
            return ResponseEntity.ok("Task-ul cu ID-ul " + taskId + " a fost șters.");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}