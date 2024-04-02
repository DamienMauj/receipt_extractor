from httpx import AsyncClient
import pytest
from Server.main import app


@pytest.mark.asyncio
async def test_hello_world():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/hello")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello, World!"}

@pytest.mark.asyncio
async def test_create_item():
    test_user = {"email": "test@example.com", "password": "testpassword123"}
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.post("/register/", json=test_user)
    assert response.status_code == 200
    assert "user_id" in response.json()

@pytest.mark.asyncio
async def test_get_user():
    test_user_id = "some-user-id"  # Use a valid user ID for testing
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.post("/users/", json={"user_id": test_user_id})
    assert response.status_code == 200
    assert response.json() == ...  # Expected response data
