import openai
import json

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
shop information: This refers to the name of the shop from which the receipt originates.
type: the type of the receipt that you'll categorize.
total: The total bill amount.
time: The datetime of the transaction.
item purchase: This includes a list of items purchased, each with its name, quantity, and price.
Your system should perform the following tasks:

Clean any small errors in the OCR results, such as correcting single-character mistakes.
If the quantity of a product is not explicitly provided but mentioned multiple times, count the number of occurrences to estimate the quantity.
add the field type which will categories the receipt into category (grocery, gaz, restaurant,...)
If a field is missing put Null and nothing else, except for type field that you should guess out of the receipt data.
The total should be base on the provided data and not the sum of the items.
Format the output into a JSON structure with the following schema:
{{
  "shop_information": "<Shop name>",
  "type": "<receipt type>",
  "total": <Total bill amount>,
  "time": "<Datetime of transaction>",
  "item_purchase": {{
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
Your system should be able to handle variations in OCR results and provide consistent and accurate extraction ,formatting and correction of few character if needed.


Here the data to process:
{input_text}
You have to respond in the json format and the json format only without saying anything else'''

    prompt = prompt.format(input_text=input_text)

    print(f"prompt: {prompt}")
    
    response = openai.chat.completions.create(
        model="gpt-3.5-turbo",
        messages= [{
          "role": "user",
          "content": prompt
        }]
    )
    extracted_response = response.choices[0].message.content
    print(f"response: {extracted_response}")
    
    # parse json
    extracted_response = json.loads(extracted_response)
    # extracted_response = {
    #   "Shop_Information": "LONDON SUPERMARKET LTD",
    #   "Type": "Grocery",
    #   "Total": "",
    #   "Time": "",
    #   "Item_purchase": {
    #     "DISQUE BE PIZZA A GARNIR": {
    #       "qty": 1,
    #       "price": 4.00
    #     },
    #     "ESPUNA 80G TRAD CHORIZO": {
    #       "qty": 1,
    #       "price": 58.00
    #     },
    #     "DENNY WHITE BUT .MUSHROOM": {
    #       "qty": 1,
    #       "price": 149.95
    #     },
    #     "CH COCA ZERO 1L": {
    #       "qty": 1,
    #       "price": 51.00
    #     },
    #     "VEG HE 250G RAINBOW TOMATO": {
    #       "qty": 1,
    #       "price": 138.00
    #     }
    #   }
    # }

    #make the dictionary all lowercase
    return_data = {}
    for key, value in extracted_response.items():
        if isinstance(value, dict):
            return_data[key.lower()] = {k.lower(): v for k, v in value.items()}
        else:
            return_data[key.lower()] = value

    return return_data
