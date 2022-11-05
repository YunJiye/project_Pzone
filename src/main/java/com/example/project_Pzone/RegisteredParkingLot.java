package com.example.project_Pzone;

import java.util.ArrayList;

// registered parking lot information
public class RegisteredParkingLot extends ParkingLot{
    private ArrayList<Car> cars;
    RegisteredParkingLot(String client, String name, String address, float latitude, float longitude) {
        super(client, name, address, latitude, longitude);
        cars = new ArrayList<>();
        leftSeat = 0;
    }

    public int getNumberOfCars(){
        return leftSeat;
    }
    public void enteringCar(String carNum){
        Car car = new Car(carNum);
        cars.add(car);
        leftSeat++;
    }
    public void outgoingCar(String carNum){
        for(int i = 0; i < cars.size(); i++){
            if(carNum == cars.get(i).getCarNumber()){
                cars.remove(i);
                leftSeat--;
                break;
            }
        }
    }
}
