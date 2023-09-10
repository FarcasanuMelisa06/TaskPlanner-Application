package com.example.test3json.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "\"tasks\"")
public class Task {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "task_id", unique = true)
    private Long taskId;

//    @ManyToOne
//    @JoinColumn(name = "user_id")
//    private User user;

    @Column(name = "title")
    private String title;

    @Column(name = "description")
    private String description;

    @Column(name = "priority")
    private String priority;

    @Column(name = "due_date")
    private String dueDate;

    @Column(name = "status")
    private String status;

    // Constructor implicit gol
    public Task() {

    }

    // Constructor
    public Task(String title, String priority) {

        this.title = title;
        this.priority = priority;
        this.status = "active"; // Setăm implicit starea sarcinii ca "activă" la creare
    }

    public Long getTaskId() {
        return taskId;
    }

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

//    public User getUser() {
//        return user;
//    }
////
//    public void setUser(User user) {
//        this.user = user;
//    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getDueDate() {
        return dueDate;
    }

    public void setDueDate(String dueDate) {
        this.dueDate = dueDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}