package utils.builders;

import com.github.javafaker.Faker;
import utils.providers.FakerProvider;

import java.util.HashMap;
import java.util.Map;

/**
 * Builder class for generating realistic user test data with Dutch locale.
 * Uses Builder pattern for flexible and readable test data creation.
 * 
 * @author Priyanka Arora
 */
public class UserBuilder {
    
    private static final Faker faker = FakerProvider.getFaker();
    
    private String email;
    private String username;
    private String password;
    private String firstname;
    private String lastname;
    private String city;
    private String street;
    private Integer number;
    private String zipcode;
    private String latitude;
    private String longitude;
    private String phone;
    
    public UserBuilder() {
        // Set default realistic values
        this.email = faker.internet().emailAddress();
        this.username = faker.name().username();
        this.password = "Test@" + faker.number().digits(4);
        this.firstname = faker.name().firstName();
        this.lastname = faker.name().lastName();
        this.city = faker.address().city();
        this.street = faker.address().streetName();
        this.number = faker.number().numberBetween(1, 999);
        this.zipcode = faker.address().zipCode();
        // Netherlands coordinates (approximately)
        this.latitude = String.format("%.4f", 52.0 + Math.random() * 1.5);
        this.longitude = String.format("%.4f", 4.0 + Math.random() * 3.0);
        this.phone = faker.phoneNumber().cellPhone();
    }
    
    public UserBuilder withEmail(String email) {
        this.email = email;
        return this;
    }
    
    public UserBuilder withUsername(String username) {
        this.username = username;
        return this;
    }
    
    public UserBuilder withPassword(String password) {
        this.password = password;
        return this;
    }
    
    public UserBuilder withName(String firstname, String lastname) {
        this.firstname = firstname;
        this.lastname = lastname;
        return this;
    }
    
    public UserBuilder withAddress(String city, String street, Integer number, String zipcode) {
        this.city = city;
        this.street = street;
        this.number = number;
        this.zipcode = zipcode;
        return this;
    }
    
    public UserBuilder withPhone(String phone) {
        this.phone = phone;
        return this;
    }
    
    public UserBuilder withInvalidEmail() {
        this.email = "invalid-email-format";
        return this;
    }
    
    /**
     * Builds a complete user object as Map for Karate feature files.
     * 
     * @return Map containing user data in expected API format
     */
    public Map<String, Object> build() {
        Map<String, Object> user = new HashMap<>();
        user.put("email", email);
        user.put("username", username);
        user.put("password", password);
        
        Map<String, String> name = new HashMap<>();
        name.put("firstname", firstname);
        name.put("lastname", lastname);
        user.put("name", name);
        
        Map<String, Object> address = new HashMap<>();
        address.put("city", city);
        address.put("street", street);
        address.put("number", number);
        address.put("zipcode", zipcode);
        
        Map<String, String> geolocation = new HashMap<>();
        geolocation.put("lat", latitude);
        geolocation.put("long", longitude);
        address.put("geolocation", geolocation);
        
        user.put("address", address);
        user.put("phone", phone);
        
        return user;
    }
    
    /**
     * Builds a minimal user object with only required fields.
     * Useful for negative testing scenarios.
     * 
     * @return Map containing minimal user data
     */
    public Map<String, Object> buildMinimal() {
        Map<String, Object> user = new HashMap<>();
        user.put("email", email);
        user.put("username", username);
        return user;
    }
}
