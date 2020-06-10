package com.example.Authmedium;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

    @GetMapping("/Stories")
    public String stories(){
        return " You are authenticated - Stories endpoint";

    }
    @GetMapping("/NewStory")
    public String newStory(){
        return " you are authenticated - New Story endpoint";

    }
    @GetMapping("/UserManaging")
    public String userManaging(){
        return " you are authenticated - User Management endpoint";

    }
}