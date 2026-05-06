import json
from datetime import datetime

def handler(event, context):
    print("Incoming event:", json.dumps(event))

    name = event.get("queryStringParameters", {}).get("name", "Unknown")

    response = {
        "message": f"Okay the first thing we should do... is say hello to {name} from Python!",
        "timestamp": datetime.utcnow().isoformat()
    }

    print("Response:", json.dumps(response))

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(response)
    }