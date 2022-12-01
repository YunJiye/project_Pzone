package com.example.project_Pzone;

import java.util.ArrayList;

// registered parking lot information
public class RegisteredParkingLot extends ParkingLot{
    private ArrayList<Car> cars;
    private ArrayList<FileDto> fileDtos;    // for each file type

    RegisteredParkingLot(String client, String name, String address, float latitude, float longitude) {
        super(client, name, address, latitude, longitude);
        cars = new ArrayList<>();
        fileDtos = new ArrayList<>();
        for(int i = 0; i < 5; i++)
            fileDtos.add(0, null);
        leftSeat = 0;
    }

    public int getNumberOfCars(){
        return leftSeat;
    }

    public void addFile(int fileType, FileDto fileDto){
        fileDtos.set(fileType, fileDto);  // store fileName with fileType
    }

    public FileDto getFileDto(int fileType){
        return fileDtos.get(fileType);
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
