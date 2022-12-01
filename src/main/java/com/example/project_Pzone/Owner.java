package com.example.project_Pzone;

import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.ArrayList;

public class Owner {
    @JsonIgnore
    private String ownerID;
    @JsonIgnore
    private String ownerPW;
    private String ownerToken;
    @JsonIgnore
    private ArrayList<Integer> parkingLots; // parking lot ids of the owner's

    Owner(String ID, String PW, String Token){
        ownerID = ID;
        ownerPW = PW;
        ownerToken = Token;
        parkingLots = new ArrayList<>();
    }

    public String getOwnerID(){
        return ownerID;
    }
    public String getOwnerPW(){
        return ownerPW;
    }
    public String getOwnerToken(){
        return ownerToken;
    }

    public ArrayList<Integer> getParkingLots(){
        return parkingLots;
    }
    public void setOwnerID(String ID){
        ownerID = ID;
    }
    public void setOwnerPW(String PW){
        ownerPW = PW;
    }
    public void setOwnerToken(String token){
        ownerToken = token;
    }

    public void setParkingLots(int ID){
        parkingLots.add(ID);
    }
}
