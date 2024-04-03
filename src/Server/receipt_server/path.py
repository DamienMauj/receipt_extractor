# Script to manage the path of the server

import os
file_path = os.path.realpath(__file__)

MODEL_PATH = os.path.join(os.path.dirname(file_path), "model/versions/V0_2/receipt_extractor.pt")  
UPLOAD_PICTURE_PATH = os.path.join(os.path.dirname(file_path), "uploads")
