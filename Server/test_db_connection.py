# test_db_connection.py

import psycopg2
from psycopg2 import OperationalError

def create_connection():
    try:
        conn = psycopg2.connect(
            host="db",  # This is the hostname of the db service in docker-compose
            database="receipt_extraction",
            user="user",
            password="password"
        )
        print(f"Connection to PostgreSQL DB successful - {conn} ")
    except OperationalError as e:
        print(f"The error '{e}' occurred")
    return conn

create_connection()
