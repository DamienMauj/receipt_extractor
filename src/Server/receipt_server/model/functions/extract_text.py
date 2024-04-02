import numpy
import cv2
import pytesseract

def extract_text_from_image(image : numpy.ndarray):
    """
    Extract text from an image using Tesseract OCR.
    """
    # Read the image
    # image = cv2.imread(image_path)

    # Convert the image to gray scale
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Use Tesseract to do OCR on the image
    text = pytesseract.image_to_string(gray_image)

    return text