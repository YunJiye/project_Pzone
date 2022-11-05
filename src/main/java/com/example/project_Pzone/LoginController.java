package com.example.project_Pzone;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@ResponseBody
public class LoginController {
    // show user info - will be found by ID and Password?
    @GetMapping("/get_user_info")
    public String getUserInfo(@RequestParam("ID")String ID, @RequestParam("PW")String PW){
        return Database.getUserToken(ID, PW);
    }

    // store tokens for users
    @GetMapping("/set_user")
    public void setUser(@RequestParam("ID")String ID, @RequestParam("PW")String PW, @RequestParam("token")String token){
        User user = new User(ID, PW, token);
        Database.addUsers(user);
    }

    // show owner info
    @GetMapping("/get_owner_info")
    public String getOwnerInfo(@RequestParam("ID")String ID, @RequestParam("PW")String PW){
        return Database.getOwnerToken(ID, PW);
    }

    // store tokens for owners
    @GetMapping("/set_owner")
    public void setOwner(@RequestParam("ID")String ID, @RequestParam("PW")String PW, @RequestParam("token")String token){
        Owner owner = new Owner(ID, PW, token);
        Database.addOwners(owner);
    }
}
