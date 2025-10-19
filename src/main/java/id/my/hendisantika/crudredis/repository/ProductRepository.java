package id.my.hendisantika.crudredis.repository;

import id.my.hendisantika.crudredis.model.Product;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * Project : spring-boot-crud-redis
 * User: hendisantika
 * Link: s.id/hendisantika
 * Email: hendisantika@yahoo.co.id
 * Telegram : @hendisantika34
 * Date: 19/10/25
 * Time: 09.45
 * To change this template use File | Settings | File Templates.
 */

/**
 * Product repository for Redis operations
 */
@Repository
public interface ProductRepository extends CrudRepository<Product, String> {

    List<Product> findByNameContainingIgnoreCase(String name);

    List<Product> findByCategory(String category);
}
