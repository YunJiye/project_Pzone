package com.example.project_Pzone;

import java.util.ArrayList;

public final class Database {
    public static boolean stateFlag = false;
    private static int parkingLotID = 0;
    private static ArrayList<User> users;   // only for users who use this application to find parking lots. not owners.
    private static ArrayList<Owner> owners; // parking lot owners.
    private static ArrayList<ParkingLot> parkingLots;
    private static ArrayList<RegisteredParkingLot> registeredParkingLots;


    public static void init(){
        owners = new ArrayList<>();
        users = new ArrayList();
        parkingLots = new ArrayList();
        registeredParkingLots = new ArrayList();
        parkingLotID = 0;
    }

    public static ArrayList<Owner> getOwners(){
        return owners;
    }

    public static ArrayList<User> getUsers(){
        return users;
    }

    // find owner token by id and password.
    public static String getOwnerToken(String ID, String PW){
        for(int i = 0; i < owners.size(); i++){
            if(owners.get(i).getID() == ID && owners.get(i).getPW() == PW){
                return owners.get(i).getToken();
            }
        }
        return null;
    }

    // find user token by id and password. if no user matched, then return null.
    public static String getUserToken(String ID, String PW){
        for(int i = 0; i < users.size(); i++){
            if(users.get(i).getUserID() == ID && users.get(i).getUserPW() == PW){
                return users.get(i).getUserToken();
            }
        }
        return null;
    }

    public static ArrayList<ParkingLot> getParkingLots(){
        return parkingLots;
    }

    public static ArrayList<RegisteredParkingLot> getRegisteredParkingLots() {
        return registeredParkingLots;
    }

    public static void addUsers(User user){
        users.add(user);
    }

    public static void addOwners(Owner owner){
        owners.add(owner);
    }

    public static void addParkingLots(ParkingLot PL){
        PL.setID(parkingLotID++);
        parkingLots.add(PL);
    }

    public static void addRegisteredParkingLots(RegisteredParkingLot rPL){
        rPL.setID(parkingLotID++);
        registeredParkingLots.add(rPL);
    }

    public static ParkingLot getParkingLotByID(int ID){
        for(int i = 0; i < parkingLots.size(); i++){
            if(parkingLots.get(i).getID() == ID){
                return parkingLots.get(i);
            }
        }
        for(int i = 0; i < registeredParkingLots.size(); i++){
            if(registeredParkingLots.get(i).getID() == ID){
                return registeredParkingLots.get(i);
            }
        }
        return null;
    }

    public static ParkingLot getParkingLotByLoc(float latitude, float longitude){
        for(int i = 0; i < parkingLots.size(); i++){
            if(parkingLots.get(i).getLatitude() == latitude && parkingLots.get(i).getLongitude() == longitude){
                return parkingLots.get(i);
            }
        }
        for(int i = 0; i < registeredParkingLots.size(); i++){
            if(registeredParkingLots.get(i).getLatitude() == latitude && registeredParkingLots.get(i).getLongitude() == longitude){
                return registeredParkingLots.get(i);
            }
        }
        return null;
    }

    public static void deleteParkingLots(ParkingLot PL) {
        parkingLots.remove(PL);
        registeredParkingLots.remove(PL);
    }

    public static void addCar(RegisteredParkingLot PL, String car){
        PL.enteringCar(car);
    }

    public static void deleteCar(RegisteredParkingLot PL, String car){
        PL.outgoingCar(car);
    }
}
