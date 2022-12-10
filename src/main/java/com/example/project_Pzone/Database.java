package com.example.project_Pzone;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.UUID;

enum FILE_TYPE{NOTHING, CCTV_PICTURE, CCTV_VIDEO, PARKINGLOT_SKETCH, PARKINGLOT_DRAWING};

@Component
public final class Database {
    static int FILE_TYPE_NUM = 5;
    public static boolean stateFlag = false;
    private static int parkingLotID = 0;
    private static ArrayList<User> users;   // only for users who use this application to find parking lots. not owners.
    private static ArrayList<Owner> owners; // parking lot owners.
    private static ArrayList<ParkingLot> parkingLots;
    private static ArrayList<RegisteredParkingLot> registeredParkingLots;

    static String filePath;


    /*@Value("${spring.servlet.multipart.location}")
    public void setFilePath(String path) {
        filePath = path;
    }*/

    public static void init() throws IOException {
        owners = new ArrayList<>();
        users = new ArrayList();
        parkingLots = new ArrayList();
        registeredParkingLots = new ArrayList();
        parkingLotID = 0;
        filePath = "/Users/Yunjiye/Downloads/upload";

    // read all files.
        // read user_list.txt
        FileIO dir = new FileIO();
        File file = dir.setFile("user_list.txt");
        FileReader fileReader = new FileReader(file);
        BufferedReader bufReader = new BufferedReader(fileReader);

        String line = "";
        while ((line = bufReader.readLine()) != null) {
            String[] result = line.split(" ");
            User user = new User(result[0], result[1], result[2]);
            Database.initUsers(user);
        }
        bufReader.close();

        // read owner_list.txt
        file = dir.setFile("owner_list.txt");
        fileReader = new FileReader(file);
        bufReader = new BufferedReader(fileReader);

        line = "";
        while ((line = bufReader.readLine()) != null) {
            String[] result = line.split(" ");
            Owner owner = new Owner(result[0], result[1], result[2]);

            // read parkingLot information of the owner
            FileIO tempFileIO = new FileIO(owner.getOwnerToken());
            file = tempFileIO.setFile("parkingLot_ID.txt");
            FileReader tempFR = new FileReader(file);
            BufferedReader tempBR = new BufferedReader(tempFR);

            String tempLine = "";
            while ((tempLine = tempBR.readLine()) != null) {
                String[] tempResult = tempLine.split(" ");
                for(int i = 0; i < tempResult.length; i++)
                    owner.setParkingLots(Integer.parseInt(tempResult[i]));
            }
            tempBR.close();

            Database.initOwners(owner);
        }
        bufReader.close();

        // read parking_list.txt
        file = dir.setFile("parking_list.txt");
        fileReader = new FileReader(file);
        bufReader = new BufferedReader(fileReader);

        line = "";
        while ((line = bufReader.readLine()) != null) {
            String[] result = line.split(" ");
            String owner_token = null;
            if(!result[0].equals("null")){
                owner_token = result[0];
            }
            ParkingLot PL = new ParkingLot(owner_token, result[1], result[2], Float.parseFloat(result[3]), Float.parseFloat(result[4]));
            PL.setLeftSeat(Integer.parseInt(result[5]));
            int ID = Integer.parseInt(result[6]);
            if(result[0] == null) Database.initParkingLots(PL, null, ID);
            else Database.initParkingLots(PL, Database.getOwnerByToken(result[0]), ID);
        }
        bufReader.close();

        // read registered_parking_lot info
        dir = new FileIO("registered_parking_lot");
        file = dir.setFile("registered_parking_list.txt");
        fileReader = new FileReader(file);
        bufReader = new BufferedReader(fileReader);
        line = "";
        while ((line = bufReader.readLine()) != null) {
            String[] result = line.split(" ");
            RegisteredParkingLot RPL = new RegisteredParkingLot(result[0], result[1], result[2], Float.parseFloat(result[3]), Float.parseFloat(result[4]));
            RPL.setLeftSeat(Integer.parseInt(result[5]));
            int ID = Integer.parseInt(result[6]);

            // read carList information of the RPL
            FileIO tempFileIO = new FileIO("registered_parking_lot"+"/"+result[6]);  // make /parkingLotID/
            file = tempFileIO.setFile("carList.txt");
            FileReader tempFR = new FileReader(file);
            BufferedReader tempBR = new BufferedReader(tempFR);

            String tempLine = "";
            while ((tempLine = tempBR.readLine()) != null) {
                String[] tempResult = tempLine.split(" ");
                for(int i = 0; i < tempResult.length; i++)
                    RPL.enteringCar(tempResult[i]);
            }
            tempBR.close();
            Database.initRegisteredParkingLots(RPL, Database.getOwnerByToken(result[0]), ID);

            // get files of current parking lot.
            FileFilter filter = new FileFilter() {
                public boolean accept(File f) {
                    return f.getName().equals(Integer.toString(ID));
                }
            };


            if(tempFileIO.getFolder().listFiles(filter) == null){
                continue;
            }
            File[] files = tempFileIO.getFolder().listFiles(); // path/parkingLotID/fileType/
            for (int i = 0; i < files.length; i++) {
                file = files[i];
                System.out.println("file = " + file + "!");
                if(file.getName().equals("1")){         // CCTV_PICTURE
                    File[] mFile = file.listFiles();    // path/parkingLotID/fileType/ID_fileType_[CCTVID]_[section]_fileName.txt
                    for(int j = 0; j < mFile.length; j++){
                        file = mFile[j];

                        FileDto fileDto = new FileDto(file.getName(), "image/"+file.getName().substring(file.getName().lastIndexOf(".") + 1), ID, 1);
                        String[] fileName = file.getName().split("_");
                        fileDto.setCCTVID(Integer.parseInt(fileName[2]));
                        fileDto.setSection(fileName[3].charAt(0));
                        // add new dto to database
                        Database.getRegisteredParkingLotByID(ID).addFile(1, fileName[3].charAt(0), fileDto);
                    }
                }
                else if(file.getName().equals("2")){    // CCTV_VIDEO
                    File[] mFile = file.listFiles();    // path/parkingLotID/fileType/ID_fileType_[CCTVID]_[section]_fileName.txt
                    for(int j = 0; j < mFile.length; j++){
                        file = mFile[j];
                        FileDto fileDto = new FileDto(file.getName(), file.getName().substring(file.getName().lastIndexOf(".") + 1), ID, 2);
                        String[] fileName = file.getName().split("_");
                        fileDto.setCCTVID(Integer.parseInt(fileName[2]));
                        fileDto.setSection(fileName[3].charAt(0));
                        // add new dto to database
                        Database.getRegisteredParkingLotByID(ID).addFile(2, fileName[3].charAt(0), fileDto);
                    }
                }
                else if(file.getName().equals("3") || file.getName().equals("4")){
                    File[] mFile = file.listFiles();    // path/parkingLotID/fileType(3/4)/ID_fileType_fileName.txt
                    for(int j = 0; j < mFile.length; j++){
                        file = mFile[j];
                        System.out.println("final file = " + file);
                        FileDto fileDto = new FileDto(file.getName(), file.getName().substring(file.getName().lastIndexOf(".") + 1), ID, Integer.parseInt(files[i].getName()));
                        // add new dto to database
                        Database.getRegisteredParkingLotByID(ID).addFile(Integer.parseInt(files[i].getName()), fileDto);
                    }
                }
            }
        }
        bufReader.close();
    }

    public static ArrayList<Owner> getOwners(){
        return owners;
    }

    public static ArrayList<User> getUsers(){
        return users;
    }

    // find owner token by id and password.
    public static Object getOwnerToken(String ID, String PW){
        for(int i = 0; i < owners.size(); i++){
            if(owners.get(i).getOwnerID().equals(ID) && owners.get(i).getOwnerPW().equals(PW)){
                return owners.get(i);
            }
        }
        return null;
    }

    public static Owner getOwnerByToken(String token){
        for(int i = 0; i < owners.size(); i++){
            if(owners.get(i).getOwnerToken().equals(token)){
                return owners.get(i);
            }
        }
        return null;
    }

    // find user token by id and password. if no user matched, then return null.
    public static Object getUserToken(String ID, String PW){
        for(int i = 0; i < users.size(); i++){
            if(users.get(i).getUserID().equals(ID) && users.get(i).getUserPW().equals(PW)){
                //return users.get(i).getUserToken();
                return users.get(i);
            }
        }
        System.out.println("it's not found..ID = "+ID+" PW = "+PW);
        return null;
    }

    public static FileDto getFileDto(int parkingLotID, int fileType){
        RegisteredParkingLot RPL = (RegisteredParkingLot)getParkingLotByID(parkingLotID);
        return RPL.getFileDto(fileType);
    }
    public static FileDto getFileDto(int parkingLotID, int fileType, char section){
        RegisteredParkingLot RPL = (RegisteredParkingLot)getParkingLotByID(parkingLotID);
        return RPL.getFileDto(fileType, section);
    }

    public static ArrayList<ParkingLot> getParkingLots(){
        return parkingLots;
    }

    public static ArrayList<RegisteredParkingLot> getRegisteredParkingLots() {
        return registeredParkingLots;
    }

    public static void initUsers(User user){
        users.add(user);
    }

    public static void addUsers(User user) throws IOException {
        users.add(user);
        // add to file
        File file = new File(filePath+"/"+"user_list.txt");
        FileWriter fileWriter = new FileWriter(file, true);
        fileWriter.write(user.getUserID()+" "+user.getUserPW()+" "+user.getUserToken()+"\n");
        fileWriter.flush();
        fileWriter.close();
    }

    public static void initOwners(Owner owner){
        owners.add(owner);
    }

    public static void addOwners(Owner owner) throws IOException {
        owners.add(owner);
        // add to file
        File file = new File(filePath+"/"+"owner_list.txt");
        FileWriter fileWriter = new FileWriter(file, true);
        fileWriter.write(owner.getOwnerID()+" "+owner.getOwnerPW()+" "+owner.getOwnerToken()+"\n");
        fileWriter.flush();
        fileWriter.close();
    }

    public static void initParkingLots(ParkingLot PL, Owner owner, int ID){
        PL.setID(ID);
        parkingLots.add(PL);
        parkingLotID = ID+1;

        if(owner != null) {
            owner.setParkingLots(parkingLotID);
        }
        else{
            System.out.println("owner is null!");
        }
    }
    public static void addParkingLots(ParkingLot PL, Owner owner) throws IOException {
        PL.setID(++parkingLotID);
        parkingLots.add(PL);
        // add to file
        File file = new File(filePath+"/"+"parking_list.txt");
        FileWriter fileWriter = new FileWriter(file, true);
        if(owner == null){
            fileWriter.write("null ");
        }
        else{
            fileWriter.write(PL.getClient()+" ");
        }
        fileWriter.write(PL.getName()+" "+PL.getAddress()+" "+PL.getLatitude()+" "+PL.getLongitude()+" "+PL.leftSeat+" "+PL.getID()+"\n");
        fileWriter.flush();
        fileWriter.close();

        if(owner != null) {
            owner.setParkingLots(parkingLotID);
            // add to file
            FileIO dir = new FileIO(owner.getOwnerID());
            file = dir.setFile("parkingLot_ID.txt");
            fileWriter = new FileWriter(file, true);
            fileWriter.write(PL.getID()+" ");
            fileWriter.flush();
            fileWriter.close();
        }
        else{
            System.out.println("owner is null!");
        }
    }

    public static void initRegisteredParkingLots(RegisteredParkingLot rPL, Owner owner, int ID){
        rPL.setID(ID);
        registeredParkingLots.add(rPL);
        owner.setParkingLots(ID);
        parkingLotID = ID+1;
    }

    public static void addRegisteredParkingLots(RegisteredParkingLot rPL, Owner owner) throws IOException {
        rPL.setID(++parkingLotID);
        registeredParkingLots.add(rPL);
        owner.setParkingLots(parkingLotID);
        // add to file
        File file = new File(filePath+"/"+"registered_parking_lot"+"/"+"registered_parking_list.txt");
        FileWriter fileWriter = new FileWriter(file, true);
        fileWriter.write(rPL.getClient()+" "+rPL.getName()+" "+rPL.getAddress()+" "+rPL.getLatitude()+" "+rPL.getLongitude()+" "+rPL.leftSeat+" "+rPL.getID()+"\n");
        fileWriter.flush();
        fileWriter.close();
        // add to file of owner
        FileIO fileIO = new FileIO(owner.getOwnerToken());
        file = fileIO.setFile("parkingLot_ID.txt");
        fileWriter = new FileWriter(file, true);
        fileWriter.write(rPL.getID()+" ");
        fileWriter.flush();
        fileWriter.close();
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

    public static RegisteredParkingLot getRegisteredParkingLotByID(int ID){
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

    public static void deleteParkingLots(ParkingLot PL) throws IOException {
        parkingLots.remove(PL);
        registeredParkingLots.remove(PL);
    }

    public static void initCar(RegisteredParkingLot PL, String car){
        PL.enteringCar(car);
    }
    public static void addCar(RegisteredParkingLot PL, String car) throws IOException {
        PL.enteringCar(car);
        // add to file
        FileIO dir = new FileIO(Integer.toString(PL.getID()));
        File file = dir.setFile("carList.txt");
        FileWriter fileWriter = new FileWriter(file, true);
        fileWriter.write(car + " ");
        fileWriter.flush();
        fileWriter.close();
    }

    public static void deleteCar(RegisteredParkingLot PL, String car) throws IOException {
        PL.outgoingCar(car);
        // add to file
        FileIO dir = new FileIO(Integer.toString(PL.getID()));
        File file = dir.setFile("carList.txt");
        FileWriter fileWriter = new FileWriter(file);
        for(int i = 0; i < PL.getCars().size(); i++){
            fileWriter.write(PL.getCars().get(i) + " ");
        }
        fileWriter.flush();
        fileWriter.close();
    }
}
