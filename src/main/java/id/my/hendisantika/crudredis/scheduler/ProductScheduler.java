package id.my.hendisantika.crudredis.scheduler;

import id.my.hendisantika.crudredis.model.Product;
import id.my.hendisantika.crudredis.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Random;
import java.util.UUID;

/**
 * Created by IntelliJ IDEA.
 * Project : spring-boot-crud-redis
 * User: hendisantika
 * Link: s.id/hendisantika
 * Email: hendisantika@yahoo.co.id
 * Telegram : @hendisantika34
 * Date: 20/10/25
 * Time: 18.00
 * To change this template use File | Settings | File Templates.
 */

/**
 * Scheduler to automatically create products in Redis every 5 seconds
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class ProductScheduler {

    private final ProductRepository productRepository;
    private final Random random = new Random();

    private static final String[] PRODUCT_NAMES = {
            "Laptop", "Smartphone", "Tablet", "Headphones", "Smartwatch",
            "Camera", "Monitor", "Keyboard", "Mouse", "Speaker",
            "Router", "Hard Drive", "SSD", "RAM", "Graphics Card"
    };

    private static final String[] CATEGORIES = {
            "Electronics", "Computers", "Accessories", "Audio", "Storage",
            "Networking", "Peripherals", "Gaming"
    };

    /**
     * Scheduled task that runs every 5 seconds (5000 milliseconds)
     * Creates a new random product and saves it to Redis
     */
    @Scheduled(fixedRate = 5000)
    public void createProductAutomatically() {
        try {
            // Generate random product data
            String productName = PRODUCT_NAMES[random.nextInt(PRODUCT_NAMES.length)];
            String category = CATEGORIES[random.nextInt(CATEGORIES.length)];
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

            Product product = new Product();
            product.setId(UUID.randomUUID().toString());
            product.setName(productName + " - " + timestamp);
            product.setDescription("Auto-generated " + productName + " created at " + timestamp);
            product.setPrice(BigDecimal.valueOf(100 + random.nextInt(9900)).add(BigDecimal.valueOf(random.nextInt(100), 2)));
            product.setQuantity(1 + random.nextInt(100));
            product.setCategory(category);

            // Save to Redis
            Product savedProduct = productRepository.save(product);

            // Log success
            log.info("✓ Auto-created product: {} (ID: {}, Price: ${}, Qty: {}, Category: {})",
                    savedProduct.getName(),
                    savedProduct.getId(),
                    savedProduct.getPrice(),
                    savedProduct.getQuantity(),
                    savedProduct.getCategory());

            // Log total count
            long totalProducts = productRepository.count();
            log.info("Total products in Redis: {}", totalProducts);

        } catch (Exception e) {
            log.error("Failed to auto-create product: {}", e.getMessage(), e);
        }
    }

    /**
     * Optional: Clean up old products every minute to prevent Redis from growing indefinitely
     * Uncomment if you want to limit the number of products
     */
    /*
    @Scheduled(fixedRate = 60000) // Every 60 seconds
    public void cleanupOldProducts() {
        try {
            long totalProducts = productRepository.count();

            // Keep only the latest 100 products
            if (totalProducts > 100) {
                List<Product> allProducts = new ArrayList<>();
                productRepository.findAll().forEach(allProducts::add);

                // Sort by name (which includes timestamp) and delete oldest
                allProducts.sort(Comparator.comparing(Product::getName));

                int toDelete = (int) (totalProducts - 100);
                for (int i = 0; i < toDelete; i++) {
                    productRepository.delete(allProducts.get(i));
                }

                log.info("Cleaned up {} old products. Current count: {}", toDelete, productRepository.count());
            }
        } catch (Exception e) {
            log.error("Failed to cleanup old products: {}", e.getMessage(), e);
        }
    }
    */
}
