#!/bin/bash

# Define Vault environment variables
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_DEV_ROOT_TOKEN_ID="root"

# Function to start Vault
start_vault() {
  echo "Starting Vault in dev mode..."
  vault server -dev -dev-root-token-id="$VAULT_DEV_ROOT_TOKEN_ID" -dev-listen-address="0.0.0.0:8200" &
  VAULT_PID=$!

  # Wait for Vault to start and become unsealed
  echo "Waiting for Vault to start..."
  while ! vault status; do
    echo "Vault is not ready yet. Waiting..."
    sleep 2
  done
}

# Function to add application config to Vault
add_config_to_vault() {
  echo "Adding application configurations to Vault..."

  # Login to Vault using root token
  vault login "$VAULT_DEV_ROOT_TOKEN_ID" || { echo "Vault login failed"; exit 1; }

  # Add details-service configuration
  vault kv put secret/details-service \
    server.port=0 \
    eureka.client.serviceUrl.defaultZone="http://discovery-service:8761/eureka/" \
    spring.flyway.enabled=true \
    spring.flyway.locations=classpath:db/migration \
    spring.datasource.url="jdbc:postgresql://details-service-postgres:5433/details-service" \
    spring.datasource.username="postgres" \
    spring.datasource.password="12345" \
    spring.datasource.driver-class-name=org.postgresql.Driver \
    spring.jpa.hibernate.ddl-auto=validate \
    spring.jpa.show-sql=true \
    spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect

  # Add auth-service configuration
  vault kv put secret/auth-service \
    server.port=0 \
    eureka.client.serviceUrl.defaultZone="http://discovery-service:8761/eureka/" \
    spring.flyway.enabled=true \
    spring.flyway.locations=classpath:db/migration \
    spring.datasource.url="jdbc:postgresql://auth-service-postgres:5432/auth-service" \
    spring.datasource.username="postgres" \
    spring.datasource.password="12345" \
    spring.datasource.driver-class-name=org.postgresql.Driver \
    spring.jpa.hibernate.ddl-auto=validate \
    spring.jpa.show-sql=true \
    spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect

  # Add discovery-service configuration
  vault kv put secret/discovery-service \
    eureka.instance.hostname="localhost" \
    eureka.client.registerWithEureka=false \
    eureka.client.fetchRegistry=false \
    eureka.client.serviceUrl.defaultZone="http://\${eureka.instance.hostname}:\${server.port}/eureka/"

  # Add gateway configuration
 vault kv put secret/gateway \
     eureka.client.serviceUrl.defaultZone="http://discovery-service:8761/eureka/" \
     logging.level.org.springframework.cloud.gateway=DEBUG \
     logging.level.org.springframework.cloud.client.discovery=DEBUG \
     spring.cloud.gateway.globalcors.cors-configurations.\[\/\*\*\].allowedOrigins="http://localhost:4200" \
     spring.cloud.gateway.globalcors.cors-configurations.\[\/\*\*\].allowedMethods="GET, POST, PUT, DELETE, OPTIONS, PATCH" \
     spring.cloud.gateway.globalcors.cors-configurations.\[\/\*\*\].allowedHeaders="*" \
     spring.cloud.gateway.globalcors.cors-configurations.\[\/\*\*\].allowCredentials=true

}

# Ensure Vault binary is installed
if ! command -v vault &> /dev/null; then
  echo "Vault is not installed. Please install it first."
  exit 1
fi

# Start Vault
start_vault

# Add configurations to Vault
add_config_to_vault

echo "Vault is running with PID $VAULT_PID"
echo "Configuration added to Vault under:"
echo "- secret/details-service"
echo "- secret/auth-service"
echo "- secret/discovery-service"
echo "- secret/gateway"

tail -f /dev/null