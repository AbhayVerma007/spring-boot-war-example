package com.springhow.example.helloworld;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.web.bind.annotation.GetMapping; // Modern practice uses GetMapping
import org.springframework.web.bind.annotation.RestController;

@RestController
@SpringBootApplication
public class HelloWorldApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        // This method is critical for WAR deployment in Tomcat 10
        return application.sources(HelloWorldApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(HelloWorldApplication.class, args);
    }

    @GetMapping("/")
    String helloWorld() {
        return "Welcome to my Online Learning Classes - Jenkins by Shikhar";
    }

}
