from ultralytics import YOLO
import cv2
from model.functions import extract_text

def extract_receipt(model:YOLO, file_path:str)->dict:
    # Run your model
    results = model(file_path)

    receipt_data = {}

    # Dictionary to store highest confidence detection for each class
    highest_conf_detections = {}
    for result in results:
        for box in result.boxes:
            class_label = result.names[int(box.cls)]
            conf = box.conf

            # Check if this class_label already exists and if this detection has higher confidence
            if class_label not in highest_conf_detections or highest_conf_detections[class_label].conf < conf:
                highest_conf_detections[class_label] = box

    # Now process only the detections with highest confidence for each class
    for class_label, box in highest_conf_detections.items():
        image = cv2.imread(file_path)

        # Get box coordinates
        x1 = int(box.xyxy[0][0])
        y1 = int(box.xyxy[0][1])
        x2 = int(box.xyxy[0][2])
        y2 = int(box.xyxy[0][3])

        crop_img = image[y1:y2, x1:x2]

        receipt_data[class_label] = extract_text.extract_text_from_image(crop_img)
    return receipt_data

# if __name__ == "__main__":
#     model = YOLO("src/Server/model/versions/0.1/receipt_extractor.pt")
#     print(extract_receipt(model, "/Users/damienmaujean/Library/CloudStorage/OneDrive-Personal/university/MiddleSex University/Year 3/CST3990 Individual Project/src/receipt extractor/experimentation/receipt extraction model.v2i.yolov8/train/images/d1200d48-IMG_20231221_163158_jpg.rf.62e836e90e98bdc0f0b982dc3f6be3f4.jpg"))