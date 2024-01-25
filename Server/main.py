from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, EmailStr
from dotenv import load_dotenv
import os
import psycopg2
from psycopg2.extras import RealDictCursor
from helper import get_db_connection
import uuid


DB_HOST = os.getenv('DB_HOST')
DB_PORT = os.getenv('DB_PORT')
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_NAME = os.getenv('DB_NAME')
app = FastAPI()

@app.get("/hello")
async def hello_world():
    return {"message": "Hello, World!"}


# Define your data model as a Pydantic model
class User(BaseModel):
    email: EmailStr
    password: str


@app.post("/register/")
async def create_item(user: User):
    conn = get_db_connection(DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME)
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    user_id = uuid.uuid4()
    try:
        cursor.execute(
            "INSERT INTO User (User_id, email, password) VALUES (%s, %s, %s) RETURNING User_id;",
            (str(user_id), user.email, user.password)
        )
        user_id = cursor.fetchone()['id']
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        conn.close()