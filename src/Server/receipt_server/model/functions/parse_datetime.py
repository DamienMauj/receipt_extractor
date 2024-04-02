import re
import datetime as dt

def parse_datetime_with_regex(user_input):
    regex_patterns = [
        r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}',  # Example: 2022-06-23 12:01:01
        r'\d{2}-\d{2}-\d{4} \d{2}:\d{2}:\d{2}',  # Example: 12-01-2001 12:01:01
        r'\d{4}/\d{2}/\d{2} \d{2}:\d{2}:\d{2}',  # Example: 2001/03/12 12:01:01
        r'\d{2}/\d{2}/\d{4} \d{2}:\d{2}:\d{2}',  # Example: 12/01/2001 12:01:01
        r'\d{4}-\d{2}-\d{2}',  # Example: 2022-06-23
        r'\d{2}-\d{2}-\d{4}',  # Example: 12-01-2001
        r'\d{4}/\d{2}/\d{2}',  # Example: 2001/03/12
        r'\d{2}/\d{2}/\d{4}'   # Example: 12/01/2001
    ]
    
    for pattern in regex_patterns:
        match = re.match(pattern, user_input)
        if match:
            try:
                formatted_datetime = dt.datetime.strptime(user_input, "%Y-%m-%d %H:%M:%S")
                return formatted_datetime
            except ValueError:
                return None
        
    return None

# Example usage:
user_input = input("Enter a datetime: ")
formatted_datetime = parse_datetime_with_regex(user_input)
print(f"Formatted datetime: {formatted_datetime}")