import psycopg2

def get_db_connection(DB_HOST : str, DB_PORT : str, DB_USER : str, DB_PASSWORD : str, DB_NAME : str) -> psycopg2.extensions.connection:
    conn = psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    return conn