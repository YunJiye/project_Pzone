package com.example.project_Pzone;

import com.fasterxml.jackson.annotation.JsonIgnore;

// not owners of parking lots, but users who use this application to find parking lots.
public class User {
    @JsonIgnore
    private String userID;
    @JsonIgnore
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

    public void setUserID(String ID){
        userID = ID;
    }

    public String getUserPW(){
        return userPW;
    }

    public void setUserPW(String PW){
        userPW = PW;
    }

    public Object getUserToken(){ return userToken; }

    public void setUserToken(String token){
        userToken = token;
    }
}
