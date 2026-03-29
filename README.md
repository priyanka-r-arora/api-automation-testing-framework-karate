# Karate API Automation Framework


[![Build and Deploy](https://github.com/kratostaine/spring-authorization-server/actions/workflows/continuous-integration-workflow.yml/badge.svg)](https://github.com/priyanka-r-arora/karate-automation-framework/actions/workflows/ci.yml)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/)
[![Karate](https://img.shields.io/badge/Karate-1.5.0-blue.svg)](https://github.com/karatelabs/karate)

## Overview

A production-ready API automation framework built with **Karate DSL**, demonstrating enterprise-grade testing practices for the [Fake Store API](https://fakestoreapi.com). This framework showcases comprehensive test automation capabilities including functional testing, data-driven testing, schema validation and CI/CD integration.

### Key Features

- **Comprehensive Test Coverage**: Authentication, Products, Carts and Users API testing
- **Multi-Environment Support**: Dev, Staging and Production configurations
- **Parallel Execution**: Optimized for faster test runs with 5 parallel threads
- **Advanced Reporting**: Karate HTML and Cucumber JSON reports
- **Schema Validation**: Contract testing using JSON Schema validation
- **Data-Driven Testing**: CSV and JSON parameterization for comprehensive coverage
- **Reusable Components**: Helper functions and utilities for code reusability
- **CI/CD Integration**: GitHub Actions workflow with automated test execution
- **Professional Logging**: Logback configuration with detailed test logs
- **Test Categorization**: Tagged scenarios (@smoke, @regression, @negative, @integration)

---

## Important Note

**This framework is designed for learning and demonstration purposes.** It showcases production-ready patterns, architecture and best practices for API test automation using Karate DSL. The framework structure, utilities and CI/CD pipeline configuration can be directly adapted for your own projects.

**About the CI/CD Pipeline:** The GitHub Actions pipeline may experience intermittent failures due to Cloudflare bot protection on the Fake Store API (403 responses). This is a limitation of the demo API, not the framework itself. The pipeline serves as a **reference implementation** demonstrating:
- Multi-stage test execution (build → smoke → regression → parallel)
- Environment-specific configurations
- Automated reporting and artifact management
- Best practices for CI/CD integration

**For your projects:** Simply point the `baseUrl` to your own API endpoints and the framework will work seamlessly without any Cloudflare-related issues.

---

## Project Architecture

```
karate-api-automation/
├── .github/
│   └── workflows/
│       └── ci.yml
├── src/test/java/
│   ├── features/
│   │   ├── auth/
│   │   │   └── login.feature
│   │   ├── products/
│   │   │   └── products-crud.feature
│   │   ├── carts/
│   │   │   └── carts-operations.feature
│   │   ├── users/
│   │   │   └── users-management.feature
│   │   ├── common/
│   │   │   ├── auth-helper.feature
│   │   │   └── api-helpers.feature
│   ├── runners/
│   │   ├── ParallelRunner.java
│   │   ├── SmokeTestRunner.java
│   │   ├── RegressionTestRunner.java
│   │   └── NegativeTestRunner.java
│   ├── utils/
│   │   └── common-utils.js
│   ├── karate-config.js
│   └── logback-test.xml
├── src/test/resources/
│   ├── data/
│   │   ├── test-users.csv
│   │   ├── test-products.json
│   │   └── test-users-data.json
│   ├── schemas/
│   │   ├── product-schema.json
│   │   ├── user-schema.json
│   │   ├── cart-schema.json
│   │   └── auth-token-schema.json
│   └── config/
│       ├── dev.json
│       ├── staging.json
│       └── prod.json
├── pom.xml
├── .gitignore
└── README.md
```

---

## Getting Started

### Prerequisites

- **Java 17** or higher
- **Maven 3.6+**
- **Git**

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/priyanka-r-arora/karate-api-automation.git
   cd karate-api-automation
   ```

2. **Install dependencies**
   ```bash
   mvn clean install -DskipTests
   ```

3. **Verify setup**
   ```bash
   mvn clean test -Dtest=SmokeTestRunner
   ```

---

## Running Tests

### Run All Tests (Parallel Execution)
```bash
mvn clean test -Dtest=ParallelRunner
```

### Run Smoke Tests
```bash
mvn clean test -Dtest=SmokeTestRunner
```

### Run Regression Tests
```bash
mvn clean test -Dtest=RegressionTestRunner
```

### Run Negative Tests
```bash
mvn clean test -Dtest=NegativeTestRunner
```

### Run Tests with Specific Environment
```bash
mvn clean test -Dtest=ParallelRunner -Dkarate.env=staging
```

### Run Tests by Tags
```bash
# Run only smoke tests
mvn test -Dtest=ParallelRunner -Dkarate.options="--tags @smoke"

# Run regression tests
mvn test -Dtest=ParallelRunner -Dkarate.options="--tags @regression"

# Run negative tests
mvn test -Dtest=ParallelRunner -Dkarate.options="--tags @negative"

# Exclude certain tags
mvn test -Dtest=ParallelRunner -Dkarate.options="--tags ~@ignore"
```

### Run Specific Feature File
```bash
mvn test -Dtest=ParallelRunner -Dkarate.options="classpath:features/auth/login.feature"
```

---

## Reports

### Karate HTML Reports
After test execution, HTML reports are generated automatically:
```
target/karate-reports/karate-summary.html
```

### Cucumber JSON Reports
JSON reports are generated for CI/CD integration:
```
target/karate-reports/*.json
```

---

## Configuration

### Environment Configuration

The framework uses JSON-based configuration files for different environments located in `src/test/resources/config/`:

**dev.json** (Development)
```json
{
  "baseUrl": "https://fakestoreapi.com",
  "timeout": 30000,
  "retryEnabled": true,
  "retryCount": 2,
  "debugMode": true,
  "parallelThreads": 3,
  "logLevel": "DEBUG"
}
```

**staging.json** (Staging)
```json
{
  "baseUrl": "https://fakestoreapi.com",
  "timeout": 45000,
  "retryEnabled": true,
  "retryCount": 3,
  "debugMode": true,
  "parallelThreads": 5,
  "logLevel": "INFO"
}
```

**prod.json** (Production)
```json
{
  "baseUrl": "https://fakestoreapi.com",
  "timeout": 60000,
  "retryEnabled": true,
  "retryCount": 5,
  "debugMode": false,
  "parallelThreads": 10,
  "logLevel": "WARN"
}
```

The `karate-config.js` dynamically loads the appropriate configuration based on the `karate.env` system property:

```javascript
var envConfig = karate.read('classpath:config/' + env + '.json');
```

To switch environments, use the `-Dkarate.env` parameter (defaults to `dev` if not specified).

### Test Data

- **CSV Files**: `src/test/resources/data/*.csv`
- **JSON Files**: `src/test/resources/data/*.json`

### Schema Validation

JSON schemas are located in: `src/test/resources/schemas/`

---

## Test Tags

The framework uses tags to categorize test scenarios:

| Tag | Description |
|-----|-------------|
| `@smoke` | Critical path tests for quick validation |
| `@regression` | Comprehensive test suite |
| `@negative` | Error handling and negative scenarios |
| `@integration` | End-to-end workflow tests |
| `@authentication` | Authentication-related tests |
| `@products` | Product API tests |
| `@carts` | Cart API tests |
| `@users` | User API tests |

---

## CI/CD Pipeline

The framework includes a comprehensive GitHub Actions workflow:

### Workflow Execution Order
1. **Build Verification** - Compile and install dependencies (runs first)
2. **Smoke Tests** - Critical path validation (after build passes)
3. **Regression/Parallel/Negative Tests** - Full test suite (after smoke tests)

### Automated Test Execution
- Build verification (compile and dependency check)
- Smoke tests (on every push/PR)
- Regression tests (after smoke tests pass)
- Parallel execution (full test suite)
- Negative tests (error scenarios)

### Scheduled Tests
- Daily test execution at 2 AM UTC

### Manual Trigger
Trigger workflow manually with environment selection from GitHub Actions UI

### Artifacts
All test reports are uploaded as artifacts with 30-day retention

### Known Issues

**Fake Store API Cloudflare Protection**: The demo API used in this framework is protected by Cloudflare, which may block automated requests from CI/CD runners (GitHub Actions) with 403 responses. This is expected behavior for the demo API and does not reflect any issues with the framework itself.

**This framework is for educational purposes** - use it as a reference to understand:
- How to structure a production-grade Karate framework
- Multi-environment configuration patterns
- CI/CD pipeline setup with GitHub Actions
- Dynamic test data generation with Factory and Builder patterns
- Report generation and artifact management

**When adapting this for your projects**, simply update the `baseUrl` in your environment configs to point to your own APIs, and the framework will work without any Cloudflare-related issues.

---

## API Documentation

This framework tests the following Fake Store API endpoints:

### Authentication
- `POST /auth/login` - User login

### Products
- `GET /products` - Get all products
- `GET /products/{id}` - Get single product
- `POST /products` - Create product
- `PUT /products/{id}` - Update product
- `PATCH /products/{id}` - Partial update
- `DELETE /products/{id}` - Delete product
- `GET /products/categories` - Get categories
- `GET /products/category/{category}` - Get products by category

### Carts
- `GET /carts` - Get all carts
- `GET /carts/{id}` - Get single cart
- `POST /carts` - Create cart
- `PUT /carts/{id}` - Update cart
- `DELETE /carts/{id}` - Delete cart

### Users
- `GET /users` - Get all users
- `GET /users/{id}` - Get single user
- `POST /users` - Create user
- `PUT /users/{id}` - Update user
- `DELETE /users/{id}` - Delete user

---

## Utilities & Helpers

### Java Test Data Utilities
The framework uses enterprise-grade Java utilities with Builder and Factory patterns for dynamic test data generation:

- **TestDataFactory** - Central factory providing simple static methods for creating test data
  - `createUser()`, `createProduct()`, `createCart()` - Generate complete realistic data
  - `createMinimalUser()`, `createMinimalProduct()` - Generate minimal data for negative tests
  - `createUserWithInvalidEmail()` - Generate invalid data for validation testing
  - Builder methods for custom data: `userBuilder()`, `productBuilder()`, `cartBuilder()`

- **FakerProvider** - Centralized JavaFaker instance with Dutch locale
  - Singleton pattern for consistent data generation
  - Realistic Netherlands data (Amsterdam, Rotterdam, Dutch addresses, phone numbers)

- **Builder Classes** - Flexible data creation with method chaining
  - `UserBuilder` - Build users with custom fields or use defaults
  - `ProductBuilder` - Build products with category-specific methods
  - `CartBuilder` - Build carts with dynamic product counts

### Reusable Features
- `auth-helper.feature` - Authentication helper
- `api-helpers.feature` - Generic API operations

---

## Test Metrics

### Coverage
- **65** test scenarios
- **Authentication**: 9 scenarios
- **Products**: 17 scenarios
- **Carts**: 19 scenarios
- **Users**: 21 scenarios
- **Negative Tests**: Included in above categories

---

## Technologies Used

| Technology | Version | Purpose |
|------------|---------|---------|
| Karate DSL | 1.5.0 | API test automation framework |
| Java | 17 | Programming language |
| Maven | 3.11.0 | Build and dependency management |
| JUnit 5 | 5.x | Test execution engine |
| JavaFaker | 1.0.2 | Realistic test data generation with Dutch locale |
| Logback | 1.4.11 | Logging framework |
| GitHub Actions | - | CI/CD pipeline |

---

## Best Practices Implemented

1. **Page Object Model equivalent** - Feature files organized by domain
2. **DRY Principle** - Reusable helper features and utilities
3. **Data-Driven Testing** - Externalized test data in CSV/JSON
4. **Schema Validation** - Contract testing with JSON schemas
5. **Parallel Execution** - Optimized test execution time
6. **Comprehensive Logging** - Detailed logs for debugging
7. **CI/CD Integration** - Automated test execution
8. **Test Categorization** - Tagged scenarios for selective execution
9. **Error Handling** - Negative test scenarios

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Author

**Priyanka Arora**
- GitHub: [@priyanka-r-arora](https://github.com/priyanka-r-arora)
- LinkedIn: [@priyanka-arora](https://linkedin.com/in/priyanka-r-arora)

---

## Acknowledgments

- [Karate DSL](https://github.com/karatelabs/karate) - Amazing API testing framework
- [Fake Store API](https://fakestoreapi.com) - Free API for testing and prototyping

---

**If you find this project useful, please give it a star! Thank you!**
