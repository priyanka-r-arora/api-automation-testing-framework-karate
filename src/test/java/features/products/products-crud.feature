Feature: Products API - CRUD Operations
  Test comprehensive CRUD operations for Products API
  Demonstrating GET, POST, PUT, PATCH, DELETE methods

  Background:
    * url baseUrl
    * def productsEndpoint = endpoints.products
    * configure headers = defaultHeaders

  @smoke @regression @products @read
  Scenario: Get all products successfully
    Given path productsEndpoint
    When method GET
    Then status 200
    And match response == '#[]'
    And match response[0].id == '#number'
    And match response[0].title == '#string'
    And match response[0].price == '#number'
    And match response[0].description == '#string'
    And match response[0].category == '#string'
    And match response[0].image == '#string'
    And match response[0].rating == { rate: '#number', count: '#number' }
    * print 'Total products:', response.length
    * assert response.length == 20

  @smoke @regression @products @read
  Scenario: Get single product by ID
    Given path productsEndpoint, 1
    When method GET
    Then status 200
    And match response.id == 1
    And match response.title == '#string'
    And match response.price == '#number'
    And match response.description == '#string'
    And match response.category == '#string'
    And match response.image == '#string'
    And match response.rating == { rate: '#number', count: '#number' }
    * print 'Product:', response.title

  @regression @products @read @negative
  Scenario: Get product with invalid ID returns 404 or empty response
    Given path productsEndpoint, 9999
    When method GET
    Then status 200
    # Fake Store API returns null for invalid IDs instead of 404

  @regression @products @read
  Scenario: Get products with limit parameter
    Given path productsEndpoint
    And param limit = 5
    When method GET
    Then status 200
    And match response == '#[5]'
    * print 'Limited products count:', response.length

  @regression @products @read
  Scenario: Get products sorted in descending order
    Given path productsEndpoint
    And param sort = 'desc'
    When method GET
    Then status 200
    And match response == '#[]'
    * print 'First product ID (desc):', response[0].id

  @smoke @regression @products @read
  Scenario: Get all product categories
    Given path endpoints.categories
    When method GET
    Then status 200
    And match response == '#[]'
    And match response contains 'electronics'
    And match response contains 'jewelery'
    And match response contains "men's clothing"
    And match response contains "women's clothing"
    * print 'Categories:', response

  @regression @products @read
  Scenario: Get products in specific category
    Given path productsEndpoint, 'category', 'electronics'
    When method GET
    Then status 200
    And match response == '#[]'
    And match each response == { id: '#number', title: '#string', price: '#number', description: '#string', category: 'electronics', image: '#string', rating: '#object' }
    * print 'Electronics products:', response.length

  @smoke @regression @products @create
  Scenario: Create a new product successfully
    * def newProduct = TestDataFactory.createProduct()
    Given path productsEndpoint
    And request newProduct
    When method POST
    Then status 201
    And match response.id == '#number'
    And match response.title == newProduct.title
    And match response.price == newProduct.price
    * print 'Created product ID:', response.id

  @regression @products @create @negative
  Scenario: Create product with missing required fields
    * def incompleteProduct = TestDataFactory.createMinimalProduct()
    Given path productsEndpoint
    And request incompleteProduct
    When method POST
    Then status 201
    # Fake Store API doesn't strictly validate, but returns success

  @regression @products @update
  Scenario: Update product with PUT (full update)
    * def updatedProduct = TestDataFactory.createProduct()
    Given path productsEndpoint, 1
    And request updatedProduct
    When method PUT
    Then status 200
    And match response.id == 1
    And match response.title == updatedProduct.title
    And match response.price == updatedProduct.price
    * print 'Updated product:', response.title

  @regression @products @update
  Scenario: Partial update product with PATCH
    * def partialUpdate = { price: 199.99 }
    Given path productsEndpoint, 1
    And request partialUpdate
    When method PATCH
    Then status 200
    And match response.id == 1
    And match response.price == partialUpdate.price
    * print 'Partially updated product price:', response.price

  @regression @products @delete
  Scenario: Delete a product successfully
    Given path productsEndpoint, 6
    When method DELETE
    Then status 200
    And match response.id == '#present'
    * print 'Deleted product:', response

  @regression @products @delete @negative
  Scenario: Delete non-existent product
    Given path productsEndpoint, 99999
    When method DELETE
    Then status 200
    # Fake Store API doesn't return 404 for non-existent deletes

  @integration @products @workflow
  Scenario: End-to-end product workflow - Create, Read, Update, Delete
    # Step 1: Create a new product
    * def newProduct = TestDataFactory.createProduct()
    Given path productsEndpoint
    And request newProduct
    When method POST
    Then status 201
    * def productId = response.id
    * print 'Created product ID:', productId
    
    # Step 2: Read an existing product (Fake Store API doesn't persist created data)
    Given path productsEndpoint, 1
    When method GET
    Then status 200
    And match response.title == '#string'
    
    # Step 3: Update the product
    * def update = { price: 39.99 }
    Given path productsEndpoint, 1
    And request update
    When method PATCH
    Then status 200
    And match response.price == update.price
    
    # Step 4: Delete the product
    Given path productsEndpoint, 6
    When method DELETE
    Then status 200
    * print 'E2E workflow completed successfully'

  @regression @products @validation
  Scenario: Validate product response structure and data types
    Given path productsEndpoint, 1
    When method GET
    Then status 200
    And match response == 
    """
    {
      id: '#number',
      title: '#string',
      price: '#number',
      description: '#string',
      category: '#string',
      image: '#string',
      rating: {
        rate: '#number',
        count: '#number'
      }
    }
    """
    And assert response.price > 0
    And assert response.rating.rate >= 0 && response.rating.rate <= 5
    And assert response.rating.count >= 0
