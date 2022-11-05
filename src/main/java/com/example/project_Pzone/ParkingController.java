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

@RestController
@ResponseBody
public class ParkingController {
    @Value("${spring.servlet.multipart.location}")
    String filePath;

    // Parking lot information registration - additionally, parking lot CCTV location and drawing
    @PostMapping("/parking_lot_registration")
    public void setParkingLotRegistration(@RequestParam("client-name") String client, @RequestParam("name") String name, @RequestParam("address") String address,
                                          @RequestParam("latitude") float latitude, @RequestParam("longitude") float longitude,
                                          @RequestParam MultipartFile[] uploadFile, Model model) throws IOException {
        RegisteredParkingLot rPL = new RegisteredParkingLot(client, name, address, latitude, longitude);
        Database.addRegisteredParkingLots(rPL);
        List<FileDto> list = new ArrayList<>();
        for(MultipartFile file : uploadFile){
            if(!file.isEmpty()){
                FileDto dto = new FileDto(UUID.randomUUID().toString(), file.getOriginalFilename(), file.getContentType());
                list.add(dto);
                File newFileName = new File(rPL.getID() + "_" + dto.getUuid() + "_" + dto.getFileName());
                // store file
                file.transferTo(newFileName);
            }
        }
        model.addAttribute("files", list);
    }
    //public String setParkingInfo(){return "set parking info here";}

    // set parking lot information(name, address, latitude, longitude)
    @GetMapping("/set_parking_lot_info")
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

    // get cctv information - every 2 seconds, cctv screen, and its number
    @PostMapping("/upload_cctv_info")
    public void uploadCCTVInfo(@RequestParam MultipartFile[] uploadFile, @RequestParam int parkingLotID, @RequestParam int CCTVID, Model model) throws IOException {
        List<FileDto> list = new ArrayList<>();
        for(MultipartFile file : uploadFile){
            if(!file.isEmpty()){
                FileDto dto = new FileDto(UUID.randomUUID().toString(), file.getOriginalFilename(), file.getContentType());
                list.add(dto);
                File newFileName = new File(parkingLotID + "_" + CCTVID + "_" + dto.getUuid() + "_" + dto.getFileName());
                // store file
                file.transferTo(newFileName);
            }
        }
        model.addAttribute("files", list);
    }
    //public String provideCCTVInfo(){return "provide cctv info here";}

    // get information of vehicle entering the entrance - car number and parking lot
    @GetMapping("/provide_entering_car")
    public void provideEnteringCar(@RequestParam("ID")int ID, @RequestParam("car-number")String car){
        RegisteredParkingLot rPL = (RegisteredParkingLot) Database.getParkingLotByID(ID);
        Database.addCar(rPL, car);
    }

    // get information of vehicle going out - car number
    @GetMapping("/provide_going_out_car")
    public void provideGoingOutCar(@RequestParam("ID")int ID, @RequestParam("car-number")String car){
        RegisteredParkingLot rPL = (RegisteredParkingLot) Database.getParkingLotByID(ID);
        Database.deleteCar(rPL, car);
    }

    // provide registered parking lot information - registered parking lot drawing and CCTV number

    @GetMapping("/get_registered_parking_lot_info")
    public ResponseEntity<Resource> getRegisteredParkingLotInfo(@ModelAttribute FileDto dto) throws IOException{
        Path path = Paths.get(filePath + "/" + dto.getUuid() + "_" + dto.getFileName());
        String contentType = Files.probeContentType(path);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentDisposition(ContentDisposition.builder("attachment").filename(dto.getFileName(), StandardCharsets.UTF_8).build());
        headers.add(HttpHeaders.CONTENT_TYPE, contentType);
        Resource resource = new InputStreamResource(Files.newInputStream(path));
        return new ResponseEntity<>(resource, headers, HttpStatus.OK);
    }
    //public String getRegisteredParkingLotInfo(){return "get registered parking lot info here";}

    // store parking sketch
    @PostMapping("/upload_parking_sketch")
    public void uploadParkingSketch(@RequestParam MultipartFile[] uploadFile, @RequestParam int ID, Model model) throws IOException {
        List<FileDto> list = new ArrayList<>();
        for(MultipartFile file : uploadFile){
            if(!file.isEmpty()){
                FileDto dto = new FileDto(UUID.randomUUID().toString(), file.getOriginalFilename(), file.getContentType());
                list.add(dto);
                File newFileName = new File(ID + "_" + dto.getUuid() + "_" + dto.getFileName());
                // store file
                file.transferTo(newFileName);
            }
        }
        model.addAttribute("files", list);
    }
    //public String setParkingSketch(){return "store parking sketch here";}

    // provide changed state flag - entrance or going out is occurred.
    @GetMapping("/get_state_flag")
    public Boolean getStateFlag(){return Database.stateFlag;}

    // provide CCTV information to ML - for entrance or going out / for parking information
}
