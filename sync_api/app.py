from fastapi import FastAPI, HTTPException
from queries import *

app = FastAPI(title="Cluster Sync API")


@app.get("/api/sync/cluster/{cluster_id}")
def sync_cluster(cluster_id: int):
    cluster = get_cluster(cluster_id)
    if not cluster:
        raise HTTPException(status_code=404, detail="Cluster not found")

    return {
        "cluster_id": cluster_id,
        "data": {
            "building": get_building(cluster_id),
            "building_detail": get_building_detail(cluster_id),
            "cluster": cluster,
            "cluster_detail": get_cluster_detail(cluster_id),
            "room": get_rooms(cluster_id),
            "node": get_nodes(cluster_id),
            "installation_node": get_installation_node(cluster_id),

            "config": {
                "led": get_config("config_led", cluster_id),
                "air": get_config("config_air", cluster_id),
                "computer": get_config("config_computer", cluster_id),
                "projector": get_config("config_projector", cluster_id),
                "audio": get_config("config_audio_equipment", cluster_id),
                "door": get_config("config_door", cluster_id),
            },

            "bookings": get_bookings(cluster_id),
            "cluster_booking_node_map": get_booking_node_map(cluster_id),
            "booking_led_channel": get_booking_led_channels(cluster_id),
            "device_channels": get_device_channels(cluster_id),
        }
    }
