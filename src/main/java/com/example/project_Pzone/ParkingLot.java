package com.example.project_Pzone;

import java.util.ArrayList;

// parking lot information(name, address, latitude, longitude)
public class ParkingLot {
    protected String client;  // client token
    protected String name;
    protected String address;
    protected float latitude, longitude;
    protected int leftSeat = 0; // the number of left seats
    protected int ID;
    protected ArrayList<String> carList;    // not used in this class, in registered parking lot.

    ParkingLot(String client, String name, String address, float latitude, float longitude){
        this.client = client;
        this.name = name;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        leftSeat = 0;
    }

    public void setID(int ID) {
        this.ID = ID;
    }
    public void setLeftSeat(int leftSeat){this.leftSeat = leftSeat;}

    public int getID(){
        return ID;
    }

    public String getClient(){
        return client;
    }

    public String getName(){
        return name;
    }
    public String getAddress(){
        return address;
    }
    public float getLatitude(){
        return latitude;
    }
    public float getLongitude(){
        return longitude;
    }
}
