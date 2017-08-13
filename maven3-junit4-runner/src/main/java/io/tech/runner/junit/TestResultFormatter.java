package io.tech.runner.junit;

import java.io.BufferedOutputStream;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;

import org.junit.runner.notification.Failure;
import org.junit.runner.notification.RunListener;

public class TestResultFormatter extends RunListener {
    
    private String stackStop;
    
    public TestResultFormatter(String stackStop) {
        this.stackStop = stackStop;
    }
    
    @Override
    public void testFailure(Failure failure) {
        
        String[] stackLines = failure.getTrace().split("\n");
        
        int excludeStart = stackLines.length;
        int excludeStop = stackLines.length;
        
        for (int i = stackLines.length; i-->0;) {
            if (stackLines[i].contains(stackStop)) {
                excludeStart = i + 1;
                break;
            }
        }
        for (int i = excludeStart, il = stackLines.length; i < il; i++) {
            if (stackLines[i].contains("Caused by")) {
                excludeStop = i - 1;
                break;
            }
        }
        
        for (int i = 0, il = stackLines.length; i < il; i++) {
            if (i < excludeStart || i > excludeStop) {
                System.err.println(stackLines[i]);
            }
        }
    }
}
