package utils.builders;

import com.github.javafaker.Faker;
import utils.providers.FakerProvider;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Builder class for generating realistic cart test data.
 * Uses Builder pattern for flexible and readable test data creation.
 * 
 * @author Priyanka Arora
 */
public class CartBuilder {
    
    private static final Faker faker = FakerProvider.getFaker();
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    private Integer userId;
    private String date;
    private List<Map<String, Integer>> products;
    
    public CartBuilder() {
        // Set default realistic values
        this.userId = faker.number().numberBetween(1, 10);
        this.date = LocalDate.now().format(DATE_FORMATTER);
        this.products = new ArrayList<>();
        // Add 1-3 random products by default
        int productCount = faker.number().numberBetween(1, 4);
        for (int i = 0; i < productCount; i++) {
            addRandomProduct();
        }
    }
    
    public CartBuilder withUserId(Integer userId) {
        this.userId = userId;
        return this;
    }
    
    public CartBuilder withDate(String date) {
        this.date = date;
        return this;
    }
    
    public CartBuilder withCurrentDate() {
        this.date = LocalDate.now().format(DATE_FORMATTER);
        return this;
    }
    
    public CartBuilder withFutureDate(int days) {
        this.date = LocalDate.now().plusDays(days).format(DATE_FORMATTER);
        return this;
    }
    
    public CartBuilder withPastDate(int days) {
        this.date = LocalDate.now().minusDays(days).format(DATE_FORMATTER);
        return this;
    }
    
    public CartBuilder withProducts(List<Map<String, Integer>> products) {
        this.products = products;
        return this;
    }
    
    public CartBuilder clearProducts() {
        this.products.clear();
        return this;
    }
    
    public CartBuilder addProduct(Integer productId, Integer quantity) {
        Map<String, Integer> product = new HashMap<>();
        product.put("productId", productId);
        product.put("quantity", quantity);
        this.products.add(product);
        return this;
    }
    
    public CartBuilder addRandomProduct() {
        int productId = faker.number().numberBetween(1, 20);
        int quantity = faker.number().numberBetween(1, 5);
        return addProduct(productId, quantity);
    }
    
    public CartBuilder withMultipleProducts(int count) {
        this.products.clear();
        for (int i = 0; i < count; i++) {
            addRandomProduct();
        }
        return this;
    }
    
    /**
     * Builds a complete cart object as Map for Karate feature files.
     * 
     * @return Map containing cart data in expected API format
     */
    public Map<String, Object> build() {
        Map<String, Object> cart = new HashMap<>();
        cart.put("userId", userId);
        cart.put("date", date);
        cart.put("products", products);
        return cart;
    }
    
    /**
     * Builds a cart object with specified number of products.
     * Convenient method for quick cart creation.
     * 
     * @param productCount Number of products to include
     * @return Map containing cart data
     */
    public Map<String, Object> buildWithProducts(int productCount) {
        return this.clearProducts().withMultipleProducts(productCount).build();
    }
}
