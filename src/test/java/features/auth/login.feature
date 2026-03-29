Feature: Authentication - User Login
  As a user of Fake Store API
  I want to authenticate with valid credentials
  So that I can access protected resources

  Background:
    * url baseUrl
    * def authEndpoint = endpoints.auth
    * header Content-Type = 'application/json'

  @smoke @regression @authentication
  Scenario: Successful login with valid credentials
    Given path authEndpoint
    And request { username: '#(testUsers.validUser.username)', password: '#(testUsers.validUser.password)' }
    When method POST
    Then status 201
    And match response == { token: '#string' }
    And match response.token == '#notnull'
    And match response.token == '#regex [A-Za-z0-9_\\-.]+'
    * def authToken = response.token
    * print 'Auth token:', authToken

  @smoke @regression @negative @authentication
  Scenario: Login fails with invalid username
    Given path authEndpoint
    And request { username: 'invaliduser@test.com', password: 'm38rmF$' }
    When method POST
    Then status 401

  @regression @negative @authentication
  Scenario: Login fails with invalid password
    Given path authEndpoint
    And request { username: 'johnd', password: 'wrongPassword123' }
    When method POST
    Then status 401

  @regression @negative @authentication
  Scenario: Login fails with missing username
    Given path authEndpoint
    And request { password: 'm38rmF$' }
    When method POST
    Then status 400

  @regression @negative @authentication
  Scenario: Login fails with missing password
    Given path authEndpoint
    And request { username: 'johnd' }
    When method POST
    Then status 400

  @regression @negative @authentication
  Scenario: Login fails with empty credentials
    Given path authEndpoint
    And request { username: '', password: '' }
    When method POST
    Then status 400

  @regression @authentication
  Scenario: Login fails with null values
    Given path authEndpoint
    And request { username: null, password: null }
    When method POST
    Then status 400

  @regression @integration @authentication
  Scenario Outline: Data-driven login tests with multiple users
    Given path authEndpoint
    And request { username: '<username>', password: '<password>' }
    When method POST
    Then status <expectedStatus>
    And match response.token == '<tokenValidation>'

    Examples:
      | username | password  | expectedStatus | tokenValidation |
      | johnd    | m38rmF$   | 201            | #notnull        |
      | mor_2314 | 83r5^_    | 201            | #notnull        |
      | kevinryan| kev02937@ | 201            | #notnull        |
      | invalid  | invalid   | 401            | ##null          |

  @regression @authentication @security
  Scenario: Verify token response structure
    Given path authEndpoint
    And request { username: '#(testUsers.validUser.username)', password: '#(testUsers.validUser.password)' }
    When method POST
    Then status 201
    And match response == { token: '#string' }
    And assert response.token.length > 10
    * print 'Token length:', response.token.length
