package id.my.hendisantika.crudredis.config;

import id.my.hendisantika.crudredis.model.Product;
import id.my.hendisantika.crudredis.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

/**
 * Created by IntelliJ IDEA.
 * Project : spring-boot-crud-redis
 * User: hendisantika
 * Link: s.id/hendisantika
 * Email: hendisantika@yahoo.co.id
 * Telegram : @hendisantika34
 * Date: 19/10/25
 * Time: 11.30
 * To change this template use File | Settings | File Templates.
 */

/**
 * Data initializer to populate Redis with sample products
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final ProductService productService;

    @Override
    public void run(String... args) {
        log.info("Initializing sample products...");

        // Check if products already exist
        if (!productService.getAllProducts().isEmpty()) {
            log.info("Products already exist in database. Skipping initialization.");
            return;
        }

        // Create 10 dummy products
        createProduct("Apple MacBook Pro 16\"", "Powerful laptop with M3 Max chip, 36GB RAM, and 1TB SSD",
                "Electronics", new BigDecimal("2999.99"), 15);

        createProduct("Nike Air Jordan 1", "Classic basketball shoes with premium leather and iconic design",
                "Clothing", new BigDecimal("179.99"), 45);

        createProduct("Organic Green Tea", "Premium Japanese matcha green tea, 100g pack",
                "Food", new BigDecimal("24.99"), 120);

        createProduct("The Art of War - Sun Tzu", "Ancient Chinese military treatise and strategy guide",
                "Books", new BigDecimal("12.99"), 78);

        createProduct("LEGO Star Wars Millennium Falcon", "Ultimate collector's edition with 7,541 pieces",
                "Toys", new BigDecimal("849.99"), 8);

        createProduct("Wilson Tennis Racket Pro", "Professional-grade carbon fiber tennis racket",
                "Sports", new BigDecimal("249.99"), 22);

        createProduct("Dyson V15 Vacuum Cleaner", "Cordless stick vacuum with laser dust detection",
                "Home", new BigDecimal("649.99"), 12);

        createProduct("Samsung Galaxy S24 Ultra", "Flagship smartphone with 200MP camera and S Pen",
                "Electronics", new BigDecimal("1299.99"), 35);

        createProduct("Instant Pot Duo 7-in-1", "Multi-functional pressure cooker and air fryer combo",
                "Home", new BigDecimal("99.99"), 56);

        createProduct("Yoga Mat Premium", "Non-slip eco-friendly yoga mat with carrying strap",
                "Sports", new BigDecimal("39.99"), 89);

        log.info("Successfully initialized 10 sample products!");
    }

    private void createProduct(String name, String description, String category, BigDecimal price, Integer quantity) {
        Product product = new Product();
        product.setName(name);
        product.setDescription(description);
        product.setCategory(category);
        product.setPrice(price);
        product.setQuantity(quantity);

        Product saved = productService.saveProduct(product);
        log.info("Created product: {} (ID: {})", saved.getName(), saved.getId());
    }
}
