# Spring Boot CRUD with Redis - Product Management System

A modern, full-featured product management web application built with Spring Boot, Redis, Thymeleaf, and SweetAlert2.
This application demonstrates how to implement CRUD operations using Redis as the primary data store with a beautiful,
responsive user interface.

## Features

- **Full CRUD Operations**: Create, Read, Update, and Delete products
- **Redis Integration**: Fast, in-memory data storage using Redis
- **Redis UI Management**: Includes RedisInsight and Redis Commander for visual data management
- **Search Functionality**: Search products by name with real-time filtering
- **Category Management**: Organize products by categories
- **Form Validation**: Client-side and server-side validation
- **SweetAlert2 Notifications**: Beautiful, responsive alerts and confirmations
- **Responsive UI**: Modern Bootstrap 5 interface with gradient design
- **Docker Support**: Easy Redis deployment using Docker Compose with UI tools
- **Stock Management**: Visual indicators for product quantity (In Stock, Low Stock, Out of Stock)

## Technologies Used

### Backend

- **Java 25**
- **Spring Boot 3.5.6**
    - Spring Boot Starter Web
    - Spring Boot Starter Data Redis
    - Spring Boot Starter Thymeleaf
    - Spring Boot Starter Validation
    - Spring Boot DevTools
    - Spring Boot Docker Compose Support
- **Redis 7 (Alpine)**
- **Jedis** - Redis Java Client
- **Lombok** - Reduce boilerplate code

### Frontend

- **Thymeleaf** - Server-side template engine
- **Bootstrap 5.3.0** - CSS Framework
- **Bootstrap Icons 1.11.1** - Icon library
- **SweetAlert2 11** - Beautiful alerts and modals
- **Custom CSS** - Gradient design and animations

### DevOps

- **Docker & Docker Compose** - Containerization
- **RedisInsight** - Official Redis GUI for data visualization and management
- **Redis Commander** - Lightweight web-based Redis management tool
- **Maven** - Build and dependency management

## Prerequisites

Before running this application, ensure you have the following installed:

- **Java Development Kit (JDK) 25** or higher
- **Maven 3.6+** or use the included Maven wrapper
- **Docker & Docker Compose** - For running Redis
- **Git** - For cloning the repository

## Project Structure

```
spring-boot-crud-redis/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── id/my/hendisantika/crudredis/
│   │   │       ├── config/
│   │   │       │   └── RedisConfig.java          # Redis configuration
│   │   │       ├── controller/
│   │   │       │   ├── HomeController.java       # Home page controller
│   │   │       │   └── ProductController.java    # Product CRUD controller
│   │   │       ├── model/
│   │   │       │   └── Product.java              # Product entity
│   │   │       ├── repository/
│   │   │       │   └── ProductRepository.java    # Redis repository
│   │   │       ├── service/
│   │   │       │   ├── ProductService.java       # Service interface
│   │   │       │   └── ProductServiceImpl.java   # Service implementation
│   │   │       └── SpringBootCrudRedisApplication.java
│   │   └── resources/
│   │       ├── templates/
│   │       │   ├── products/
│   │       │   │   ├── list.html                 # Products list page
│   │       │   │   ├── form.html                 # Create/Edit form
│   │       │   │   └── view.html                 # Product details page
│   │       │   └── layout.html                   # Base layout template
│   │       └── application.properties            # Application configuration
│   └── test/
│       └── java/
│           └── id/my/hendisantika/crudredis/
│               └── SpringBootCrudRedisApplicationTests.java
├── compose.yaml                                   # Docker Compose configuration
├── pom.xml                                        # Maven dependencies
└── README.md
```

## Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/hendisantika/spring-boot-crud-redis.git
cd spring-boot-crud-redis
```

### 2. Start Redis Containers

The application uses Docker Compose to run Redis along with management UI tools. Start all containers:

```bash
docker-compose up -d
```

This will start:

**Redis Server:**

- Image: Redis 7 Alpine
- Port: 6379
- Container: `spring-boot-redis`
- Features: AOF persistence enabled

**RedisInsight (Official Redis GUI):**

- Port: 5540
- Container: `spring-boot-redis-insight`
- Access: http://localhost:5540
- Features: Modern web-based Redis management interface with data visualization, query builder, and performance
  monitoring

**Redis Commander (Alternative Web UI):**

- Port: 8081
- Container: `spring-boot-redis-commander`
- Access: http://localhost:8081
- Features: Lightweight web-based Redis management tool

Verify all containers are running:

```bash
docker ps
```

You should see three containers: `spring-boot-redis`, `spring-boot-redis-insight`, and `spring-boot-redis-commander`
running.

### Accessing Redis UI Tools

**RedisInsight** (Recommended):

1. Open http://localhost:5540 in your browser
2. Click "Add Redis Database"
3. Enter:
    - Host: `redis`
    - Port: `6379`
    - Name: `Spring Boot Redis`
4. Click "Add Database"
5. You can now browse keys, run commands, and monitor performance

**Redis Commander**:

1. Open http://localhost:8081 in your browser
2. The connection is pre-configured
3. You can immediately browse and manage Redis data

### 3. Build the Application

Using Maven wrapper (recommended):

```bash
./mvnw clean install
```

Or using your local Maven installation:

```bash
mvn clean install
```

### 4. Run the Application

Using Maven wrapper:

```bash
./mvnw spring-boot:run
```

Or using your local Maven:

```bash
mvn spring-boot:run
```

Alternatively, run the JAR file directly:

```bash
java -jar target/crud-redis-0.0.1-SNAPSHOT.jar
```

### 5. Access the Application

Open your web browser and navigate to:

```
http://localhost:8080
```

You will be automatically redirected to the products list page.

## Configuration

### Application Properties

The application configuration is located in `src/main/resources/application.properties`:

```properties
spring.application.name=spring-boot-crud-redis
# Redis Configuration
spring.data.redis.host=localhost
spring.data.redis.port=6379
spring.data.redis.timeout=60000
# Thymeleaf Configuration
spring.thymeleaf.cache=false
spring.thymeleaf.enabled=true
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.suffix=.html
# Server Configuration
server.port=8080
```

### Customization Options

You can customize the following settings:

- **Redis Host**: Change `spring.data.redis.host` if Redis is running on a different host
- **Redis Port**: Modify `spring.data.redis.port` if using a different port
- **Server Port**: Change `server.port` to run the application on a different port
- **Template Caching**: Set `spring.thymeleaf.cache=true` in production for better performance

## Usage Guide

### 1. Viewing Products

The homepage displays all products in a table format with the following information:

- Product Name
- Description
- Category (with colored badges)
- Price (formatted as currency)
- Quantity (with stock level indicators)
- Action buttons (View, Edit, Delete)

### 2. Adding a New Product

1. Click the **"Add New Product"** button
2. Fill in the required fields:
    - **Product Name** (required)
    - **Description** (required)
    - **Category** (optional - select from dropdown)
    - **Price** (required - must be positive)
    - **Quantity** (required - must be positive integer)
3. Click **"Create Product"**
4. A success notification will appear

### 3. Editing a Product

1. Click the **Edit** button (pencil icon) on any product
2. Modify the desired fields
3. Click **"Update Product"**
4. A success notification will confirm the update

### 4. Viewing Product Details

1. Click the **View** button (eye icon) on any product
2. View comprehensive product information including:
    - Product ID
    - All product details
    - Stock status indicators
    - Quick access to Edit and Delete actions

### 5. Deleting a Product

1. Click the **Delete** button (trash icon) on any product
2. Confirm the deletion in the SweetAlert2 modal
3. The product will be removed from Redis
4. A success notification will appear

### 6. Searching Products

1. Use the search box at the top of the products list
2. Enter a product name (search is case-insensitive)
3. Click **"Search"**
4. Results will be filtered in real-time
5. Click **"Clear"** to reset the search

## Product Data Model

Each product in the system contains the following fields:

| Field       | Type       | Required | Validation            |
|-------------|------------|----------|-----------------------|
| id          | String     | Auto     | Auto-generated UUID   |
| name        | String     | Yes      | Not blank             |
| description | String     | Yes      | Not blank             |
| price       | BigDecimal | Yes      | Must be positive      |
| quantity    | Integer    | Yes      | Must be positive      |
| category    | String     | No       | Predefined categories |

### Available Categories

- Electronics
- Clothing
- Food
- Books
- Toys
- Sports
- Home
- Other

## Redis Data Structure

The application uses Spring Data Redis with the following configuration:

- **Key Pattern**: `Product:{id}`
- **Serialization**:
    - Keys: StringRedisSerializer
    - Values: GenericJackson2JsonRedisSerializer
- **Data Type**: Redis Hash
- **Persistence**: AOF (Append-Only File) enabled

### Sample Redis Entry

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Laptop",
  "description": "High-performance laptop for developers",
  "price": 1299.99,
  "quantity": 15,
  "category": "Electronics"
}
```

## API Endpoints (Web Routes)

| Method | Endpoint              | Description               |
|--------|-----------------------|---------------------------|
| GET    | /                     | Redirect to products list |
| GET    | /products             | Display all products      |
| GET    | /products?search=name | Search products by name   |
| GET    | /products/new         | Show create product form  |
| GET    | /products/edit/{id}   | Show edit product form    |
| GET    | /products/view/{id}   | View product details      |
| POST   | /products/save        | Create or update product  |
| GET    | /products/delete/{id} | Delete product by ID      |

## UI Features

### Design Highlights

- **Gradient Background**: Modern purple gradient background
- **Card-Based Layout**: Clean, organized card components
- **Responsive Design**: Works on desktop, tablet, and mobile
- **Icon Integration**: Bootstrap Icons for visual clarity
- **Color Coding**:
    - Green badges for high stock (> 10 units)
    - Yellow badges for low stock (1-10 units)
    - Red badges for out of stock (0 units)

### SweetAlert2 Integrations

The application uses SweetAlert2 for:

- **Success Notifications**: Toast notifications for successful operations
- **Error Alerts**: Modal alerts for errors
- **Delete Confirmations**: Beautiful confirmation dialogs
- **Form Validation**: Visual feedback for validation errors

## Development

### Running in Development Mode

The application includes Spring Boot DevTools for automatic restart and live reload:

```bash
./mvnw spring-boot:run
```

Any changes to Java files or templates will automatically trigger a restart.

### Debugging

To run with debug enabled:

```bash
./mvnw spring-boot:run -Dspring-boot.run.arguments=--debug
```

Or set in `application.properties`:

```properties
logging.level.root=DEBUG
logging.level.id.my.hendisantika.crudredis=DEBUG
```

## Docker Commands

### Start All Containers (Redis + UI Tools)

```bash
docker-compose up -d
```

### Stop All Containers

```bash
docker-compose down
```

### Start/Stop Individual Services

Start only Redis:

```bash
docker-compose up -d redis
```

Start only RedisInsight:

```bash
docker-compose up -d redis-insight
```

Start only Redis Commander:

```bash
docker-compose up -d redis-commander
```

### View Logs

View Redis logs:
```bash
docker-compose logs -f redis
```

View RedisInsight logs:

```bash
docker-compose logs -f redis-insight
```

View Redis Commander logs:

```bash
docker-compose logs -f redis-commander
```

View all logs:

```bash
docker-compose logs -f
```

### Connect to Redis CLI

```bash
docker exec -it spring-boot-redis redis-cli
```

### Restart Services

Restart all services:

```bash
docker-compose restart
```

Restart only Redis:

```bash
docker-compose restart redis
```

### Common Redis CLI Commands

```bash
# List all keys
KEYS *

# Get all product keys
KEYS Product:*

# View a specific product
HGETALL Product:{id}

# Count total products
DBSIZE

# Clear all data (use with caution!)
FLUSHALL
```

## Testing

Run the test suite:

```bash
./mvnw test
```

## Building for Production

### Create Production JAR

```bash
./mvnw clean package -DskipTests
```

The JAR file will be created in `target/crud-redis-0.0.1-SNAPSHOT.jar`

### Production Configuration

For production, update `application.properties`:

```properties
# Enable template caching
spring.thymeleaf.cache=true
# Set production Redis host
spring.data.redis.host=your-production-redis-host
# Set production port if needed
server.port=8080
# Enable production logging
logging.level.root=INFO
logging.level.id.my.hendisantika.crudredis=INFO
```

## Troubleshooting

### Common Issues

**1. Redis Connection Failed**

```
Error: Could not connect to Redis at localhost:6379
```

**Solution**: Ensure Redis container is running:

```bash
docker-compose up -d
docker ps
```

**2. Port 8080 Already in Use**

```
Error: Port 8080 is already in use
```

**Solution**: Either stop the service using port 8080 or change the port in `application.properties`:

```properties
server.port=8081
```

**3. Template Not Found**

```
Error: Error resolving template "products/list"
```

**Solution**: Ensure all templates are in `src/main/resources/templates/` directory

**4. Redis Data Persistence Issues**

**Solution**: Check Docker volume:

```bash
docker volume ls
docker volume inspect spring-boot-crud-redis_redis-data
```

## Performance Considerations

- **Redis In-Memory Storage**: Extremely fast read/write operations
- **Connection Pooling**: Jedis connection factory manages connections efficiently
- **Template Caching**: Enable in production for better performance
- **AOF Persistence**: Data is persisted to disk for durability
- **DevTools**: Disable in production builds

## Security Considerations

For production deployments, consider:

1. **Redis Password**: Add password authentication to Redis
2. **HTTPS**: Use SSL/TLS for secure communication
3. **Input Validation**: Already implemented with Jakarta Validation
4. **CSRF Protection**: Consider adding CSRF tokens
5. **Rate Limiting**: Implement request rate limiting
6. **Network Security**: Run Redis in a private network

## Future Enhancements

Potential improvements for this application:

- [ ] Pagination for large product lists
- [ ] Product image upload
- [ ] Advanced filtering (by price range, category)
- [ ] Export products to CSV/Excel
- [ ] User authentication and authorization
- [ ] Product reviews and ratings
- [ ] Inventory alerts for low stock
- [ ] REST API endpoints for mobile apps
- [ ] Unit and integration tests
- [ ] Elasticsearch integration for advanced search
- [ ] Redis caching strategies
- [ ] Multi-language support (i18n)

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

**Hendi Santika**

- GitHub: [@hendisantika](https://github.com/hendisantika)

## Acknowledgments

- Spring Boot Team for the excellent framework
- Redis Team for the fast in-memory database
- Bootstrap Team for the responsive CSS framework
- SweetAlert2 for beautiful alerts and modals

## Support

If you find this project helpful, please give it a star on GitHub!

For issues, questions, or suggestions, please open an issue on the GitHub repository.

---

**Happy Coding!** 🚀
