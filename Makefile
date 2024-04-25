.PHONY: build-server stop-server rebuild-db

# Path to your server directory
SERVER_DIR = src/Server
APLLICATION_DIR = src/MobileApp/receipt_extraction_project/receipt_extractor

# Docker-compose service name for your database
DB_SERVICE_NAME = db

# Build the server
server-build:
	@(cd $(SERVER_DIR) && docker-compose build)

# Start the server
server-start:
	@(cd $(SERVER_DIR) && chmod +x update_ip.sh && ./update_ip.sh)
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

server-test:
	@docker exec -it server-app-1 pytest -v

application-test:
	@echo "Running tests for the application..."
	@(cd $(APLLICATION_DIR) && flutter test lib)

test:
	@echo "Running tests for the server..."
	@make server-test
	@echo "Running tests for the application..."
	@make application-test
	@echo "All tests passed!"
