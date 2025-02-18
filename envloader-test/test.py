import os
import json

print("\nEnvironment variables found:")
vars_to_check = [
    'MICROSOFT_TOKEN', 
    'MICROSOFT_REGION', 
    'MICROSOFT_TOKEN_TRANS',
    'CONFIG_ENCRYPTION_KEY',
    'SIMPLE_VAR',
    'JSON_VAR',
    'GOOGLE_CREDS_JSON'
]

for key in vars_to_check:
    val = os.environ.get(key, 'NOT FOUND')
    # Truncate long values
    print(f"{key}: {val[:50]}..." if len(str(val)) > 50 else f"{key}: {val}")

print("\nTrying to parse JSON_VAR:")
json_var = os.environ.get('JSON_VAR')
if json_var:
    print("Raw JSON_VAR:", json_var)
    try:
        parsed = json.loads(json_var)
        print("Parsed JSON_VAR:", parsed)
        print("name:", parsed.get('name'))
        print("value:", parsed.get('value'))
    except json.JSONDecodeError as e:
        print("Error parsing JSON:", e)

print("\nTrying to parse GOOGLE_CREDS_JSON:")
google_json = os.environ.get('GOOGLE_CREDS_JSON')
if google_json:
    try:
        # Remove escaped quotes before parsing
        cleaned_json = google_json.replace('\\"', '"')
        parsed = json.loads(cleaned_json)
        print("GOOGLE_CREDS_JSON (partial):")
        print("project_id:", parsed.get('project_id'))
        print("client_email:", parsed.get('client_email'))
    except json.JSONDecodeError as e:
        print("Error parsing Google JSON:", e) 