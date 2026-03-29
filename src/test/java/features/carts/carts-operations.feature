Feature: Carts API - Shopping Cart Operations
  Test shopping cart functionality including create, read, update, delete operations
  Demonstrating reusable components and complex request structures

  Background:
    * url baseUrl
    * def cartsEndpoint = endpoints.carts
    * configure headers = defaultHeaders

  @smoke @regression @carts @read
  Scenario: Get all carts
    Given path cartsEndpoint
    When method GET
    Then status 200
    And match response == '#[]'
    And match response[0].id == '#number'
    And match response[0].userId == '#number'
    And match response[0].date == '#string'
    And match response[0].products == '#[]'
    And match response[0].products[0] == { productId: '#number', quantity: '#number' }
    * print 'Total carts:', response.length
    * assert response.length > 0

  @smoke @regression @carts @read
  Scenario: Get single cart by ID
    Given path cartsEndpoint, 1
    When method GET
    Then status 200
    And match response.id == 1
    And match response.userId == '#number'
    And match response.date == '#string'
    And match response.products == '#[]'
    * print 'Cart for user:', response.userId

  @regression @carts @read
  Scenario: Get carts with limit parameter
    Given path cartsEndpoint
    And param limit = 3
    When method GET
    Then status 200
    And match response == '#[3]'
    * print 'Limited carts:', response.length

  @regression @carts @read
  Scenario: Get carts sorted in descending order
    Given path cartsEndpoint
    And param sort = 'desc'
    When method GET
    Then status 200
    And match response == '#[]'
    * print 'First cart ID (desc):', response[0].id

  @regression @carts @read
  Scenario: Get carts within date range
    Given path cartsEndpoint
    And param startdate = '2020-01-01'
    And param enddate = '2020-12-31'
    When method GET
    Then status 200
    And match response == '#[]'
    * print 'Carts in date range:', response.length

  @regression @carts @read
  Scenario: Get carts for specific user
    Given path cartsEndpoint, 'user', 1
    When method GET
    Then status 200
    And match response == '#[]'
    And match each response contains { userId: 1 }
    * print 'User 1 carts:', response.length

  @smoke @regression @carts @create
  Scenario: Create a new cart successfully
    * def newCart = TestDataFactory.createCart()
    Given path cartsEndpoint
    And request newCart
    When method POST
    Then status 201
    And match response.id == '#number'
    * print 'Created cart ID:', response.id

  @regression @carts @create
  Scenario: Create cart with multiple products
    * def multiProductCart = TestDataFactory.createCartWithProducts(4)
    Given path cartsEndpoint
    And request multiProductCart
    When method POST
    Then status 201
    And match response.id == '#number'
    * print 'Multi-product cart created:', response.id

  @regression @carts @create @negative
  Scenario: Create cart with invalid user ID
    * def invalidCart = { userId: 99999, date: '2023-12-15', products: [{ productId: 1, quantity: 1 }] }
    Given path cartsEndpoint
    And request invalidCart
    When method POST
    Then status 201
    # Fake Store API doesn't validate user existence

  @regression @carts @create @negative
  Scenario: Create cart with empty products array
    * def emptyCart = { userId: 1, date: '2023-12-15', products: [] }
    Given path cartsEndpoint
    And request emptyCart
    When method POST
    Then status 201

  @regression @carts @update
  Scenario: Update cart with PUT
    * def updatedCart = 
    """
    {
      userId: 3,
      date: '2023-12-20',
      products: [{ productId: 10, quantity: 2 }]
    }
    """
    Given path cartsEndpoint, 1
    And request updatedCart
    When method PUT
    Then status 200
    And match response.id == '#present'
    * print 'Updated cart:', response

  @regression @carts @update
  Scenario: Update cart quantity with PATCH
    * def quantityUpdate = 
    """
    {
      userId: 2,
      date: '2023-12-20',
      products: [{ productId: 1, quantity: 10 }]
    }
    """
    Given path cartsEndpoint, 2
    And request quantityUpdate
    When method PATCH
    Then status 200
    * print 'Cart quantity updated'

  @regression @carts @delete
  Scenario: Delete cart successfully
    Given path cartsEndpoint, 5
    When method DELETE
    Then status 200
    * print 'Deleted cart response:', response

  @integration @carts @workflow
  Scenario: End-to-end cart workflow - Create, Read, Update, Delete
    # Step 1: Create new cart
    * def newCart = { userId: 7, date: '2023-12-15', products: [{ productId: 3, quantity: 2 }] }
    Given path cartsEndpoint
    And request newCart
    When method POST
    Then status 201
    * def cartId = response.id
    * print 'Step 1: Created cart ID:', cartId
    
    # Step 2: Read the cart
    Given path cartsEndpoint, cartId
    When method GET
    Then status 200
    * print 'Step 2: Retrieved cart'
    
    # Step 3: Update cart - add more products
    * def updateCart = { userId: 7, date: '2023-12-15', products: [{ productId: 3, quantity: 5 }, { productId: 7, quantity: 1 }] }
    Given path cartsEndpoint, cartId
    And request updateCart
    When method PUT
    Then status 200
    * print 'Step 3: Updated cart'
    
    # Step 4: Delete cart
    Given path cartsEndpoint, cartId
    When method DELETE
    Then status 200
    * print 'Step 4: Deleted cart - E2E workflow complete'

  @regression @carts @validation
  Scenario: Validate cart response structure
    Given path cartsEndpoint, 1
    When method GET
    Then status 200
    And match response == 
    """
    {
      id: '#number',
      userId: '#number',
      date: '#string',
      products: '#[]',
      __v: '#number'
    }
    """
    And match each response.products == { productId: '#number', quantity: '#number' }
    * assert response.products.length > 0

  @regression @carts @businessLogic
  Scenario: Verify cart can contain same product multiple times
    * def duplicateProductCart = 
    """
    {
      userId: 4,
      date: '2023-12-15',
      products: [
        { productId: 5, quantity: 2 },
        { productId: 5, quantity: 3 }
      ]
    }
    """
    Given path cartsEndpoint
    And request duplicateProductCart
    When method POST
    Then status 201
    * print 'Cart with duplicate products created'

  @regression @carts @dataValidation
  Scenario: Verify all products in cart have valid quantity
    Given path cartsEndpoint, 1
    When method GET
    Then status 200
    * def cartProducts = response.products
    * match each cartProducts contains { productId: '#number', quantity: '#number' }
    * def quantities = karate.map(cartProducts, function(x){ return x.quantity })
    * print 'Product quantities in cart:', quantities
    * assert karate.match(quantities, '#[] #number').pass
