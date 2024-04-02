#!/bin/bash

# Wait for the database to be up
# echo "Waiting for database to be ready..."
# while ! nc -z $DB_HOST $DB_PORT; do
#   sleep 1
# done
# echo "Database is up and running."

# Run unit tests
echo "Running unit tests..."
# Replace this with your command to run tests, for example:
python -m unittest discover .
# npm test
# Ensure the command provides a non-zero exit status if tests fail

if [ $? -ne 0 ]; then
    echo "Unit tests failed."
    exit 1
fi

echo "Unit tests passed."

# Start your application
echo "Starting application..."
# Replace this with the command to start your application, for example:
# python app.py
# npm start
# java -jar your-app.jar
