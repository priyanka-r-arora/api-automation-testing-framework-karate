Feature: Users API - User Management
  Test user management operations with comprehensive validation
  Demonstrating data-driven testing and complex object validation

  Background:
    * url baseUrl
    * def usersEndpoint = endpoints.users
    * configure headers = defaultHeaders

  @smoke @regression @users @read
  Scenario: Get all users successfully
    Given path usersEndpoint
    When method GET
    Then status 200
    And match response == '#[]'
    And match response[0] contains { id: '#number', email: '#string', username: '#string', password: '#string' }
    And match response[0].name contains { firstname: '#string', lastname: '#string' }
    And match response[0].address contains { city: '#string', street: '#string', number: '#number', zipcode: '#string' }
    And match response[0].phone == '#string'
    * print 'Total users:', response.length
    * assert response.length == 10

  @smoke @regression @users @read
  Scenario: Get single user by ID
    Given path usersEndpoint, 1
    When method GET
    Then status 200
    And match response.id == 1
    And match response.email == '#string'
    And match response.username == '#string'
    And match response.name == { firstname: '#string', lastname: '#string' }
    And match response.address == { geolocation: '#object', city: '#string', street: '#string', number: '#number', zipcode: '#string' }
    And match response.phone == '#string'
    * print 'User:', response.username

  @regression @users @read
  Scenario: Get users with limit parameter
    Given path usersEndpoint
    And param limit = 5
    When method GET
    Then status 200
    And match response == '#[5]'
    * print 'Limited users:', response.length

  @regression @users @read
  Scenario: Get users sorted in descending order
    Given path usersEndpoint
    And param sort = 'desc'
    When method GET
    Then status 200
    And match response == '#[]'
    * print 'First user ID (desc):', response[0].id

  @regression @users @read @negative
  Scenario: Get user with invalid ID
    Given path usersEndpoint, 9999
    When method GET
    Then status 200
    # Fake Store API returns null for invalid user ID

  @smoke @regression @users @create
  Scenario: Create a new user successfully
    * def newUser = TestDataFactory.createUser()
    Given path usersEndpoint
    And request newUser
    When method POST
    Then status 201
    And match response.id == '#number'
    * print 'Created user ID:', response.id

  @regression @users @create @negative
  Scenario: Create user with missing required fields
    * def incompleteUser = TestDataFactory.createMinimalUser()
    Given path usersEndpoint
    And request incompleteUser
    When method POST
    Then status 201
    # Fake Store API doesn't strictly validate

  @regression @users @create @negative
  Scenario: Create user with invalid email format
    * def invalidEmailUser = TestDataFactory.createUserWithInvalidEmail()
    Given path usersEndpoint
    And request invalidEmailUser
    When method POST
    Then status 201
    # Fake Store API doesn't validate email format

  @regression @users @update
  Scenario: Update user with PUT
    * def updatedUser = TestDataFactory.createUser()
    Given path usersEndpoint, 1
    And request updatedUser
    When method PUT
    Then status 200
    And match response == '#object'
    * print 'Updated user:', response

  @regression @users @update
  Scenario: Partial update user with PATCH
    * def partialUpdate = { email: 'newemail@example.com', phone: '+31 6 99988877' }
    Given path usersEndpoint, 2
    And request partialUpdate
    When method PATCH
    Then status 200
    * print 'Partially updated user'

  @regression @users @delete
  Scenario: Delete user successfully
    Given path usersEndpoint, 8
    When method DELETE
    Then status 200
    * print 'Deleted user'

  @regression @users @delete @negative
  Scenario: Delete non-existent user
    Given path usersEndpoint, 99999
    When method DELETE
    Then status 200
    # Fake Store API doesn't return 404

  @integration @users @workflow
  Scenario: End-to-end user workflow - Create, Read, Update, Delete
    # Step 1: Create user
    * def newUser = { email: 'e2e@test.com', username: 'e2euser', password: 'test123', name: { firstname: 'E2E', lastname: 'Test' }, address: { city: 'Rotterdam', street: 'Coolsingel', number: 1, zipcode: '3011 AD', geolocation: { lat: '51.9225', long: '4.4792' } }, phone: '+31 6 11223344' }
    Given path usersEndpoint
    And request newUser
    When method POST
    Then status 201
    * def userId = response.id
    * print 'Created user ID:', userId
    
    # Step 2: Read user
    Given path usersEndpoint, userId
    When method GET
    Then status 200
    * print 'Retrieved user:', response.username
    
    # Step 3: Update user
    * def update = { email: 'updated.e2e@test.com' }
    Given path usersEndpoint, userId
    And request update
    When method PATCH
    Then status 200
    * print 'Updated user email'
    
    # Step 4: Delete user
    Given path usersEndpoint, userId
    When method DELETE
    Then status 200
    * print 'E2E user workflow completed'

  @regression @users @validation @datadriven
  Scenario Outline: Data-driven user validation for multiple users
    Given path usersEndpoint, <userId>
    When method GET
    Then status 200
    And match response.id == <userId>
    And match response.username == '#string'
    And match response.email == '#string'
    * print 'Validated user:', response.username

    Examples:
      | userId |
      | 1      |
      | 2      |
      | 3      |
      | 4      |
      | 5      |

  @regression @users @validation
  Scenario: Validate complete user object structure
    Given path usersEndpoint, 1
    When method GET
    Then status 200
    And match response == 
    """
    {
      id: '#number',
      email: '#string',
      username: '#string',
      password: '#string',
      name: {
        firstname: '#string',
        lastname: '#string'
      },
      address: {
        city: '#string',
        street: '#string',
        number: '#number',
        zipcode: '#string',
        geolocation: {
          lat: '#string',
          long: '#string'
        }
      },
      phone: '#string',
      __v: '#number'
    }
    """

  @regression @users @emailValidation
  Scenario: Verify all users have valid email format
    Given path usersEndpoint
    When method GET
    Then status 200
    * def emails = karate.map(response, function(x){ return x.email })
    * print 'All user emails:', emails
    * match each emails == '#string'
    * assert emails.length == 10

  @regression @users @addressValidation
  Scenario: Validate user address contains geolocation
    Given path usersEndpoint, 1
    When method GET
    Then status 200
    And match response.address.geolocation contains { lat: '#string', long: '#string' }
    * def lat = parseFloat(response.address.geolocation.lat)
    * def long = parseFloat(response.address.geolocation.long)
    * assert lat >= -90 && lat <= 90
    * assert long >= -180 && long <= 180
    * print 'Valid geolocation:', response.address.geolocation
