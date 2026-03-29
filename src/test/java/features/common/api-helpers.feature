@ignore
Feature: Reusable Helper Functions
  This feature file contains reusable scenarios that can be called from other features
  These are helper functions for common operations across the API

  Background:
    * url baseUrl

  # Generic GET request helper
  Scenario: Get resource by endpoint and ID
    Given path endpoint, resourceId
    When method GET
    Then status expectedStatus
    * def resourceResponse = response

  # Generic POST request helper
  Scenario: Create resource
    Given path endpoint
    And request requestBody
    When method POST
    Then status expectedStatus
    * def createdResource = response

  # Generic PUT request helper
  Scenario: Update resource
    Given path endpoint, resourceId
    And request requestBody
    When method PUT
    Then status expectedStatus
    * def updatedResource = response

  # Generic DELETE request helper
  Scenario: Delete resource
    Given path endpoint, resourceId
    When method DELETE
    Then status expectedStatus
    * def deleteResponse = response

  # Verify response time is acceptable
  Scenario: Validate response time
    * assert responseTime < maxResponseTime

  # Verify status code and basic response
  Scenario: Validate response
    Then status expectedStatus
    And match response == '#object'
    And match response != '#null'
