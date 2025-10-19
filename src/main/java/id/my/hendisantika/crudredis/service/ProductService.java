package id.my.hendisantika.crudredis.service;

import id.my.hendisantika.crudredis.model.Product;

import java.util.List;
import java.util.Optional;

/**
 * Created by IntelliJ IDEA.
 * Project : spring-boot-crud-redis
 * User: hendisantika
 * Link: s.id/hendisantika
 * Email: hendisantika@yahoo.co.id
 * Telegram : @hendisantika34
 * Date: 19/10/25
 * Time: 10.00
 * To change this template use File | Settings | File Templates.
 */

/**
 * Product service interface
 */
public interface ProductService {

    List<Product> getAllProducts();

    Optional<Product> getProductById(String id);

    Product saveProduct(Product product);

    void deleteProduct(String id);

    List<Product> searchProductsByName(String name);

    List<Product> getProductsByCategory(String category);

    boolean existsById(String id);
}
