package com.example.project_Pzone;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

//@CrossOrigin
@RestController
public class ParkingController {
    @Value("${spring.servlet.multipart.location}")
    //@Value("${file.dir}")
    String filePath;

    // set parking lot information(name, address, latitude, longitude)
    @PostMapping("/set_parking_lot_info")
    public void setParkingLotInfo(@RequestParam("client-name") String client, @RequestParam("name") String name, @RequestParam("address") String address,
                                  @RequestParam("latitude") float latitude, @RequestParam("longitude") float longitude){
        ParkingLot PL = new ParkingLot(client, name, address, latitude, longitude);
        Database.getParkingLots().add(PL);
    }
    //public String setParking_lot_info(){return "set parking info here";}

    // provide all parking lot information(name, address, Latitude, Longitude) with json
    @GetMapping("/get_all_parking_lot_info")
    public ArrayList<ParkingLot> getAllParkingInfo(){
        return Database.getParkingLots();
    }

    // provide parking lot information of the parking lot
    @GetMapping("/get_parking_lot_info")
    public ParkingLot getParkingInfo(@RequestParam("ID")int ID){
        return Database.getParkingLotByID(ID);
    }

    @GetMapping("/get_parking_lot_empty_places")
    public int getParkingLotEmptyPlaces(@RequestParam("ID")int ID){
        return Database.getParkingLotByID(ID).leftSeat;
    }

    // get information of vehicle entering the entrance - car number and parking lot
    @GetMapping("/provide_entering_car")
    public void provideEnteringCar(@RequestParam("ID")int ID, @RequestParam("car-number")String car){
        RegisteredParkingLot rPL = (RegisteredParkingLot) Database.getParkingLotByID(ID);
        Database.addCar(rPL, car);
    }

    // get information of vehicle going out - car number(parameter : parkingLot ID, car-number)
    @GetMapping("/provide_going_out_car")
    public void provideGoingOutCar(@RequestParam("ID")int ID, @RequestParam("car-number")String car){
        RegisteredParkingLot rPL = (RegisteredParkingLot)Database.getParkingLotByID(ID);
        Database.deleteCar(rPL, car);
    }

    @GetMapping("/get_parking_list_by_owner_id")
    public ArrayList<RegisteredParkingLot> getParkingLotListByOwnerID(@RequestParam("owner")String owner){
        ArrayList<RegisteredParkingLot> ARP = new ArrayList<>();
        ArrayList<Integer> own_pl = Database.getOwnerByToken(owner).getParkingLots();
        for(int i = 0; i < own_pl.size(); i++){
            ARP.add((RegisteredParkingLot) Database.getParkingLotByID(own_pl.get(i)));
        }
        return ARP;
    }

    // provide changed state flag - entrance or going out is occurred.
    @GetMapping("/get_state_flag")
    public Boolean getStateFlag(){return Database.stateFlag;}

    // provide CCTV information to ML - for entrance or going out / for parking information
}
