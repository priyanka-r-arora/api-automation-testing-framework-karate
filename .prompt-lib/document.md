Build a production-ready Karate DSL API automation framework for testing Fake Store API (https://fakestoreapi.com) with the following requirements:

FRAMEWORK SPECIFICATIONS:
- Java 17 + Maven project
- Karate DSL 1.5.0 (use karate-junit5 dependency)
- Include: logback for logging, json-schema-validator for contract testing
- NO Allure or Gatling dependencies - use Karate's native HTML reports only

STRUCTURE:
- 4 test runners: ParallelRunner (5 threads), SmokeTestRunner (@smoke tag, 3 threads), RegressionTestRunner (@regression tag), NegativeTestRunner (@negative tag)
- 4 feature files with 1 working test scenario each:
  1. auth/login.feature - POST /auth/login (authentication)
  2. products/products-crud.feature - All CRUD operations (GET, POST, PUT, DELETE) for /products
  3. carts/carts-operations.feature - All CRUD operations for /carts
  4. users/users-management.feature - All CRUD operations for /users
- Multi-environment config (dev, staging, prod) in karate-config.js
- Reusable utilities in common-utils.js (random data generators)
- JSON schemas for validation (product, user, cart, auth)
- Test data files (CSV and JSON)
- Common helper features for reusability

CRITICAL IMPLEMENTATION NOTES:
1. Karate 1.5.0 uses: results.getFeaturesPassed(), results.getScenariosPassed() (not *Count versions)
2. Fake Store API returns: POST=201, GET/PUT/DELETE=200, missing auth=400, invalid auth=401
3. Fake Store API doesn't persist data - use existing IDs (1-20) for read/update/delete operations
4. JWT token regex pattern: [A-Za-z0-9_\-.]+
5. Maven commands need -Dtest runner: mvn test -Dtest=ParallelRunner -Dkarate.options="--tags @smoke"

INCLUDE:
- GitHub Actions CI/CD workflow (smoke → regression → parallel → negative tests, artifact upload)
- .gitignore (target/, .karate/, IDE files, reports, logs)
- Comprehensive README.md with architecture, setup, commands, test tags
- QUICKSTART.md with 5-minute setup guide
- CONTRIBUTING.md with guidelines
- NO emojis in documentation

DELIVERABLE:
Complete working framework where mvn test -Dtest=ParallelRunner executes successfully with all tests passing. All scenarios must have proper status code assertions, schema validation, and meaningful assertions.