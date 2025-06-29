package com.example;
import org.junit.Test;
import static org.junit.Assert.*;

public class CalculatorTest {

    @Test
    public void testAddition() {
        int a = 3;
        int b = 5;
        int result = a + b;
        assertEquals(8, result);
    }
}
