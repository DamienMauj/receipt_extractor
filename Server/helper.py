import psycopg2
from psycopg2 import OperationalError 

def get_db_connection(DB_HOST : str, DB_PORT : str, DB_USER : str, DB_PASSWORD : str, DB_NAME : str) -> psycopg2.extensions.connection:
    try:
        conn = psycopg2.connect(
            host=DB_HOST,  # This is the hostname of the db service in docker-compose
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        print(f"Connection to PostgreSQL DB successful - {conn} ")
    except OperationalError as e:
        print(f"The error '{e}' occurred")
    return conn