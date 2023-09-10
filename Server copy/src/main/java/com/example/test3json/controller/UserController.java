package com.example.test3json.controller;


import com.example.test3json.model.User;
import com.example.test3json.repository.UserRepository;
import com.example.test3json.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class UserController {

    private final UserRepository userRepository;

    @Autowired
    private UserService userService;

    @Autowired
    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/users")
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }


    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> login(@RequestBody User user) {

        // verificam daca user-ul exista in baza de date
        User foundUSer = userRepository.findByEmailAndPassword(user.getEmail(), user.getPassword());
        if (foundUSer != null) {
            // creem un obiect de tipul Map care va fi convertit în JSON
            Map<String, String> responseMap = new HashMap<>();
            responseMap.put("token", "dfsgjksdbgksbgsbgvsbgfd");

            // returnam raspunsul sub forma de JSON (200 ok)
            return ResponseEntity.ok(responseMap);
        } else {
            // creem un obiect de tipul Map care va fi convertit în JSON
            Map<String, String> responseMap = new HashMap<>();
            responseMap.put("message", "Username-ul sau password sunt incorecte");

            // 401 (Unauthorized)
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(responseMap);
        }
    }

    @PostMapping("/register")
    public ResponseEntity<Map<String, String>> registerUser(@RequestBody User user) {

        if (userService.checkIfUserExists(user.getEmail())) {
            // creem un obiect de tipul Map care va fi convertit în JSON
            Map<String, String> responseMap = new HashMap<>();
            responseMap.put("message", "Utilizatorul exista");


            // returnam raspunsul sub forma de JSON (200 ok)
            return ResponseEntity.ok(responseMap);
        } else {
            // creem un obiect de tipul Map care va fi convertit în JSON
            Map<String, String> responseMap = new HashMap<>();
            responseMap.put("token", "jgfdhefhgfehfsbdf");
            userService.saveUser(user);

            return ResponseEntity.ok(responseMap);

        }
    }
}
