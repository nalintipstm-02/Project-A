#queries.py
from db import get_db

def fetch_all(sql, params=None):
    conn = get_db()
    cur = conn.cursor(dictionary=True)
    cur.execute(sql, params or ())
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return rows


# ------------------ STRUCTURE ------------------

def get_cluster(cluster_id):
    return fetch_all(
        "SELECT * FROM Cluster WHERE cluster_id = %s",
        (cluster_id,)
    )


def get_building(cluster_id):
    return fetch_all("""
        SELECT DISTINCT b.*
        FROM Building b
        JOIN Building_detail bd ON b.building_id = bd.building_id
        WHERE bd.cluster_id = %s
    """, (cluster_id,))


def get_building_detail(cluster_id):
    return fetch_all(
        "SELECT * FROM Building_detail WHERE cluster_id = %s",
        (cluster_id,)
    )


def get_cluster_detail(cluster_id):
    return fetch_all(
        "SELECT * FROM Cluster_Detail WHERE cluster_id = %s",
        (cluster_id,)
    )


def get_rooms(cluster_id):
    return fetch_all("""
        SELECT r.*
        FROM Room r
        JOIN Cluster_Detail cd ON r.room_id = cd.room_id
        WHERE cd.cluster_id = %s
    """, (cluster_id,))


def get_installation_node(cluster_id):
    return fetch_all("""
        SELECT ins.*
        FROM Installation_Node ins
        JOIN Cluster_Detail cd ON ins.room_id = cd.room_id
        WHERE cd.cluster_id = %s
    """, (cluster_id,))


def get_nodes(cluster_id):
    return fetch_all("""
        SELECT DISTINCT n.*
        FROM Node n
        JOIN Installation_Node ins ON n.node_id = ins.node_id
        JOIN Cluster_Detail cd ON ins.room_id = cd.room_id
        WHERE cd.cluster_id = %s
    """, (cluster_id,))


# ------------------ CONFIG ------------------

def get_config(table, cluster_id):
    return fetch_all(f"""
        SELECT c.*
        FROM {table} c
        JOIN Installation_Node ins ON c.node_id = ins.node_id
        JOIN Cluster_Detail cd ON ins.room_id = cd.room_id
        WHERE cd.cluster_id = %s
    """, (cluster_id,))


# ------------------ BOOKING ------------------

def get_bookings(cluster_id):
    return fetch_all("""
        SELECT DISTINCT b.*
        FROM bookings b
        JOIN Cluster_Detail cd ON b.room_id = cd.room_id
        WHERE cd.cluster_id = %s
            AND b.end_time >= NOW()
             
    """, (cluster_id,))



def get_booking_node_map(cluster_id):
    return fetch_all("""
        SELECT
            cbnm.booking_id,
            cbnm.node_id,
            b.booking_date,
            b.start_time,
            b.end_time,
            b.status,
            cbnm.sync_version
        FROM cluster_booking_node_map cbnm
        JOIN bookings b
            ON cbnm.booking_id = b.id
        JOIN Node n
            ON cbnm.node_id = n.node_id
        JOIN Installation_Node ins
            ON n.node_id = ins.node_id
        JOIN Room r
            ON ins.room_id = r.room_id
        JOIN Cluster_Detail cd
            ON cd.room_id = r.room_id
        WHERE cd.cluster_id = %s
          AND b.end_time >= NOW()
    """, (cluster_id,))


def get_booking_led_channels(cluster_id):
    return fetch_all("""
        SELECT
            blc.booking_id,
            blc.node_id,
            blc.channel_id,
            dc.gpio
        FROM booking_led_channel blc
        JOIN device_channel dc
            ON blc.channel_id = dc.id
        JOIN bookings b
            ON blc.booking_id = b.id
        JOIN Cluster_Detail cd
            ON b.room_id = cd.room_id
        WHERE cd.cluster_id = %s
          AND b.end_time >= NOW()
    """, (cluster_id,))

def get_device_channels(cluster_id):
    return fetch_all("""
        SELECT
            dc.id,
            dc.node_id,
            dc.device_type,
            dc.gpio,
            dc.name,
            dc.is_active
        FROM device_channel dc
        JOIN Node n 
            ON dc.node_id = n.node_id
        JOIN Installation_Node ins 
            ON n.node_id = ins.node_id
        JOIN Cluster_Detail cd 
            ON ins.room_id = cd.room_id
        WHERE cd.cluster_id = %s
    """, (cluster_id,))