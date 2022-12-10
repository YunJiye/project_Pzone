package com.example.project_Pzone;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.File;
import java.util.ArrayList;

public class FileIO {

    private File Folder;

    FileIO(){
        System.out.println(Database.filePath);
        Folder = new File(Database.filePath);

        if (!Folder.exists()) {
            try{
                Folder.mkdirs();
            }
            catch(Exception e){
                e.getStackTrace();
            }
        }else {
            System.out.println("folder " + Folder.getPath() + " already exists.");
        }
    }

    FileIO(String folderName){
        Folder = new File(Database.filePath+"/"+folderName);

        if (!Folder.exists()) {
            try{
                Folder.mkdirs();
            }
            catch(Exception e){
                e.getStackTrace();
            }
        }else {
            System.out.println("folder " + Folder.getPath() + " already exists.");
        }
    }

    FileIO(int parkingLotID, int fileType){
        Folder = new File(Database.filePath+"/"+"registered_parking_lot"+"/"+Integer.toString(parkingLotID)+"/"+Integer.toString(fileType));

        if (!Folder.exists()) {
            try{
                Folder.mkdirs();
            }
            catch(Exception e){
                e.getStackTrace();
            }
        }else {
            System.out.println("folder " + Folder.getPath() + " already exists.");
        }
    }

    public String getFilePath(){
        return Folder.getPath();
    }

    public File getFolder(){
        return Folder;
    }

    public File setFile(String fileName){
        File file = new File(Folder.getPath()+"/"+fileName);
        if(!file.exists()){
            try{
                file.createNewFile();   // get file or make new file.
            }
            catch (Exception e){
                e.getStackTrace();
            }
        }
        return file;
    }

    public File setFile(int parkingLotID, int fileType){
        File file = new File(Folder.getPath()+"/"+parkingLotID+"/"+fileType);
        if(!file.exists()){
            try{
                file.createNewFile();   // get file or make new file.
            }
            catch (Exception e){
                e.getStackTrace();
            }
        }
        return file;
    }

    public File setFile(int parkingLotID, int fileType, char section){
        File file = new File(Folder.getPath()+"/"+parkingLotID+"/"+fileType+"/"+section);
        if(!file.exists()){
            try{
                file.createNewFile();   // get file or make new file.
            }
            catch (Exception e){
                e.getStackTrace();
            }
        }
        return file;
    }
}
