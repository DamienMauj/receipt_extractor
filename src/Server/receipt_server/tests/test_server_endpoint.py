# from httpx import AsyncClient
# import pytest
from receipt_server.main import app
from fastapi.testclient import TestClient
import pytest
import logging
import warnings
import uuid
from receipt_server.path import TESTING_FILE_PATH
import os

warnings.filterwarnings("ignore", category=DeprecationWarning) 

log = logging.getLogger("uvicorn")

client = TestClient(app)


def test_hello_world():
    response = client.get("/hello")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello, World!"}


def test_create_item():
    test_user = {"email": "test@example.com", "password": "testpassword123"}
    response = client.post("/register/", json=test_user)
    assert response.status_code == 200
    assert "user_id" in response.json()

def test_get_user():
    test_email = "damienmaujean@gmail.com"  # Use a valid user ID for testing
    response = client.post("/users/", json={"email": test_email})
    assert response.status_code == 200
    assert response.json() == {
        "user_id": "f0a39253-df87-4f42-b8da-a9c893544b2c",
        "email": "damienmaujean@gmail.com",
        "password": "tesp1234"
    }

def test_get_user_invalid():
    test_error_email = "invalideemail@gmail.com"
    response = client.post("/users/", json={"email": test_error_email})
    assert response.status_code == 204

def test_upload_picture():
    # Open the picture file in binary mode
    file_path = os.path.join(TESTING_FILE_PATH, "/image.png")

    with open("/usr/src/app/receipt_server/tests/image.png", "rb") as picture_file:
        # Read the picture file
        picture_content = picture_file.read()


    # Create a dictionary for the files parameter
    files = {"file": ("picture.png", picture_content, "image/png")}
    
    # Create a dictionary for the form data
    data = {"user_id": "0b158bbc-3842-4dc2-b8dc-8dec91f4a92a"}

    # Send a POST request to the uploadPicture endpoint
    response = client.post("/uploadPicture", files=files, data=data)

    # Check the response status code
    assert response.status_code == 200

    # Check the response body
    # This depends on how your uploadPicture endpoint is implemented
    # For example, if your endpoint returns the filename, you can do:
    assert response.json()["image_location"] == ['/usr/src/app/receipt_server/uploads/picture.png']



def test_upload_receipt_data():
    # Create a dictionary for the receipt data

    receipt_id = str(uuid.uuid4())
    receipt_data = {
        "user_id": "0b158bbc-3842-4dc2-b8dc-8dec91f4a92a",
        "results": {
            "user_id": "0b158bbc-3842-4dc2-b8dc-8dec91f4a92a",
            "receipt_id": receipt_id,
            "shop_information": "Test Shop",
            "type": "Grocery",
            "time": "2022-01-01T00:00:00.000Z",
            "total": 100.0,
            "item_purchase": "{\"Apple\": {\"quantity\": 1, \"price\": 1.0}}"
        }
    }

    # Send a POST request to the uploadReceiptData endpoint
    response = client.post("/uploadReceiptData", json=receipt_data)

    # Check the response status code
    assert response.status_code == 200

    # Check the response body
    assert response.json() == {"status": "success"}