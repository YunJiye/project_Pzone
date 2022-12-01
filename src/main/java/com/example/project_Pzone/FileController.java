package com.example.project_Pzone;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.xml.crypto.Data;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@CrossOrigin
//@RestController
@Controller
public class FileController {
    @Value("${spring.servlet.multipart.location}")
    //@Value("${file.dir}")
    String filePath;

// download files by parkingLotID and file type

    // download files. show all files in upload folder
    @GetMapping("/download")
    public ResponseEntity<Resource> Download(@RequestParam("parkingLotID")int parkingLotID, @RequestParam("fileType")int fileType) throws IOException{
        FileDto dto = Database.getFileDto(parkingLotID, fileType);
        Path path;
        if(dto.getFileType() == FILE_TYPE.CCTV_PICTURE.ordinal() || dto.getFileType() == FILE_TYPE.CCTV_VIDEO.ordinal())
            path = Paths.get(filePath + "/" + dto.getUuid() + "_" + dto.getParkingLotID() + "_" + dto.getFileType() + "_" + dto.getCCTVID() + "_" + dto.getFileName());
        else
            path = Paths.get(filePath + "/" + dto.getUuid() + "_" + dto.getParkingLotID() + "_" + dto.getFileType() + "_" + dto.getFileName());

        String contentType = Files.probeContentType(path);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentDisposition(ContentDisposition.builder("attachment").filename(dto.getFileName(), StandardCharsets.UTF_8).build());
        headers.add(HttpHeaders.CONTENT_TYPE, contentType);
        Resource resource = new InputStreamResource(Files.newInputStream(path));
        return new ResponseEntity<>(resource, headers, HttpStatus.OK);
    }

// For download Test!
    // provide registered parking lot information - registered parking lot drawing, parkingLot ID and CCTV number
    @GetMapping("/get_registered_parking_lot_info")
    public ResponseEntity<Resource> getRegisteredParkingLotInfo(@ModelAttribute FileDto dto) throws IOException{
        Path path;
        if(dto.getFileType() == FILE_TYPE.CCTV_PICTURE.ordinal() || dto.getFileType() == FILE_TYPE.CCTV_VIDEO.ordinal())
            path = Paths.get(filePath + "/" + dto.getUuid() + "_" + dto.getParkingLotID() + "_" + dto.getFileType() + "_" + dto.getCCTVID() + "_" + dto.getFileName());
        else
            path = Paths.get(filePath + "/" + dto.getUuid() + "_" + dto.getParkingLotID() + "_" + dto.getFileType() + "_" + dto.getFileName());

        String contentType = Files.probeContentType(path);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentDisposition(ContentDisposition.builder("attachment").filename(dto.getFileName(), StandardCharsets.UTF_8).build());
        headers.add(HttpHeaders.CONTENT_TYPE, contentType);
        Resource resource = new InputStreamResource(Files.newInputStream(path));
        return new ResponseEntity<>(resource, headers, HttpStatus.OK);
    }
    //public String getRegisteredParkingLotInfo(){return "get registered parking lot info here";}

// upload file
    // store parking sketch
    @GetMapping("/upload_file")
    public String uploadFile(){
        return "upload";
    }

    @PostMapping("/upload_file")
    public String uploadFile(@RequestParam("uploadFile") MultipartFile[] uploadFile, @RequestParam("parkingLotID") int parkingLotID, @RequestParam("fileType") int fileType, @RequestParam("CCTVID")int CCTVID, Model model) throws IOException {
        List<FileDto> list = new ArrayList<>();
        for(MultipartFile file : uploadFile){
            if(!file.isEmpty()){
                FileDto dto = new FileDto(UUID.randomUUID().toString(), file.getOriginalFilename(), file.getContentType(), parkingLotID, fileType);
                dto.setCCTVID(CCTVID);
                list.add(dto);
                File newFileName;
                if(fileType == FILE_TYPE.CCTV_PICTURE.ordinal() || fileType == FILE_TYPE.CCTV_VIDEO.ordinal()){
                    newFileName = new File(dto.getUuid() + "_" + dto.getParkingLotID() + "_" + dto.getFileType() + "_" + dto.getCCTVID() + "_" + dto.getFileName());
                }
                else {
                    newFileName = new File(dto.getUuid() + "_" + dto.getParkingLotID() + "_" + dto.getFileType() + "_" + dto.getFileName());
                }

                // store file
                file.transferTo(newFileName);

                // add to database
                RegisteredParkingLot rPL = (RegisteredParkingLot)(Database.getParkingLotByID(parkingLotID));
                if(rPL == null) System.out.println("upload file error!!rPL not exist!!\n");
                /* code for test
                rPL=new RegisteredParkingLot("a","b","c",1,2);
                Database.addRegisteredParkingLots(rPL);*/

                rPL.addFile(fileType, dto);
            }
        }
        model.addAttribute("files", list);
        //return "result";
        return "redirect:/upload_file";
    }
    //public String setParkingSketch(){return "store parking sketch here";}

    // get cctv information - every 2 seconds, cctv screen, and its number
    @PostMapping("/upload_cctv_info")
    public void uploadCCTVInfo(@RequestParam("uploadFile") MultipartFile[] uploadFile, @RequestParam("parkingLotID") int parkingLotID, @RequestParam("CCTVID") int CCTVID, Model model) throws IOException {
        List<FileDto> list = new ArrayList<>();
        for(MultipartFile file : uploadFile){
            if(!file.isEmpty()){
                FileDto dto = new FileDto(UUID.randomUUID().toString(), file.getOriginalFilename(), file.getContentType(), parkingLotID, FILE_TYPE.CCTV_PICTURE.ordinal());
                dto.setCCTVID(CCTVID);
                list.add(dto);
                File newFileName = new File(dto.getUuid() + "_" + dto.getParkingLotID() + "_" + dto.getFileType() + "_" + dto.getCCTVID() + "_" + dto.getFileName());
                // store file
                file.transferTo(newFileName);

                // add to database
                RegisteredParkingLot rPL = (RegisteredParkingLot)(Database.getParkingLotByID(parkingLotID));
                if(rPL == null) System.out.println("upload file error!!rPL not exist!!\n");

                rPL.addFile(FILE_TYPE.CCTV_PICTURE.ordinal(), dto);
            }
        }
        model.addAttribute("files", list);
    }
    //public String provideCCTVInfo(){return "provide cctv info here";}

    // Parking lot information registration - additionally, parking lot CCTV location and drawing
    @PostMapping("/parking_lot_registration")
    public void setParkingLotRegistration(@RequestParam("owner_id") String owner, @RequestParam("name") String name, @RequestParam("address") String address,
                                          @RequestParam("latitude") float latitude, @RequestParam("longitude") float longitude,
                                          @RequestParam("uploadFile") MultipartFile[] uploadFile, Model model) throws IOException {
        RegisteredParkingLot rPL = new RegisteredParkingLot(owner, name, address, latitude, longitude);
        Database.addRegisteredParkingLots(rPL, Database.getOwnerByToken(owner));
        List<FileDto> list = new ArrayList<>();
        for(MultipartFile file : uploadFile){
            if(!file.isEmpty()){
                FileDto dto = new FileDto(UUID.randomUUID().toString(), file.getOriginalFilename(), file.getContentType(), rPL.getID(), FILE_TYPE.PARKINGLOT_DRAWING.ordinal());
                list.add(dto);
                File newFileName = new File(dto.getUuid() + "_" + rPL.getID() + "_"+ FILE_TYPE.PARKINGLOT_DRAWING.ordinal() + "_" + dto.getFileName());
                // store file
                file.transferTo(newFileName);
                // add to database
                rPL.addFile(FILE_TYPE.CCTV_PICTURE.ordinal(), dto);
            }
        }
        model.addAttribute("files", list);
    }
    //public String setParkingInfo(){return "set parking info here";}


}

