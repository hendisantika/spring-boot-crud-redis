# Upstash Redis Cloud Setup Script (PowerShell)
# This script helps you configure application-dev.properties with Upstash credentials

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Upstash Redis Cloud Setup" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Please provide your Upstash Redis credentials:" -ForegroundColor Yellow
Write-Host "(You can find these at: https://console.upstash.com)" -ForegroundColor Yellow
Write-Host ""

# Read credentials
Write-Host "From Upstash console, copy the Jedis connection URI:" -ForegroundColor Yellow
Write-Host "Example: rediss://default:PASSWORD@ENDPOINT:6379" -ForegroundColor Yellow
Write-Host ""
$REDIS_HOST = Read-Host "Upstash Endpoint (e.g., your-instance-12345.upstash.io)"
$REDIS_PORT = Read-Host "Port (usually 6379)"
$REDIS_USERNAME = Read-Host "Username (usually 'default')"
$REDIS_PASSWORD = Read-Host "Password" -AsSecureString
$REDIS_PASSWORD_PLAIN = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($REDIS_PASSWORD)
)

Write-Host ""

# Set defaults
if ([string]::IsNullOrWhiteSpace($REDIS_USERNAME)) {
    $REDIS_USERNAME = "default"
}
if ([string]::IsNullOrWhiteSpace($REDIS_PORT)) {
    $REDIS_PORT = "6379"
}

# Validate inputs
if ([string]::IsNullOrWhiteSpace($REDIS_HOST) -or
    [string]::IsNullOrWhiteSpace($REDIS_PASSWORD_PLAIN)) {
    Write-Host "❌ Error: Host and Password are required!" -ForegroundColor Red
    exit 1
}

# Create application-dev.properties
$CONFIG_FILE = "src\main\resources\application-dev.properties"

$content = @"
spring.application.name=spring-boot-crud-redis

# Upstash Redis Cloud Configuration
# Connection URI: rediss://$REDIS_USERNAME`:$REDIS_PASSWORD_PLAIN@$REDIS_HOST`:$REDIS_PORT
spring.data.redis.host=$REDIS_HOST
spring.data.redis.port=$REDIS_PORT
spring.data.redis.username=$REDIS_USERNAME
spring.data.redis.password=$REDIS_PASSWORD_PLAIN
spring.data.redis.timeout=60000

# SSL/TLS Configuration for Upstash (rediss:// protocol)
spring.data.redis.ssl.enabled=true

# Thymeleaf Configuration
spring.thymeleaf.cache=false
spring.thymeleaf.enabled=true
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.suffix=.html

# Server Configuration
server.port=8080

# Logging
logging.level.root=INFO
logging.level.id.my.hendisantika.crudredis=DEBUG
"@

Set-Content -Path $CONFIG_FILE -Value $content

Write-Host "✅ Configuration created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 File: $CONFIG_FILE" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 To run with Upstash Redis, use:" -ForegroundColor Yellow
Write-Host "   .\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=dev" -ForegroundColor White
Write-Host "   or" -ForegroundColor Yellow
Write-Host "   mvn spring-boot:run -Dspring-boot.run.profiles=dev" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  Security Note:" -ForegroundColor Yellow
Write-Host "   Your credentials are now in $CONFIG_FILE" -ForegroundColor White
Write-Host "   If you commit this to Git, uncomment the line in .gitignore:" -ForegroundColor White
Write-Host "   # src/main/resources/application-dev.properties" -ForegroundColor White
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
