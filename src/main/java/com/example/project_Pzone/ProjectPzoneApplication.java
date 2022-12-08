package com.example.project_Pzone;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.FileNotFoundException;

@SpringBootApplication
public class ProjectPzoneApplication {

	public static void main(String[] args) throws FileNotFoundException {
		Database.init();
		SpringApplication.run(ProjectPzoneApplication.class, args);
	}

}
