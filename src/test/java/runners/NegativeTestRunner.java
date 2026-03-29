package runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

/**
 * Negative Test Runner  
 * Executes negative test scenarios to verify error handling
 * 
 * Usage:
 * mvn test -Dtest=NegativeTestRunner
 */
class NegativeTestRunner {

    @Test
    void runNegativeTests() {
        Results results = Runner.path("classpath:features")
                .tags("@negative")
                .outputCucumberJson(true)
                .reportDir("target/negative-reports")
                .parallel(3);
        
        System.out.println("==============================================");
        System.out.println("Negative Test Execution Summary");
        System.out.println("==============================================");
        System.out.println("Total Scenarios: " + results.getScenariosTotal());
        System.out.println("Passed: " + results.getScenariosPassed());
        System.out.println("Failed: " + results.getScenariosFailed());
        System.out.println("Time: " + results.getElapsedTime() + " ms");
        System.out.println("==============================================");
        
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
