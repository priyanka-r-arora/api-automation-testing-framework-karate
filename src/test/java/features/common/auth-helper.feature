Feature: Authentication Helper - Reusable Login Function
  This is a reusable feature that can be called from other features
  to handle authentication and obtain tokens

  Background:
    * url baseUrl

  @ignore
  Scenario: Get authentication token
    Given path endpoints.auth
    And request { username: '#(username)', password: '#(password)' }
    When method POST
    Then status 201
    And match response.token == '#notnull'
    * def authToken = response.token
