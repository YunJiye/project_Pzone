package com.example.project_Pzone;

// not owners of parking lots, but users who use this application to find parking lots.
public class User {
    private String userID;
    private String userPW;
    private String userToken;

    User(String ID, String PW, String token){
        userID = ID;
        userPW = PW;
        userToken = token;
    }

    public String getUserID(){
        return userID;
    }

    public String getUserPW(){
        return userPW;
    }

    public String getUserToken(){
        return userToken;
    }
}
