.PHONY: build-server stop-server rebuild-db

# Path to your server directory
SERVER_DIR = Server

# Docker-compose service name for your database
DB_SERVICE_NAME = db

# Build the server
server-build:
	@(cd $(SERVER_DIR) && docker-compose build)

# Start the server
server-start:
	@(cd $(SERVER_DIR) && docker-compose up)

# Stop the server
server-stop:
	@(cd $(SERVER_DIR) && docker-compose down)

# Rebuild the database completely
rebuild-db:
	@echo "Stopping services..."
	@(cd $(SERVER_DIR) && docker-compose down)
	@echo "Removing existing data directory..."
	@rm -rf $(SERVER_DIR)/data
	@echo "Starting services..."
	@(cd $(SERVER_DIR) && docker-compose up)