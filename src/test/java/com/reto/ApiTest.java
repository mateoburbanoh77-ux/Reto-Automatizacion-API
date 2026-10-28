package com.reto;
import com.intuit.karate.junit5.Karate;
public class ApiTest {
    @Karate.Test
    Karate ejecutarPruebas() {
        return Karate.run("classpath:features");
    }
}