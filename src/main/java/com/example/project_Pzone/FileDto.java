package com.example.project_Pzone;

/*
    file type information
    1 : cctv picture
    2 : cctv video
    3 : parking lot sketch  => 도면의 그림화
    4 : parking lot drawing => 도면
*/
public class FileDto {
    private String uuid;    // to make unique name => stored file name : uuid_fileName
    private String fileName;
    private String contentType;
    private int parkingLotID;   // unique ID of each parking lots.
    private int fileType;
    private int CCTVID; // if it's a file of cctv, then you have to set cctv id.

    public FileDto(String uuid, String fileName, String contentType, int parkingLotID, int fileType){
        this.uuid = uuid;
        this.fileName = fileName;
        this.contentType = contentType;
        this.parkingLotID = parkingLotID;
        this.fileType = fileType;
        CCTVID = 0; // default value
        //System.out.println(contentType);
    }

    public String getUuid() {
        return uuid;
    }

    public String getContentType() {
        return contentType;
    }

    public String getFileName() {
        return fileName;
    }

    public int getParkingLotID(){
        return parkingLotID;
    }

    public int getFileType(){
        return fileType;
    }

    public int getCCTVID(){
        return CCTVID;
    }

    public void setUuid(String uuid){
        this.uuid = uuid;
    }

    public void setFileName(String fileName){
        this.fileName = fileName;
    }

    public void setContentType(String contentType){
        this.contentType = contentType;
    }

    public void setParkingLotID(int ID){
        parkingLotID = ID;
    }

    public void setFileType(int type){
        fileType = type;
    }

    public void setCCTVID(int cctvid){
        CCTVID = cctvid;
    }

}
