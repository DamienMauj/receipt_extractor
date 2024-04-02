# Dockerfile for Python Application

# Use an official Python runtime as a base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /usr/src/app

# add cv2 dependencies
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y

#add tesseract dependencies
RUN apt-get update && apt-get install tesseract-ocr -y


# Copy the current directory contents into the container
COPY . .

# Install any needed packages specified in requirements.txt
# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install -r receipt_server/requirements.txt
RUN pip install -e .

# RUN chmod +x ./tests/tests.sh
# RUN ./tests/tests.sh

# Command to run the application
CMD ["uvicorn", "receipt_server.main:app", "--host", "0.0.0.0", "--reload"]
