# Use the official Vault image as the base
FROM hashicorp/vault:latest

# Set the working directory
WORKDIR /app

# Copy the startup script into the container
COPY vault-startup.sh /app/vault-startup.sh

# Make the script executable
RUN chmod +x /app/vault-startup.sh

# Expose the default Vault port
EXPOSE 8200

# Run the script when the container starts
CMD ["/bin/bash", "/app/vault-startup.sh"]
