from fastapi import FastAPI, HTTPException, UploadFile, File, status, Response, Form
from pydantic import BaseModel, EmailStr
from dotenv import load_dotenv
import os
from psycopg2.extras import RealDictCursor
from receipt_server.helper import get_db_connection
import uuid
import logging
from ultralytics import YOLO
from receipt_server.model.functions.extract_receipt import extract_receipt
from receipt_server.model.functions.llm_data_cleaning import generate_receipt_json
from receipt_server.model.functions.data_cleaning import clean_receipt_data
from dateutil import parser
from receipt_server.path import MODEL_PATH, UPLOAD_PICTURE_PATH
from PIL import Image
from io import BytesIO
import os

log = logging.getLogger("uvicorn")

load_dotenv()

model = YOLO(MODEL_PATH)
log.info("INFO: model loaded")

DB_HOST = os.getenv('DB_HOST')
DB_PORT = os.getenv('DB_PORT')
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_NAME = os.getenv('DB_NAME')
app = FastAPI()

receipt_table_column = [
    "receipt_id", 
    "user_id",
    "type", 
    "shop_information", 
    "time", 
    "total", 
    "item_purchase", 
    "raw_total", 
    "raw_shop_information", 
    "raw_time", 
    "raw_item_purchase", 
    "status"]

receipt_insert_query = insert_query = """
INSERT INTO receipt (
    receipt_id, 
    user_id,
    type, 
    shop_information, 
    time, 
    total, 
    item_purchase, 
    raw_total, 
    raw_shop_information, 
    raw_time, 
    raw_item_purchase, 
    status
) VALUES (
    %(receipt_id)s, 
    %(user_id)s,
    %(type)s, 
    %(shop_information)s, 
    %(time)s, 
    CAST(%(total)s AS DOUBLE PRECISION), 
    %(item_purchase)s, 
    %(raw_total)s, 
    %(raw_shop_information)s, 
    %(raw_time)s, 
    %(raw_item_purchase)s, 
    %(status)s
)
"""

receipt_update_query = """
UPDATE receipt
SET
    type = %(type)s,
    shop_information = %(shop_information)s,
    time = %(time)s,
    total = %(total)s,
    item_purchase = %(item_purchase)s,
    status = %(status)s
WHERE
    receipt_id = %(receipt_id)s AND 
    user_id = %(user_id)s
"""

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
        insert_query = "INSERT INTO \"users\" (user_id, email, password) VALUES (%s, %s, %s)"
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

@app.post("/uploadPicture/")
async def upload_image(user_id: str = Form(...), file: UploadFile = File(...)):
    try:
        # file_location = f"./receipt_server/uploads/{file.filename}"  # Define file location
        file_location = os.path.join(UPLOAD_PICTURE_PATH, file.filename)
        print("User ID:", user_id)
 
        contents = await file.read()
        image = Image.open(BytesIO(contents))

        # Resize the image
        resized_image = image.resize((640,640))

        # Save the resized image to the file location
        with open(file_location, "wb") as file_object:
            resized_image.save(file_object, format=image.format)

        # print(f"file '{file.filename}' saved at '{file_location}'")

        # Run your model
        results = extract_receipt(model, file_location)

        process_results = generate_receipt_json(os.getenv("OPENAI_API_KEY"), results)

        clean_data = clean_receipt_data(process_results)
        # generate uuid for receipt base on the receipt name
        clean_data["receipt_id"] = str(uuid.uuid4())
        clean_data["user_id"] = user_id
        clean_data["status"] = "pending"
        # process_results["type"] = "grocery"
        
        to_upload = clean_data.copy()
        to_upload["item_purchase"] = str(to_upload["item_purchase"]).replace("'", "\"")

        # for item in result put them into to_uplaod dict with while adding raw at the key
        for key, value in results.items():
            ###### TO BE CHANGE IN THE MODEL PREDICTION ####### 
            # if key == "shop_informaton":
            #     to_upload["raw_shop_information"] = value
            # elif key == "item_purshase":
            #     to_upload["raw_item_purchase"] = value
            # else: 
            to_upload[f"raw_{key}"] = value

        for key in receipt_table_column:
            if key not in to_upload:
                # print(f"adding {key} to to_upload")
                to_upload[key] = None
        
        for key, value in to_upload.items():
            if value == "":
                to_upload[key] = None

        # print(f"to_upload: {to_upload}")

        #insert into db
        conn = get_db_connection(DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.execute(insert_query, to_upload)
        conn.commit()

        cursor.close()
        conn.close()
        
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

@app.post("/uploadReceiptData/")
async def upload_receipt_data(kwargs: dict):
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
                receipt_data[key] = None

        # Execute the query
        cursor.execute(receipt_update_query, receipt_data)
        print("executed query")
        
        conn.commit()
        cursor.close()
        conn.close()
        return {"status": "success"}
    except Exception as e:
        conn.rollback()
        print(f"Exception: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        conn.close()

@app.get("/getReceipt/")
async def get_receipt_data():
    try:
        conn = get_db_connection(DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        select_query = "SELECT receipt_id, type, shop_information, time, total, item_purchase FROM receipt WHERE status = 'reviewed' AND user_id = 'f0a39253-df87-4f42-b8da-a9c893544b2c'::UUID ORDER BY time DESC"
        cursor.execute(select_query)
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