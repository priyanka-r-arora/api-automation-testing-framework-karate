package runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

/**
 * Smoke Test Runner
 * Executes only smoke tests for quick validation
 * 
 * Usage:
 * mvn test -Dtest=SmokeTestRunner
 */
class SmokeTestRunner {

    @Test
    void runSmokeTests() {
        Results results = Runner.path("classpath:features")
                .tags("@smoke")
                .outputCucumberJson(true)
                .reportDir("target/smoke-reports")
                .parallel(3);
        
        System.out.println("==============================================");
        System.out.println("Smoke Test Execution Summary");
        System.out.println("==============================================");
        System.out.println("Total Scenarios: " + results.getScenariosTotal());
        System.out.println("Passed: " + results.getScenariosPassed());
        System.out.println("Failed: " + results.getScenariosFailed());
        System.out.println("Time: " + results.getElapsedTime() + " ms");
        System.out.println("==============================================");
        
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
