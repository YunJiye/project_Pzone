package com.example.project_Pzone;

public class Owner {
    private String ID;
    private String PW;
    private String Token;

    Owner(String ID, String PW, String Token){
        this.ID = ID;
        this.PW = PW;
        this.Token = Token;
    }

    public String getID(){
        return ID;
    }
    public String getPW(){
        return PW;
    }
    public String getToken(){
        return Token;
    }
}
