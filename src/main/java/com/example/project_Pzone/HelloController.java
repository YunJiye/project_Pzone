package com.example.project_Pzone;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    @GetMapping("/hello")
    public String getHello(){
        return "Hello? It's me";
    }
    @GetMapping("/bye")
    public String getBye(){return "Bye!..";}
}
