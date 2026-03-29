package utils.providers;

import com.github.javafaker.Faker;
import java.util.Locale;

/**
 * Centralized provider for Faker instance with Dutch locale.
 * Implements singleton pattern to ensure thread-safety and consistent data generation.
 * 
 * @author Priyanka Arora
 */
public class FakerProvider {
    
    private static final Faker FAKER_INSTANCE = new Faker(new Locale("nl"));
    
    private FakerProvider() {
        // Private constructor to prevent instantiation
    }
    
    /**
     * Gets the singleton Faker instance with Dutch locale.
     * Thread-safe and optimized for test data generation.
     * 
     * @return Faker instance configured with Dutch locale
     */
    public static Faker getFaker() {
        return FAKER_INSTANCE;
    }
    
    /**
     * Gets a Faker instance with custom locale.
     * Useful for testing multi-region scenarios.
     * 
     * @param locale Locale for data generation
     * @return Faker instance with specified locale
     */
    public static Faker getFaker(Locale locale) {
        return new Faker(locale);
    }
}
