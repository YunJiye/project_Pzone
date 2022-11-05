package com.example.project_Pzone;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ProjectPzoneApplication {

	public static void main(String[] args) {
		Database.init();
		SpringApplication.run(ProjectPzoneApplication.class, args);
	}

}
