package com.example.project_Pzone;

import java.util.ArrayList;

// registered parking lot information
public class RegisteredParkingLot extends ParkingLot{
    private ArrayList<Car> cars;
    private ArrayList<FileDto> fileDtos;    // for each file type
    private ArrayList<FileDto> videoFileDtos;   // for section A to Z
    private ArrayList<FileDto> pictureFileDtos;

    RegisteredParkingLot(String client, String name, String address, float latitude, float longitude) {
        super(client, name, address, latitude, longitude);
        cars = new ArrayList<>();
        fileDtos = new ArrayList<>();
        for(int i = 0; i < 5; i++)
            fileDtos.add(0, null);  // 1~2 not used.
        for(int i = 0; i < 26; i++){
            videoFileDtos.add(0, null);
            pictureFileDtos.add(0, null);
        }
        leftSeat = 0;
    }

    public int getNumberOfCars(){
        return leftSeat;
    }

    public void addFile(int fileType, FileDto fileDto){
        fileDtos.set(fileType, fileDto);  // store fileName with fileType
    }
    public void addFile(int fileType, char section, FileDto fileDto){
        if(fileType == 1){  // CCTV picture
            pictureFileDtos.set(section, fileDto);
        }
        else{   // CCTV video
            videoFileDtos.set(section, fileDto);
        }
    }

    public FileDto getFileDto(int fileType){
        return fileDtos.get(fileType);
    }
    public FileDto getFileDto(int fileType, char section){
        if(fileType == 1){  // CCTV picture
            return pictureFileDtos.get(section);
        }
        else {  // CCTV video
            return videoFileDtos.get(section);
        }
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
