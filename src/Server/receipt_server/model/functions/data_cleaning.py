import json
from datetime import datetime

def clean_receipt_data(data):
    # Define the expected schema with default values
    cleaned_data = {
        "shop_information": None,
        "type": None,
        "total": None,
        "time": None,
        "item_purchase": {}
    }

    # Validate and assign shop information
    cleaned_data["shop_information"] = data.get("shop_information", None) if isinstance(data.get("shop_information"), str) else None

    # Validate and assign type
    cleaned_data["type"] = data.get("type", None) if isinstance(data.get("type"), str) else None

    # Validate and assign total
    try:
        cleaned_data["total"] = float(data["total"]) if isinstance(data["total"], (int, float, str)) else None
    except (ValueError, TypeError):
        print("Error in total")
        cleaned_data["total"] = None

    # Parse and validate time
    try:
        cleaned_data["time"] = str(datetime.strptime(data["time"], "%Y-%m-%d %H:%M:%S"))
    except (ValueError, TypeError, KeyError):
        print(f"Error in time - {data['time']}")
        cleaned_data["time"] = None

    # Validate item_purchase
    if isinstance(data.get("item_purchase"), dict):
        for item, details in data["item_purchase"].items():
            if isinstance(details, dict) and "qty" in details and "price" in details:
                try:
                    qty = int(details["qty"])
                except (ValueError, TypeError):
                    qty = None
                try:
                    price = float(details["price"])
                except (ValueError, TypeError):
                    price = None
                cleaned_data["item_purchase"][item] = {"qty": qty, "price": price}
            else:
                cleaned_data["item_purchase"][item] = {"qty": None, "price": None}
    else:
        cleaned_data["item_purchase"] = {}

    return cleaned_data
