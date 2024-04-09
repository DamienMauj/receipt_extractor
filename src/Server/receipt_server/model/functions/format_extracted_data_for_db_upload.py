def format_extracted_data_for_db_upload(processed_data, model_results, receipt_table_column) -> dict:
    to_upload = processed_data.copy()

    to_upload["item_purchase"] = str(to_upload["item_purchase"]).replace("'", "\"")

    # for item in result put them into to_uplaod dict with while adding raw at the key
    for key, value in model_results.items():
        to_upload[f"raw_{key}"] = value

    for key in receipt_table_column:
        if key not in to_upload:
            to_upload[key] = None
    
    for key, value in to_upload.items():
        if value == "":
            to_upload[key] = None

    return to_upload