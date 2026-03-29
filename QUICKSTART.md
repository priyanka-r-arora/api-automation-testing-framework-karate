# Quick Start Guide

Get started with the Karate API Automation Framework in 5 minutes!

## Quick Setup

### 1. Prerequisites Check
```bash
# Verify Java installation (JDK 17+)
java -version

# Verify Maven installation (3.6+)
mvn -version
```

### 2. Clone & Setup
```bash
# Clone the repository
git clone https://github.com/yourusername/karate-api-automation.git
cd karate-api-automation

# Install dependencies
mvn clean install -DskipTests
```

### 3. Run Your First Test
```bash
# Run smoke tests (fastest, ~30 seconds)
mvn clean test -Dtest=SmokeTestRunner
```

## Common Commands

### Run Tests
```bash
# All tests in parallel
mvn clean test -Dtest=ParallelRunner

# Smoke tests only
mvn clean test -Dtest=SmokeTestRunner

# Regression suite
mvn clean test -Dtest=RegressionTestRunner

# Negative scenarios
mvn clean test -Dtest=NegativeTestRunner
```

### Environment Selection
```bash
# Default (dev)
mvn clean test -Dtest=ParallelRunner

# Staging environment
mvn clean test -Dtest=ParallelRunner -Dkarate.env=staging

# Production environment
mvn clean test -Dtest=ParallelRunner -Dkarate.env=prod
```

### Run by Tags
```bash
# Smoke tests
mvn test -Dtest=ParallelRunner -Dkarate.options="--tags @smoke"

# Authentication tests only
mvn test -Dtest=ParallelRunner -Dkarate.options="--tags @authentication"

# Products tests only
mvn test -Dtest=ParallelRunner -Dkarate.options="--tags @products"

# Carts tests only
mvn test -Dtest=ParallelRunner -Dkarate.options="--tags @carts"

# Users tests only
mvn test -Dtest=ParallelRunner -Dkarate.options="--tags @users"
```

### View Reports
```bash
# Karate HTML Report (auto-generated after test run)
open target/karate-reports/karate-summary.html

# Smoke Test Report
open target/smoke-reports/karate-summary.html

# Feature-specific reports
open target/karate-reports/*.html

# View logs
cat target/karate.log
```

## Understanding Test Results

### Console Output
After test execution, you'll see:
```
==============================================
Karate Test Execution Summary
==============================================
Total Features: 8
Passed Features: 8
Failed Features: 0
Total Scenarios: 150
Passed Scenarios: 150
Failed Scenarios: 0
Total Time: 45000 ms
==============================================
```

### Report Locations
- **Karate HTML Reports**: `target/karate-reports/karate-summary.html`
- **Smoke Test Reports**: `target/smoke-reports/karate-summary.html`
- **Cucumber JSON**: `target/karate-reports/*.json`
- **Logs**: `target/karate.log`

## Writing Your First Test

### 1. Create a new feature file
```gherkin
# src/test/java/features/mytest/mytest.feature
Feature: My First Test

  Background:
    * url baseUrl

  @smoke
  Scenario: Get all products
    Given path '/products'
    When method GET
    Then status 200
    And match response == '#[]'
```

### 2. Run your test
```bash
mvn test -Dtest=ParallelRunner -Dkarate.options="classpath:features/mytest/mytest.feature"
```

## Customization

### Modify Test Data
Edit files in `src/test/resources/data/`:
- `test-users.csv` - User credentials
- `test-products.json` - Product data
- `test-users-data.json` - User information

### Modify Configuration
Edit `src/test/java/karate-config.js`:
```javascript
var config = {
  baseUrl: 'https://fakestoreapi.com',
  apiTimeout: 30000,
  // Add your custom config here
};
```

## Troubleshooting

### Tests Failing?
```bash
# Check test logs
cat target/karate.log

# Run single test for debugging
mvn test -Dtest=ParallelRunner -Dkarate.options="classpath:features/auth/login.feature"

# Enable debug mode
mvn test -Dtest=SmokeTestRunner -Dkarate.env=dev
```

### Build Errors?
```bash
# Clean and rebuild
mvn clean install -DskipTests

# Verify dependencies
mvn dependency:tree
```

### Report Not Generated?
```bash
# Ensure test completed
mvn clean test -Dtest=SmokeTestRunner

# Check output directory
ls -la target/karate-reports/
```

## Next Steps

1. Set up your IDE (IntelliJ/Eclipse/VS Code)
2. Install Karate plugin for syntax highlighting
3. Read the [main README](README.md) for detailed documentation
4. Explore existing test scenarios
5. Set up CI/CD in your repository

## Learning Resources

- [Karate Documentation](https://github.com/karatelabs/karate)
- [Fake Store API Docs](https://fakestoreapi.com/docs)
- [Example Tests](src/test/java/features/)

## Tips

- Start with smoke tests to verify setup
- Use tags to organize and filter tests
- Check reports for detailed test results
- Use utilities in `common-utils.js` for data generation
- Follow existing patterns when adding new tests

---

## Need Help?

- Check the [FAQ](README.md#troubleshooting)
- Read [Contributing Guide](CONTRIBUTING.md)
- Open an [issue on GitHub](https://github.com/yourusername/karate-api-automation/issues)

---

**Happy Testing!**
