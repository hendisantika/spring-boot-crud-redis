package id.my.hendisantika.crudredis.repository;

import id.my.hendisantika.crudredis.model.Product;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

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
 * Note: Redis doesn't support complex query derivation like JPA.
 * For searching/filtering, use service layer with manual filtering.
 */
@Repository
public interface ProductRepository extends CrudRepository<Product, String> {
    // Basic CRUD operations only
    // Search functionality implemented in service layer
}
