# from httpx import AsyncClient
# import pytest
from receipt_server.main import app
from fastapi.testclient import TestClient
import pytest
import logging
import warnings
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
    with open("image.png", "rb") as picture_file:
        # Read the picture file
        picture_content = picture_file.read()

    # Create a dictionary for the files parameter
    files = {"file": ("picture.png", picture_content, "image/png")}

    # Send a POST request to the uploadPicture endpoint
    response = client.post("/uploadPicture", files=files)

    # Check the response status code
    assert response.status_code == 200

    # Check the response body
    # This depends on how your uploadPicture endpoint is implemented
    # For example, if your endpoint returns the filename, you can do:
    assert response.json()["image_location"] == ['/usr/src/app/receipt_server/uploads/picture.png']
