package runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

/**
 * Regression Test Runner
 * Executes comprehensive regression test suite
 * 
 * Usage:
 * mvn test -Dtest=RegressionTestRunner
 */
class RegressionTestRunner {

    @Test
    void runRegressionTests() {
        Results results = Runner.path("classpath:features")
                .tags("@regression")
                .outputCucumberJson(true)
                .reportDir("target/regression-reports")
                .parallel(5);
        
        System.out.println("==============================================");
        System.out.println("Regression Test Execution Summary");
        System.out.println("==============================================");
        System.out.println("Total Features: " + results.getFeaturesTotal());
        System.out.println("Total Scenarios: " + results.getScenariosTotal());
        System.out.println("Passed Scenarios: " + results.getScenariosPassed());
        System.out.println("Failed Scenarios: " + results.getScenariosFailed());
        System.out.println("Total Time: " + results.getElapsedTime() + " ms");
        System.out.println("==============================================");
        
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
