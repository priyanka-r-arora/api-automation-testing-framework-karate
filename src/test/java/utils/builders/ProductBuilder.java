package utils.builders;

import com.github.javafaker.Faker;
import utils.providers.FakerProvider;

import java.util.HashMap;
import java.util.Map;

/**
 * Builder class for generating realistic product test data.
 * Uses Builder pattern for flexible and readable test data creation.
 * 
 * @author Priyanka Arora
 */
public class ProductBuilder {
    
    private static final Faker faker = FakerProvider.getFaker();
    private static final String[] CATEGORIES = {"electronics", "jewelery", "men's clothing", "women's clothing"};
    
    private String title;
    private Double price;
    private String description;
    private String image;
    private String category;
    
    public ProductBuilder() {
        // Set default realistic values
        this.title = faker.commerce().productName();
        this.price = Double.parseDouble(faker.commerce().price(10.0, 500.0));
        this.description = faker.lorem().sentence(10);
        this.image = "https://i.pravatar.cc/" + faker.number().numberBetween(100, 999);
        this.category = CATEGORIES[faker.random().nextInt(CATEGORIES.length)];
    }
    
    public ProductBuilder withTitle(String title) {
        this.title = title;
        return this;
    }
    
    public ProductBuilder withPrice(Double price) {
        this.price = price;
        return this;
    }
    
    public ProductBuilder withDescription(String description) {
        this.description = description;
        return this;
    }
    
    public ProductBuilder withImage(String image) {
        this.image = image;
        return this;
    }
    
    public ProductBuilder withCategory(String category) {
        this.category = category;
        return this;
    }
    
    public ProductBuilder asElectronics() {
        this.category = "electronics";
        return this;
    }
    
    public ProductBuilder asJewelery() {
        this.category = "jewelery";
        return this;
    }
    
    public ProductBuilder asMensClothing() {
        this.category = "men's clothing";
        return this;
    }
    
    public ProductBuilder asWomensClothing() {
        this.category = "women's clothing";
        return this;
    }
    
    /**
     * Builds a complete product object as Map for Karate feature files.
     * 
     * @return Map containing product data in expected API format
     */
    public Map<String, Object> build() {
        Map<String, Object> product = new HashMap<>();
        product.put("title", title);
        product.put("price", price);
        product.put("description", description);
        product.put("image", image);
        product.put("category", category);
        return product;
    }
    
    /**
     * Builds a minimal product object with only title.
     * Useful for negative testing scenarios.
     * 
     * @return Map containing minimal product data
     */
    public Map<String, Object> buildMinimal() {
        Map<String, Object> product = new HashMap<>();
        product.put("title", title);
        return product;
    }
}
