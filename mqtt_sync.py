import json
import paho.mqtt.publish as publish
from datetime import datetime

#MQTT_BROKER = "172.20.10.10"
MQTT_BROKER = "192.168.1.101"
MQTT_PORT = 1883
MQTT_TOPIC = "sync/event"

def publish_sync_event(table, event="changed"):
    payload = {
        "table": table,
        "event": event,
        "time": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

    try:
        publish.single(
            MQTT_TOPIC,
            json.dumps(payload),
            hostname=MQTT_BROKER,
            port=MQTT_PORT
        )
        print(f"[MQTT SYNC] Sent: {payload}")
    except Exception as e:
        print("[MQTT ERROR]", e)