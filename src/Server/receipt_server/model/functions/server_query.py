receipt_table_column = [
    "receipt_id", 
    "user_id",
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

receipt_insert_query = """
INSERT INTO receipt (
    receipt_id, 
    user_id,
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
    %(user_id)s,
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
    receipt_id = %(receipt_id)s AND 
    user_id = %(user_id)s
"""

new_receipt_insert_query = """
INSERT INTO receipt (
    receipt_id, 
    user_id,
    type, 
    shop_information, 
    time, 
    total, 
    item_purchase,
    status
) VALUES (
    %(receipt_id)s, 
    %(user_id)s,
    %(type)s, 
    %(shop_information)s, 
    %(time)s, 
    CAST(%(total)s AS DOUBLE PRECISION), 
    %(item_purchase)s, 
    %(status)s
)
"""

raw_receipt_insert_query = """
INSERT INTO raw_receipt (
    receipt_id,
    export_datetime,
    image
) VALUES (
    %(receipt_id)s,
    %(export_datetime)s,
    %(image)s
)
"""