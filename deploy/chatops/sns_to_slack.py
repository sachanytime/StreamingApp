"""Lambda: forward SNS deployment/alarm events to Slack (#assignment-herovired)."""
import json, os, urllib.request
WEBHOOK = os.environ["SLACK_WEBHOOK_URL"]
def handler(event, _ctx):
    rec = event["Records"][0]["Sns"]
    subject = rec.get("Subject", "StreamingApp event"); message = rec.get("Message", "")
    color = "#2eb67d" if ("SUCCESS" in subject or "OK" in subject) else "#d13212"
    payload = {"channel": "#assignment-herovired", "attachments": [
        {"color": color, "title": subject, "text": message, "footer": "StreamingApp ChatOps"}]}
    urllib.request.urlopen(urllib.request.Request(WEBHOOK, data=json.dumps(payload).encode(),
        headers={"Content-Type": "application/json"}), timeout=5)
    return {"statusCode": 200}
