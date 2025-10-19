package id.my.hendisantika.crudredis.service;

import id.my.hendisantika.crudredis.model.Product;
import id.my.hendisantika.crudredis.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

/**
 * Created by IntelliJ IDEA.
 * Project : spring-boot-crud-redis
 * User: hendisantika
 * Link: s.id/hendisantika
 * Email: hendisantika@yahoo.co.id
 * Telegram : @hendisantika34
 * Date: 19/10/25
 * Time: 10.15
 * To change this template use File | Settings | File Templates.
 */

/**
 * Product service implementation
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;

    @Override
    public List<Product> getAllProducts() {
        log.info("Fetching all products");
        List<Product> products = new ArrayList<>();
        productRepository.findAll().forEach(products::add);
        return products;
    }

    @Override
    public Optional<Product> getProductById(String id) {
        log.info("Fetching product with id: {}", id);
        return productRepository.findById(id);
    }

    @Override
    public Product saveProduct(Product product) {
        if (product.getId() == null || product.getId().isEmpty()) {
            product.setId(UUID.randomUUID().toString());
            log.info("Creating new product with id: {}", product.getId());
        } else {
            log.info("Updating product with id: {}", product.getId());
        }
        return productRepository.save(product);
    }

    @Override
    public void deleteProduct(String id) {
        log.info("Deleting product with id: {}", id);
        productRepository.deleteById(id);
    }

    @Override
    public List<Product> searchProductsByName(String name) {
        log.info("Searching products by name: {}", name);
        if (name == null || name.trim().isEmpty()) {
            return getAllProducts();
        }

        // Redis doesn't support CONTAINING queries, so we filter in-memory
        String searchTerm = name.toLowerCase().trim();
        return StreamSupport.stream(productRepository.findAll().spliterator(), false)
                .filter(product -> product.getName().toLowerCase().contains(searchTerm))
                .collect(Collectors.toList());
    }

    @Override
    public List<Product> getProductsByCategory(String category) {
        log.info("Fetching products by category: {}", category);
        if (category == null || category.trim().isEmpty()) {
            return getAllProducts();
        }

        // Filter products by category in-memory
        return StreamSupport.stream(productRepository.findAll().spliterator(), false)
                .filter(product -> category.equalsIgnoreCase(product.getCategory()))
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsById(String id) {
        return productRepository.existsById(id);
    }
}
