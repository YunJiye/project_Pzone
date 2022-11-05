package com.example.project_Pzone;

public class FileDto {
    private String uuid;    // to make unique name => stored file name : uuid_fileName
    private String fileName;
    private String contentType;

    public FileDto(String uuid, String fileName, String contentType){
        this.uuid = uuid;
        this.fileName = fileName;
        this.contentType = contentType;
        System.out.println(contentType);
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
}
