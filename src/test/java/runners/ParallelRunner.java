package runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

/**
 * Main Parallel Test Runner
 * Executes all feature files in parallel for faster test execution
 * Generates Cucumber JSON reports for advanced reporting
 * 
 * Usage:
 * mvn test -Dtest=ParallelRunner
 * mvn test -Dtest=ParallelRunner -Dkarate.env=staging
 */
class ParallelRunner {

    @Test
    void testParallel() {
        Results results = Runner.path("classpath:features")
                .outputCucumberJson(true)
                .outputJunitXml(true)
                .reportDir("target/karate-reports")
                .parallel(5);
        
        System.out.println("==============================================");
        System.out.println("Karate Test Execution Summary");
        System.out.println("==============================================");
        System.out.println("Total Features: " + results.getFeaturesTotal());
        System.out.println("Passed Features: " + results.getFeaturesPassed());
        System.out.println("Failed Features: " + results.getFeaturesFailed());
        System.out.println("Total Scenarios: " + results.getScenariosTotal());
        System.out.println("Passed Scenarios: " + results.getScenariosPassed());
        System.out.println("Failed Scenarios: " + results.getScenariosFailed());
        System.out.println("Total Time: " + results.getElapsedTime() + " ms");
        System.out.println("==============================================");
        
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}

