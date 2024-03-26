from fastapi import FastAPI, HTTPException, UploadFile, File
from pydantic import BaseModel, EmailStr
from dotenv import load_dotenv
import os
import psycopg2
from psycopg2.extras import RealDictCursor
from helper import get_db_connection
import uuid
import logging
import numpy
import cv2
import pytesseract
from ultralytics import YOLO
from model.functions.extract_receipt import extract_receipt

log = logging.getLogger("uvicorn")

load_dotenv()

model = YOLO("model/versions/0.1/receipt_extractor.pt")
log.info("INFO: model loaded")

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
    try:
        conn = get_db_connection(DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        user_id = uuid.uuid4()
        print("executing query")
        insert_query = "INSERT INTO \"Users\" (user_id, email, password) VALUES (%s, %s, %s)"
        data_to_insert = (str(user_id), user.email, user.password)

        # Execute the query
        cursor.execute(insert_query, data_to_insert)
        print("executed query")
        
        # return_data = cursor.fetchall()
        print(f"return_data: {user_id}")
        conn.commit()
        cursor.close()
        conn.close()
        return {"user_id": user_id}
    except Exception as e:
        conn.rollback()
        print(f"Exception: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        conn.close()


@app.post("/users/")
async def get_user(kwargs: dict):

    try:
        print(f"kwargs: {kwargs}")
        conn = get_db_connection(DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        user_id = kwargs.get("user_id")
        print(f"fetching for  {user_id}")
        select_query = "SELECT * FROM \"Users\" WHERE user_id = %s"
        data_to_select = (user_id,)

        # Execute the query
        cursor.execute(select_query, data_to_select)
        print("executed query")
        
        return_data = cursor.fetchall()
        print(f"return_data: {return_data}")
        cursor.close()
        conn.close()
        return return_data
    except Exception as e:
        conn.rollback()
        print(f"Exception: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        conn.close()

@app.post("/uploadPicture/")
async def upload_image(file: UploadFile = File(...)):
    try:
        file_location = f"./uploads/{file.filename}"  # Define file location

        # Save the uploaded file to a directory
        with open(file_location, "wb+") as file_object:
            file_object.write(file.file.read())

        print(f"file '{file.filename}' saved at '{file_location}'")

        # Run your model
        results = extract_receipt(model, file_location)

        # After saving the file, you can do additional processing if required
        return {"info": f"file '{file.filename}' saved at '{file_location}'",
                "results": results}
    except Exception as e:
        print(f"Exception: {e}")
        raise HTTPException(status_code=500, detail=str(e))