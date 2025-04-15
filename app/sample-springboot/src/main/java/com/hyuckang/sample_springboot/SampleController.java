package com.hyuckang.sample_springboot;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SampleController {
    
    @GetMapping("/hello-world")
    public String helloWorld() {
        return "hello-world from sample springboot";
    }

    @GetMapping("/sample-springboot")
    public String sampleSpringboot() {
        return "sample-springboot from sample springboot";
    }

    @GetMapping("/sample")
    public String sample() {
        return "sample from sample springboot";
    }
}
