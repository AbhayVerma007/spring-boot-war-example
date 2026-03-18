package com.springhow.example.helloworld;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * HelloWorldApplication - Modernized for Jakarta EE (Tomcat 10+)
 * Instructor: Abhay
 */
@RestController
@SpringBootApplication
public class HelloWorldApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        // This method is critical for WAR deployment. 
        // In Spring Boot 3+, it links the Jakarta Servlet lifecycle to Spring.
        return application.sources(HelloWorldApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(HelloWorldApplication.class, args);
    }

    @GetMapping("/")
    public String helloWorld() {
        // Updated to match your "ABHAY" branding
        return "Welcome to my Online Learning Classes - Jenkins by Abhay";
    }

}
