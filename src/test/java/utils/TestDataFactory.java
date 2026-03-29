package utils;

import utils.builders.CartBuilder;
import utils.builders.ProductBuilder;
import utils.builders.UserBuilder;

import java.util.Map;

/**
 * Central factory for generating test data across all feature files.
 * Provides simple static methods for creating users, products, and carts with realistic data.
 * 
 * This class serves as the main entry point for test data generation in Karate feature files.
 * All data is generated using JavaFaker with Dutch locale for realistic Netherlands data.
 * 
 * Usage in Karate features:
 * <pre>
 * * def newUser = TestDataFactory.createUser()
 * * def newProduct = TestDataFactory.createProduct()
 * * def newCart = TestDataFactory.createCart()
 * </pre>
 * 
 * @author Priyanka Arora
 */
public class TestDataFactory {
    
    // ========== User Data Generation ==========
    
    /**
     * Creates a complete user object with all required fields.
     * Generates realistic Dutch data including addresses and phone numbers.
     * 
     * @return Map containing complete user data
     */
    public static Map<String, Object> createUser() {
        return new UserBuilder().build();
    }
    
    /**
     * Creates a minimal user object with only username and email.
     * Useful for negative testing scenarios.
     * 
     * @return Map containing minimal user data
     */
    public static Map<String, Object> createMinimalUser() {
        return new UserBuilder().buildMinimal();
    }
    
    /**
     * Creates a user with invalid email format.
     * Useful for email validation negative tests.
     * 
     * @return Map containing user data with invalid email
     */
    public static Map<String, Object> createUserWithInvalidEmail() {
        return new UserBuilder().withInvalidEmail().build();
    }
    
    /**
     * Creates a user with custom email.
     * 
     * @param email Custom email address
     * @return Map containing user data with specified email
     */
    public static Map<String, Object> createUserWithEmail(String email) {
        return new UserBuilder().withEmail(email).build();
    }
    
    /**
     * Gets a new UserBuilder for custom user creation.
     * Provides full control over user data generation.
     * 
     * @return UserBuilder instance
     */
    public static UserBuilder userBuilder() {
        return new UserBuilder();
    }
    
    // ========== Product Data Generation ==========
    
    /**
     * Creates a complete product object with all required fields.
     * Generates realistic product data including title, price, description, and category.
     * 
     * @return Map containing complete product data
     */
    public static Map<String, Object> createProduct() {
        return new ProductBuilder().build();
    }
    
    /**
     * Creates a minimal product object with only title.
     * Useful for negative testing scenarios.
     * 
     * @return Map containing minimal product data
     */
    public static Map<String, Object> createMinimalProduct() {
        return new ProductBuilder().buildMinimal();
    }
    
    /**
     * Creates an electronics product.
     * 
     * @return Map containing electronics product data
     */
    public static Map<String, Object> createElectronicsProduct() {
        return new ProductBuilder().asElectronics().build();
    }
    
    /**
     * Creates a jewelery product.
     * 
     * @return Map containing jewelery product data
     */
    public static Map<String, Object> createJeweleryProduct() {
        return new ProductBuilder().asJewelery().build();
    }
    
    /**
     * Creates a men's clothing product.
     * 
     * @return Map containing men's clothing product data
     */
    public static Map<String, Object> createMensClothingProduct() {
        return new ProductBuilder().asMensClothing().build();
    }
    
    /**
     * Creates a women's clothing product.
     * 
     * @return Map containing women's clothing product data
     */
    public static Map<String, Object> createWomensClothingProduct() {
        return new ProductBuilder().asWomensClothing().build();
    }
    
    /**
     * Gets a new ProductBuilder for custom product creation.
     * Provides full control over product data generation.
     * 
     * @return ProductBuilder instance
     */
    public static ProductBuilder productBuilder() {
        return new ProductBuilder();
    }
    
    // ========== Cart Data Generation ==========
    
    /**
     * Creates a complete cart object with random products.
     * Generates cart with 1-3 random products by default.
     * 
     * @return Map containing complete cart data
     */
    public static Map<String, Object> createCart() {
        return new CartBuilder().build();
    }
    
    /**
     * Creates a cart for specific user.
     * 
     * @param userId User ID for the cart
     * @return Map containing cart data for specified user
     */
    public static Map<String, Object> createCartForUser(int userId) {
        return new CartBuilder().withUserId(userId).build();
    }
    
    /**
     * Creates a cart with specified number of products.
     * 
     * @param productCount Number of products to include in cart
     * @return Map containing cart data with specified product count
     */
    public static Map<String, Object> createCartWithProducts(int productCount) {
        return new CartBuilder().buildWithProducts(productCount);
    }
    
    /**
     * Creates a cart for specific user with specified number of products.
     * 
     * @param userId User ID for the cart
     * @param productCount Number of products to include
     * @return Map containing cart data
     */
    public static Map<String, Object> createCartForUserWithProducts(int userId, int productCount) {
        return new CartBuilder()
                .withUserId(userId)
                .buildWithProducts(productCount);
    }
    
    /**
     * Gets a new CartBuilder for custom cart creation.
     * Provides full control over cart data generation.
     * 
     * @return CartBuilder instance
     */
    public static CartBuilder cartBuilder() {
        return new CartBuilder();
    }
}
