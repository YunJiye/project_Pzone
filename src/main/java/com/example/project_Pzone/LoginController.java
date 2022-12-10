package com.example.project_Pzone;

import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
public class LoginController {
    // show user info - will be found by ID and Password?
    @GetMapping("/get_user_info")
    public Object getUserInfo(@RequestParam("ID")String ID, @RequestParam("PW")String PW){
        return Database.getUserToken(ID, PW);
    }

    // store tokens for users
    @PostMapping("/set_user")
    public void setUser(@RequestParam("ID")String ID, @RequestParam("PW")String PW, @RequestParam("token")String token) throws IOException {
        User user = new User(ID, PW, token);
        Database.addUsers(user);
    }

    // show owner info
    @GetMapping("/get_owner_info")
    public Object getOwnerInfo(@RequestParam("ID")String ID, @RequestParam("PW")String PW){
        return Database.getOwnerToken(ID, PW);
    }

    // store tokens for owners
    @PostMapping("/set_owner")
    public void setOwner(@RequestParam("ID")String ID, @RequestParam("PW")String PW, @RequestParam("token")String token) throws IOException {
        Owner owner = new Owner(ID, PW, token);
        Database.addOwners(owner);
    }
}
