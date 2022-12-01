package com.example.project_Pzone;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

//@RestController
@Controller //->connect '/hello' to hello.html, but '/bye' doesn't work
public class HelloController {
    @GetMapping("/hello")
    public String getHello(){
        return "hello";
    }
    @GetMapping("/bye")
    public String getBye(){return "Bye!..";}
}
