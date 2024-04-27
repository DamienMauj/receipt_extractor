from fastapi import FastAPI, HTTPException, UploadFile, File, status, Response, Form
from pydantic import BaseModel, EmailStr
from dotenv import load_dotenv
from psycopg2.extras import RealDictCursor
from psycopg2 import Binary
from receipt_server.helper import get_db_connection
import uuid
import logging
from ultralytics import YOLO
from receipt_server.model.functions.extract_receipt import extract_receipt
from receipt_server.model.functions.llm_data_cleaning import generate_receipt_json
from receipt_server.model.functions.data_cleaning import clean_receipt_data
from receipt_server.model.functions.format_extracted_data_for_db_upload import format_extracted_data_for_db_upload
from receipt_server.model.functions.server_query import receipt_table_column, receipt_update_query, raw_receipt_insert_query, receipt_insert_query, new_receipt_insert_query
from dateutil import parser
from receipt_server.path import MODEL_PATH, UPLOAD_PICTURE_PATH
from PIL import Image
from io import BytesIO
import os
import datetime

log = logging.getLogger("uvicorn")

load_dotenv()

model = YOLO(MODEL_PATH)
log.info("INFO: model loaded")

# Load the environment variables
DB_HOST = os.getenv('DB_HOST')
DB_PORT = os.getenv('DB_PORT')
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_NAME = os.getenv('DB_NAME')

# Create the FastAPI app
app = FastAPI()


@app.get("/hello")
async def hello_world():
    return {"message": "Hello, World!"}



class User(BaseModel):
    email: EmailStr
    password: str

# Endpoint to register a new user
@app.post("/register/")
async def create_item(user: User):
    try:
        conn = get_db_connection(DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        user_id = uuid.uuid4()
        print("executing query")
        insert_query = "INSERT INTO \"users\" (user_id, email, password) VALUES (%s, %s, %s)"
        data_to_insert = (str(user_id), user.email, user.password)

        # Execute the query
        cursor.execute(insert_query, data_to_insert)
        
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


# Endpoint to get user details
@app.post("/users/", status_code=200)
async def get_user(kwargs: dict, response: Response):

    try:
        print(f"kwargs: {kwargs}")
        conn = get_db_connection(DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        email = kwargs.get("email")
        print(f"fetching for  {email}")
        select_query = "SELECT * FROM \"users\" WHERE email = %s"
        data_to_select = (email,)

        # Execute the query
        cursor.execute(select_query, data_to_select)
        print("executed query")
        
        return_data = cursor.fetchall()
        print(f"return_data: {return_data}")
        if return_data:
            return return_data[0]
        else:
            response.status_code = status.HTTP_204_NO_CONTENT
            return {"detail": "User not found"}         
    except Exception as e:
        conn.rollback()
        print(f"Exception: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        conn.close()

# Endpoint to upload a picture and extract the receipt data
@app.post("/uploadPicture/")
async def upload_image(user_id: str = Form(...), file: UploadFile = File(...)):
    try:
        contents = await file.read()
        file_location = os.path.join(UPLOAD_PICTURE_PATH, file.filename)
        receipt_id = str(uuid.uuid4())
        print("User ID:", user_id)
 
        # Resize the image to 640x640
        image = Image.open(BytesIO(contents))
        resized_image = image.resize((640,640))

        # Save the resized image to the file location
        with open(file_location, "wb") as file_object:
            resized_image.save(file_object, format=image.format)
       

        # Generate the raw receipt data
        raw_receipt_data = {
            "receipt_id": receipt_id,
            "export_datetime": datetime.datetime.now(),
            "image": Binary(contents)
        }

        # Run your model and extract the receipt section
        model_results = extract_receipt(model, file_location)
        # Format the extracted data
        process_results = generate_receipt_json(os.getenv("OPENAI_API_KEY"), model_results)

        clean_data = clean_receipt_data(process_results, receipt_id=receipt_id, user_id=user_id)
        to_upload = format_extracted_data_for_db_upload(clean_data, model_results, receipt_table_column )

        #insert into db
        conn = get_db_connection(DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME)
        cursor = conn.cursor(cursor_factory=RealDictCursor)

        cursor.execute(raw_receipt_insert_query, raw_receipt_data)
        cursor.execute(receipt_insert_query, to_upload)
        conn.commit()
        
        # After saving the file, you can do additional processing if required
        return {"image_location": {file_location},
                "results": clean_data}
    except Exception as e:
        conn.rollback()
        print(f"Exception: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        conn.close()

# Endpoint to upload receipt data and update the database
@app.post("/uploadReceiptData/", status_code=200)
async def upload_receipt_data(kwargs: dict, response: Response):
    try:
        print(f"kwargs: {kwargs}")
        conn = get_db_connection(DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        user_id = kwargs.get("user_id")
        receipt_data = kwargs.get("results")
        receipt_data["status"] = "reviewed"
        receipt_data["item_purchase"] = str(receipt_data["item_purchase"]).replace("'", "\"")
        for key, value in receipt_data.items():
            if value == "":
                print(f"filling {value} with None")
                receipt_data[key] = None

        # Check if it's a new receipt or an update
        if kwargs.get("new_receipt"):
            print("Inserting new receipt data")
            cursor.execute(new_receipt_insert_query, receipt_data)
        else:
            print("Updating receipt data")
            cursor.execute(receipt_update_query, receipt_data)
        
        conn.commit()
        cursor.close()
        conn.close()
        return {"status": "success"}
    except Exception as e:
        conn.rollback()
        print(f"Exception: {e}")
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return {"status": "failed", "message": str(e)}
    finally:
        cursor.close()
        conn.close()

# Endpoint to get receipt data
@app.get("/getReceipt/")
async def get_receipt_data(user_id: str = None):
    try:
        conn = get_db_connection(DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        select_query = f"SELECT receipt_id, type, shop_information, time, total, item_purchase FROM receipt WHERE status = 'reviewed' AND user_id = '{user_id}'::UUID ORDER BY time DESC"
        cursor.execute(select_query)
        return_data = cursor.fetchall()
        print(f"Requesting data for {user_id}")
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

