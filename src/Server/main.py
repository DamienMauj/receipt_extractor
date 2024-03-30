from fastapi import FastAPI, HTTPException, UploadFile, File
from pydantic import BaseModel, EmailStr
from dotenv import load_dotenv
import os
from psycopg2.extras import RealDictCursor
from helper import get_db_connection
import uuid
import logging
from ultralytics import YOLO
from model.functions.extract_receipt import extract_receipt
from model.functions.llm_data_cleaning import generate_receipt_json
from dateutil import parser


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

receipt_table_column = [
    "receipt_id", 
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
    receipt_id = %(receipt_id)s
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
    # try:
        file_location = f"./uploads/{file.filename}"  # Define file location

        # Save the uploaded file to a directory
        with open(file_location, "wb+") as file_object:
            file_object.write(file.file.read())

        # print(f"file '{file.filename}' saved at '{file_location}'")

        # Run your model
        results = extract_receipt(model, file_location)

        process_results = generate_receipt_json(os.getenv("OPENAI_API_KEY"), results)

        # generate uuid for receipt base on the receipt name
        process_results["receipt_id"] = str(uuid.uuid4())
        process_results["status"] = "pending"
        process_results["type"] = "grocery"
        
        to_upload = process_results.copy()
        to_upload["item_purchase"] = str(to_upload["item_purchase"])

        # for item in result put them into to_uplaod dict with while adding raw at the key
        for key, value in results.items():
            ###### TO BE CHANGE IN THE MODEL PREDICTION ####### 
            if key == "shop_informaton":
                to_upload["raw_shop_information"] = value
            elif key == "item_purshase":
                to_upload["raw_item_purchase"] = value
            else: 
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
        
        # print(f"results: {process_results}")
        # After saving the file, you can do additional processing if required
        return {"image_lication": {file_location},
                "results": process_results}
    # except Exception as e:
    #     conn.rollback()
    #     print(f"Exception: {e}")
    #     raise HTTPException(status_code=500, detail=str(e))
    # finally:
    #     cursor.close()
    #     conn.close()

@app.post("/uploadReceiptData/")
async def upload_receipt_data(kwargs: dict):
    try:
        print(f"kwargs: {kwargs}")
        conn = get_db_connection(DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        user_id = kwargs.get("user_id")
        receipt_data = kwargs.get("results")
        receipt_data["status"] = "reviewed"
        receipt_data["item_purchase"] = str(receipt_data["item_purchase"])
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
        select_query = "SELECT receipt_id, type, shop_information, time, total, item_purchase FROM receipt WHERE status = 'reviewed'"
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