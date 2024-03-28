import openai

def generate_receipt_json(api_key:str, raw_data:dict)-> dict:
    
    if not api_key:
        raise ValueError("API key is required to use OpenAI API")

    openai.api_key = api_key  # Replace 'your-api-key' with your OpenAI API key

    input_text = ""
    for key, value in raw_data.items():
        input_text += f"{key}:\n {value}\n\n"

    # print(f"{input_text}")


    # Prompt for generating receipt JSON
    prompt = '''You are tasked with developing a text processing system to clean raw OCR results of receipts. Your system should focus on extracting specific fields from the receipts and formatting them into a structured JSON format.

The fields to be extracted are:

Shop Information: This refers to the name of the shop from which the receipt originates.
Total: The total bill amount.
Time: The datetime of the transaction.
Item Purchase: This includes a list of items purchased, each with its name, quantity, and price.
Your system should perform the following tasks:

Clean any small errors in the OCR results, such as correcting single-character mistakes.
If the quantity of a product is not explicitly provided but mentioned multiple times, count the number of occurrences to estimate the quantity.
If a field is missing put None.
Format the output into a JSON structure with the following schema:
{{
"Shop_Information": "<Shop name>",
"Total": <Total bill amount>,
"Time": "<Datetime of transaction>",
"Item_purchase": {{
    "<Product name 1>": {{
    "qty": <Quantity>,
    "price": <Price>
    }},
    "<Product name 2>": {{
    "qty": <Quantity>,
    "price": <Price>
    }},
    ...
}}
}}
Your system should be able to handle variations in OCR results and provide consistent and accurate extraction and formatting.

Example Output:

{{
"Shop_Information": "XYZ Store",
"Total": 50.25,
"Time": "2024-03-27 15:45:00",
"Item_purchase": {{
    "Apples": {{
    "qty": 2,
    "price": 5.00
    }},
    "Oranges": {{
    "qty": 3,
    "price": 3.50
    }},
    "Bananas": {{
    "qty": 1,
    "price": 1.25
    }}
}}
}}
Ensure that your system handles various formats and variations in OCR results effectively to provide accurate extraction and formatting.

Here the data to process:
{input_text}
You have to respond in the json format and the json format only without saying anything else'''

    prompt = prompt.format(input_text=input_text)

    print(f"pro÷mpt: {prompt}")
    
    # response = openai.chat.completions.create(
    #     model="gpt-3.5-turbo",
    #     messages=prompt,
    #     # max_tokens=150,
    #     # n=1,
    #     # stop=None
    # )
    # print(f"response: {response}")
    print("return mock rresponse until fixed")
    return {
  "Shop_Information": "LONDON SUPERMARKET LTD",
  "Total": "",
  "Time": "",
  "Item_purchase": {
    "DISQUE BE PIZZA A GARNIR": {
      "qty": 1,
      "price": 4.00
    },
    "ESPUNA 80G TRAD CHORIZO": {
      "qty": 1,
      "price": 58.00
    },
    "DENNY WHITE BUT .MUSHROOM": {
      "qty": 1,
      "price": 149.95
    },
    "CH COCA ZERO 1L": {
      "qty": 1,
      "price": 51.00
    },
    "VEG HE 250G RAINBOW TOMATO": {
      "qty": 1,
      "price": 138.00
    }
  }
}


