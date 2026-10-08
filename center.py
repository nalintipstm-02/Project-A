from flask import Flask, render_template, request, redirect, url_for, flash,session
from werkzeug.routing import BuildError
import mysql.connector
from mysql.connector import Error
import threading
import time
import paho.mqtt.client as mqtt
import paho.mqtt.publish as publish
import requests
import datetime 
import hashlib
import datetime
import os
os.environ['TZ'] = 'Asia/Bangkok'

from mqtt_sync import publish_sync_event



# ------------------ LINE NOTIFY ------------------
LINE_TOKEN = "qxpqFm5C/Db7cL+jTVaF1BImGfbkQo70YuZVzFS2de4PbWwzSCg8qPhAL++LibYRDTUw5Oj/ryTWd47FQTpoqsDJ/oiD59GHn5m6Q3VY1DuHrSGQMjnHDBekdLfnCXrQih3viPhdKfqC5dgQCiRTjAdB04t89/1O/w1cDnyilFU="
ADMIN_USER_ID = "U16e20b298d84a4ad76ee77639caeea9d"

def notify_admin(message):
    url = "https://api.line.me/v2/bot/message/push"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {LINE_TOKEN}"
    }
    data = {
        "to": ADMIN_USER_ID,
        "messages": [
            {
                "type": "text",
                "text": message
            }
        ]
    }

    try:
        response = requests.post(url, headers=headers, json=data)
        print("LINE response:", response.status_code, response.text)
    except Exception as e:
        print("LINE ERROR:", e)


app = Flask(__name__)
app.secret_key = "c92676688a27d5c674da41410ab7474ae9dfe0eec78de78929186739654e29e2"
@app.route('/sso')
def sso():

    token = request.args.get('token')

    print("\n========== SSO START ==========")
    print("TOKEN RECEIVED:", bool(token))

    if not token:
        print("❌ NO TOKEN -> LOGIN")

        return redirect(
            "http://192.168.1.100:8000/login.php"
        )

    token_hash = hashlib.sha256(
        token.encode()
    ).hexdigest()

    conn = connect_auth_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            s.id AS token_id,
            s.user_id,
            s.expires_at,
            s.used,
            u.username,
            u.role
        FROM sso_tokens s
        JOIN users u
            ON s.user_id = u.id
        WHERE s.token_hash = %s
        LIMIT 1
    """, (token_hash,))

    data = cursor.fetchone()

    print("DATABASE RESULT:", data)

    if not data:
        print("❌ TOKEN NOT FOUND -> LOGIN")

        cursor.close()
        conn.close()

        return redirect(
            "http://192.168.1.100:8000/login.php"
        )

    print("TOKEN USED:", data["used"])
    print("TOKEN EXPIRES:", data["expires_at"])

    if data["used"] == 1:
        print("❌ TOKEN ALREADY USED -> LOGIN")

        cursor.close()
        conn.close()

        return redirect(
            "http://192.168.1.100:8000/login.php"
        )

    now = datetime.datetime.now()

    print("CURRENT TIME:", now)

    if data["expires_at"] < now:
        print("❌ TOKEN EXPIRED -> LOGIN")

        cursor.close()
        conn.close()

        return redirect(
            "http://192.168.1.100:8000/login.php"
        )

    # ใช้ Token
    cursor.execute("""
        UPDATE sso_tokens
        SET used = 1
        WHERE id = %s
    """, (data["token_id"],))

    conn.commit()

    cursor.close()
    conn.close()

    # Flask Session
    session.clear()

    session["user_id"] = data["user_id"]
    session["username"] = data["username"]
    session["role"] = data["role"]

    return redirect(url_for("dashboard"))

@app.after_request
def add_header(response):
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
    return response

# --------------------------------------------------------------------
from functools import wraps

def login_required(f):

    @wraps(f)
    def decorated(*args, **kwargs):

        if "user_id" not in session:
            return redirect(
                "http://192.168.1.100:8000/login.php"
            )

        return f(*args, **kwargs)

    return decorated

# ------------------ DB ------------------
def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="project"
    )

def connect_auth_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="booking_system"
    )

@app.route('/')
@login_required
def index():

    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    # =============================
    # All Installed Devices
    # =============================
    cursor.execute("""
        SELECT 
            dc.name AS device_name,
            n.node_name,
            n.node_type,
            r.room_name,
            dc.created_at AS installed_at
        FROM device_channel dc
        JOIN node n 
            ON dc.node_id = n.node_id
        JOIN installation_node i 
            ON n.node_id = i.node_id
        JOIN room r 
            ON i.room_id = r.room_id
        WHERE n.node_status = 1
        ORDER BY dc.created_at DESC
    """)
    devices = cursor.fetchall()


    # =============================
    # Recently Registered Devices
    # =============================
    cursor.execute("""
        SELECT 
            r.room_name,
            n.node_type,
            i.created_at
        FROM installation_node i
        JOIN node n 
            ON i.node_id = n.node_id
        JOIN room r 
            ON i.room_id = r.room_id
        WHERE n.node_status = 1
        ORDER BY i.created_at DESC
        LIMIT 10
    """)
    recent_devices = cursor.fetchall()


    # =============================
    # Devices per Room (แก้ไขให้ถูกต้อง)
    # =============================
    cursor.execute("""
        SELECT 
            r.room_name,
            COUNT(DISTINCT n.node_id) AS total_devices
        FROM room r
        LEFT JOIN installation_node i 
            ON r.room_id = i.room_id
        LEFT JOIN node n 
            ON i.node_id = n.node_id 
            AND n.node_status = 1
        GROUP BY r.room_name
        ORDER BY total_devices DESC
    """)
    devices_per_room = cursor.fetchall()


    # =============================
    # Dashboard Counters
    # =============================

    cursor.execute("SELECT COUNT(*) AS total FROM building")
    total_buildings = cursor.fetchone()["total"]

    cursor.execute("SELECT COUNT(*) AS total FROM room")
    total_rooms = cursor.fetchone()["total"]

    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM node
        WHERE node_status = 1
    """)
    total_nodes = cursor.fetchone()["total"]

    # นับจำนวน device channel ของ node ที่ active
    cursor.execute("""
        SELECT COUNT(dc.id) AS total
        FROM device_channel dc
        JOIN node n 
            ON dc.node_id = n.node_id
        WHERE n.node_status = 1
    """)
    total_devices = cursor.fetchone()["total"]


    cursor.close()
    conn.close()

    return render_template(
        "index.html",
        devices=devices,
        recent_devices=recent_devices,
        devices_per_room=devices_per_room,
        total_buildings=total_buildings,
        total_rooms=total_rooms,
        total_nodes=total_nodes,
        total_devices=total_devices
    )

@app.route('/dashboard')
@login_required
def dashboard():

    search = request.args.get('search', '')

    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    query = """
        SELECT r.room_name, n.node_type, i.created_at
        FROM installation_node i
        JOIN node n ON i.node_id = n.node_id
        JOIN room r ON i.room_id = r.room_id
        WHERE n.node_status = 1
        AND (r.room_name LIKE %s OR n.node_type LIKE %s)
        ORDER BY i.created_at DESC
        LIMIT 5
    """

    cursor.execute(query, (f"%{search}%", f"%{search}%"))
    devices = cursor.fetchall()

    return render_template("index.html", devices=devices)

# ------------------ BUILDINGS ------------------
@app.route('/buildings')
@login_required
def buildings():
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Building")
    buildings = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('buildings.html', buildings=buildings)




@app.route('/building/form', methods=['GET','POST'])
@app.route('/building/form/<int:building_id>', methods=['GET','POST'])
@login_required
def building_form(building_id=None):

    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        name = request.form['building_name']
        location = request.form['location']

        if building_id:
            cursor.execute("""
                UPDATE Building 
                SET building_name=%s, location=%s 
                WHERE building_id=%s
            """, (name, location, building_id))
            flash("Building updated", "success")
        else:
            cursor.execute("""
                INSERT INTO Building (building_name, location)
                VALUES (%s,%s)
            """, (name, location))
            flash("Building added", "success")

        conn.commit()
        publish_sync_event("building")
        cursor.close()
        conn.close()
        return redirect(url_for('buildings'))

    building = None
    if building_id:
        cursor.execute("SELECT * FROM Building WHERE building_id=%s", (building_id,))
        building = cursor.fetchone()

    cursor.close()
    conn.close()

    return render_template('building_form.html',
                           building=building,
                           building_id=building_id)


@app.route('/building/delete/<int:building_id>', methods=['POST'])
@login_required
def delete_building(building_id):
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)
    try:
        # หา Cluster ทั้งหมดที่ผูกกับอาคาร
        cursor.execute("SELECT cluster_id FROM building_detail WHERE building_id=%s", (building_id,))
        clusters = cursor.fetchall()

        for cluster in clusters:
            c_id = cluster['cluster_id']
            # หา Room ทั้งหมดใน Cluster
            cursor.execute("SELECT room_id FROM cluster_detail WHERE cluster_id=%s", (c_id,))
            rooms = cursor.fetchall()

            for room in rooms:
                r_id = room['room_id']
                # หา Node ทั้งหมดใน Room
                cursor.execute("SELECT node_id FROM installation_node WHERE room_id=%s", (r_id,))
                nodes = cursor.fetchall()

                for node in nodes:
                    n_id = node['node_id']
                    # ลบ Node พร้อม config ทั้งหมด (ON DELETE CASCADE)
                    cursor.execute("DELETE FROM node WHERE node_id=%s", (n_id,))

                # ลบ Room
                cursor.execute("DELETE FROM room WHERE room_id=%s", (r_id,))

            # ลบ Cluster
            cursor.execute("DELETE FROM cluster WHERE cluster_id=%s", (c_id,))

        # ลบ Building
        cursor.execute("DELETE FROM building WHERE building_id=%s", (building_id,))
        conn.commit()
        publish_sync_event("building")

        flash("ลบอาคาร ห้อง และอุปกรณ์ทั้งหมดเรียบร้อยแล้ว", "success")

    except Exception as e:
        conn.rollback()
        flash(f"เกิดข้อผิดพลาด: {str(e)}", "danger")
    finally:
        cursor.close()
        conn.close()

    return redirect(url_for('buildings'))



# ------------------ CLUSTERS ------------------

@app.route('/clusters/<int:building_id>')
@login_required
def clusters(building_id):
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT c.cluster_id, c.cluster_name
        FROM Cluster c
        JOIN Building_detail bd ON c.cluster_id = bd.cluster_id
        WHERE bd.building_id = %s
    """, (building_id,))
    building_clusters = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('clusters.html', clusters=building_clusters, building_id=building_id)


@app.route('/cluster/add/<int:building_id>', methods=['GET','POST'])
@login_required
def add_cluster(building_id):
    if request.method == 'POST':
        name = request.form['cluster_name']
        conn = connect_db()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO Cluster (cluster_name) VALUES (%s)", (name,))
        cluster_id = cursor.lastrowid
        cursor.execute("INSERT INTO Building_detail (building_id, cluster_id) VALUES (%s,%s)", (building_id, cluster_id))
        conn.commit()
        publish_sync_event("cluster")
        publish_sync_event("building_detail")
        cursor.close()
        conn.close()
        flash("Cluster added", "success")
        return redirect(url_for('clusters', building_id=building_id))
    
    return render_template('cluster_form.html', building_id=building_id)


@app.route('/cluster/edit/<int:cluster_id>', methods=['GET','POST'])
@login_required
def edit_cluster(cluster_id):
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Cluster WHERE cluster_id=%s", (cluster_id,))
    cluster = cursor.fetchone()
    
    # หา building_id จาก Building_detail
    cursor.execute("SELECT building_id FROM Building_detail WHERE cluster_id=%s", (cluster_id,))
    row = cursor.fetchone()
    building_id = row['building_id'] if row else None

    if request.method == 'POST':
        name = request.form['cluster_name']
        cursor.execute("UPDATE Cluster SET cluster_name=%s WHERE cluster_id=%s", (name, cluster_id))
        conn.commit()
        publish_sync_event("cluster")
        cursor.close()
        conn.close()
        flash("Cluster updated", "success")
        return redirect(url_for('clusters', building_id=building_id))

    cursor.close()
    conn.close()
    return render_template('edit_cluster.html', cluster=cluster, cluster_id=cluster_id, building_id=building_id)


@app.route('/cluster/delete/<int:cluster_id>', methods=['POST'])
@login_required
def delete_cluster(cluster_id):
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    # หา building_id ก่อนลบ เพื่อ redirect กลับ
    cursor.execute("SELECT building_id FROM Building_detail WHERE cluster_id=%s", (cluster_id,))
    row = cursor.fetchone()
    building_id = row['building_id'] if row else None

    # ลบ Cluster (Room & Node ต้องตั้ง ON DELETE CASCADE ใน DB)
    cursor.execute("DELETE FROM Cluster WHERE cluster_id=%s", (cluster_id,))
    conn.commit()
    publish_sync_event("cluster")
    cursor.close()
    conn.close()

    flash("Cluster deleted", "success")
    return redirect(url_for('clusters', building_id=building_id))
# ------------------ ROOMS ------------------

@app.route('/rooms/<int:cluster_id>')
@login_required
def rooms(cluster_id):
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT r.room_id, r.room_name, r.floor_number, r.room_type
        FROM Room r
        JOIN Cluster_Detail cd ON r.room_id = cd.room_id
        WHERE cd.cluster_id = %s
    """, (cluster_id,))
    cluster_rooms = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('rooms.html', rooms=cluster_rooms, cluster_id=cluster_id)


@app.route('/room/add/<int:cluster_id>', methods=['GET','POST'])
@login_required
def add_room(cluster_id):
    if request.method == 'POST':
        name  = request.form['room_name']
        floor = int(request.form['floor_number'])
        rtype = request.form['room_type']

        conn = connect_db()
        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO Room (room_name, floor_number, room_type)
            VALUES (%s, %s, %s)
        """, (name, floor, rtype))
        room_id = cursor.lastrowid

        cursor.execute("""
            INSERT INTO Cluster_Detail (cluster_id, room_id)
            VALUES (%s, %s)
        """, (cluster_id, room_id))
        conn.commit()
        publish_sync_event("room")
        publish_sync_event("cluster_detail")
        cursor.close()
        conn.close()

        flash("Room added", "success")
        return redirect(url_for('rooms', cluster_id=cluster_id))

    return render_template('add_room.html', cluster_id=cluster_id)


@app.route('/room/edit/<int:room_id>', methods=['GET','POST'])
@login_required
def edit_room(room_id):
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Room WHERE room_id=%s", (room_id,))
    room = cursor.fetchone()

    # หา cluster_id เพื่อ redirect
    cursor.execute("SELECT cluster_id FROM Cluster_Detail WHERE room_id=%s", (room_id,))
    row = cursor.fetchone()
    cluster_id = row['cluster_id'] if row else None

    if not room:
        cursor.close()
        conn.close()
        flash("Room not found", "danger")
        return redirect(url_for('rooms', cluster_id=cluster_id))

    if request.method == 'POST':
        name  = request.form['room_name']
        floor = int(request.form['floor_number'])
        rtype = request.form['room_type']

        cursor.execute("""
            UPDATE Room
            SET room_name=%s, floor_number=%s, room_type=%s
            WHERE room_id=%s
        """, (name, floor, rtype, room_id))
        conn.commit()
        publish_sync_event("room")
        cursor.close()
        conn.close()

        flash("Room updated", "success")
        return redirect(url_for('rooms', cluster_id=cluster_id))

    cursor.close()
    conn.close()
    return render_template('edit_room.html', room=room, cluster_id=cluster_id, room_id=room_id)


@app.route('/room/delete/<int:room_id>', methods=['POST'])
@login_required
def delete_room(room_id):
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    # หา cluster_id ก่อนลบ
    cursor.execute("SELECT cluster_id FROM Cluster_Detail WHERE room_id=%s", (room_id,))
    row = cursor.fetchone()
    cluster_id = row['cluster_id'] if row else None

    # ลบข้อมูล
    cursor.execute("DELETE FROM Cluster_Detail WHERE room_id=%s", (room_id,))
    cursor.execute("DELETE FROM Room WHERE room_id=%s", (room_id,))
    conn.commit()
    publish_sync_event("room")
    publish_sync_event("cluster_detail")
    cursor.close()
    conn.close()

    flash("Room deleted", "success")
    return redirect(url_for('rooms', cluster_id=cluster_id))


# ------------------ NODES ------------------
@app.route('/nodes/<int:room_id>')
@login_required
def nodes(room_id):
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            n.node_id,
            n.node_name,
            n.node_type,
            n.computer_role,
            n.detail,
            n.node_status
        FROM Node n
        JOIN Installation_Node i ON n.node_id = i.node_id
        WHERE i.room_id = %s
        AND n.node_status = 1
        AND i.status = 1
    """, (room_id,))

    room_nodes = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template('nodes.html', nodes=room_nodes, room_id=room_id)

@app.route('/node/add/<int:room_id>', methods=['GET','POST'])
@login_required
def add_node(room_id):

    if request.method == 'POST':

        name = request.form['node_name']
        ntype = request.form['node_type']
        role = request.form.get('computer_role')
        detail = request.form.get('detail', '')
        status = 1

        if ntype.lower() == "computer":
            role_value = role if role else None
        else:
            role_value = None

        conn = connect_db()
        cursor = conn.cursor()

        try:
            conn.start_transaction()

            # 1️⃣ เพิ่ม Node
            cursor.execute("""
                INSERT INTO Node (node_name, node_type, computer_role, detail, node_status)
                VALUES (%s,%s,%s,%s,%s)
            """,(name, ntype, role_value, detail, status))

            node_id = cursor.lastrowid

            # 2️⃣ ผูกกับห้อง
            cursor.execute("""
                INSERT INTO Installation_Node (room_id,node_id)
                VALUES (%s,%s)
            """,(room_id,node_id))

            # 3️⃣ เพิ่มสถานะ device เริ่มต้น
            cursor.execute("""
                INSERT INTO device_status (node_id,status,updated_at)
                VALUES (%s,'off',NOW())
            """,(node_id,))

            # ⭐ ถ้าเป็น LED ให้ sync channel status
            if ntype.lower() == "led":

                cursor.execute("""
                    INSERT INTO device_channel_status (channel_id,status)
                    SELECT dc.id,'off'
                    FROM device_channel dc
                    LEFT JOIN device_channel_status dcs
                        ON dc.id = dcs.channel_id
                    WHERE dc.node_id = %s
                    AND dcs.channel_id IS NULL
                """,(node_id,))

            conn.commit()
            publish_sync_event("node")
            publish_sync_event("installation_node")

        except Exception as e:
            conn.rollback()
            flash(f"Error: {str(e)}", "danger")
            return redirect(url_for('nodes', room_id=room_id))

        finally:
            cursor.close()
            conn.close()


        # LINE notify (เหมือนเดิม)
        message = (
            "มีการเพิ่มอุปกรณ์ใหม่\n"
            f"Node ID: {node_id}\n"
            f"ชื่อ: {name}\n"
            f"ประเภท: {ntype}\n"
            f"Room ID: {room_id}"
        )

        notify_admin(message)

        flash("Node added successfully", "success")
        return redirect(url_for('nodes', room_id=room_id))

    return render_template('add_node.html', room_id=room_id, node=None)

@app.route('/channel/add/<int:node_id>', methods=['POST'])
@login_required
def add_channel(node_id):

    channel_name = request.form['channel_name']

    conn = connect_db()
    cursor = conn.cursor()

    try:

        conn.start_transaction()

        # 1️⃣ เพิ่ม channel
        cursor.execute("""
            INSERT INTO device_channel (node_id,channel_name)
            VALUES (%s,%s)
        """,(node_id,channel_name))

        channel_id = cursor.lastrowid


        # 2️⃣ เพิ่ม status เพื่อโชว์หน้าเว็บ
        cursor.execute("""
            INSERT INTO device_channel_status (channel_id,status,updated_at)
            VALUES (%s,'off',NOW())
        """,(channel_id,))


        conn.commit()

    except Exception as e:

        conn.rollback()
        flash(str(e),'danger')

    finally:

        cursor.close()
        conn.close()


    flash("Channel created successfully",'success')
    return redirect(url_for('node_detail',node_id=node_id))

@app.route('/node/edit/<int:node_id>', methods=['GET','POST'])
@login_required
def edit_node(node_id):

    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM Node WHERE node_id=%s", (node_id,))
    node = cursor.fetchone()

    if not node:
        cursor.close()
        conn.close()
        flash("Node not found", "danger")
        return redirect('/')

    # หา room_id
    cursor.execute("SELECT room_id FROM Installation_Node WHERE node_id=%s", (node_id,))
    row = cursor.fetchone()
    room_id = row['room_id'] if row else None


    if request.method == 'POST':

        new_name = request.form['node_name']
        new_type = request.form['node_type']
        new_role = request.form.get('computer_role')
        new_detail = request.form.get('detail', '')

        cursor.execute("""
            UPDATE Node 
            SET node_name=%s, node_type=%s, computer_role=%s, detail=%s
            WHERE node_id=%s
        """, (new_name, new_type, new_role, new_detail, node_id))

        conn.commit()
        publish_sync_event("node")
        publish_sync_event("installation_node")

        cursor.close()
        conn.close()

        message = (
            "มีการแก้ไขอุปกรณ์\n"
            f"Node ID: {node_id}\n\n"
            "ก่อนแก้ไข\n"
            f"ชื่อ: {node['node_name']}\n"
            f"ประเภท: {node['node_type']}\n"
            f"Role: {node.get('computer_role')}\n"
            f"รายละเอียด: {node.get('detail')}\n\n"
            "หลังแก้ไข\n"
            f"ชื่อ: {new_name}\n"
            f"ประเภท: {new_type}\n"
            f"Role: {new_role}\n"
            f"รายละเอียด: {new_detail}"
        )

        notify_admin(message)

        flash("Node updated successfully", "success")

        return redirect(url_for('nodes', room_id=room_id))


    cursor.close()
    conn.close()

    return render_template(
        'edit_node.html',
        node=node,
        room_id=room_id
    )


@app.route('/node/delete/<int:node_id>', methods=['POST'])
@login_required
def delete_node(node_id):

    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    try:
        conn.start_transaction()

        # 🔍 หา node
        cursor.execute("SELECT * FROM Node WHERE node_id=%s", (node_id,))
        node = cursor.fetchone()

        if not node:
            flash("Node not found", "danger")
            return redirect(request.referrer or '/')

        # 🔍 หา room_id
        cursor.execute("SELECT room_id FROM Installation_Node WHERE node_id=%s", (node_id,))
        row = cursor.fetchone()
        room_id = row['room_id'] if row else None

        # 🔥 1️⃣ เปลี่ยนสถานะ node เป็น inactive
        cursor.execute("""
            UPDATE Node 
            SET node_status="inactive"
            WHERE node_id=%s
        """,(node_id,))

        # 🔥 2️⃣ เปลี่ยนสถานะ installation เป็น inactive
        cursor.execute("""
            UPDATE Installation_Node
            SET status="inactive"
            WHERE node_id=%s
        """,(node_id,))

        # 🔥 3️⃣ ลบ device_status
        cursor.execute("""
            DELETE FROM device_status
            WHERE node_id=%s
        """,(node_id,))

        # 🔥 4️⃣ ลบ channel status
        cursor.execute("""
            DELETE dcs
            FROM device_channel_status dcs
            JOIN device_channel dc ON dcs.channel_id = dc.id
            WHERE dc.node_id=%s
        """,(node_id,))

        # 🔥 5️⃣ เปลี่ยนสถานะ device_channel เป็น 0
        cursor.execute("""
            UPDATE device_channel
            SET is_active='0'
            WHERE node_id=%s
        """, (node_id,))
        node_type = node["node_type"]

        config_tables = {
            "led": "config_led",
            "projector": "config_projector",
            "air_conditioner": "config_air",
            "audio_equipment": "config_audio",
            "computer": "config_computer",
            "door": "config_door"
        }

        table_name = config_tables.get(node_type)

        if table_name:
            cursor.execute(
                f"""
                UPDATE {table_name}
                SET status='inactive'
                WHERE node_id=%s
                """,
                (node_id,)
            )
        conn.commit()
        publish_sync_event("node")
        publish_sync_event("installation_node")
        publish_sync_event("node")

    except Exception as e:
        conn.rollback()
        flash(f"Error: {str(e)}", "danger")
        return redirect(request.referrer or '/')

    finally:
        cursor.close()
        conn.close()

    notify_admin(
        f"มีการปิดใช้งานอุปกรณ์\n"
        f"Node ID: {node_id}\n"
        f"ชื่อ: {node['node_name']}\n"
        f"ประเภท: {node['node_type']}\n"
        f"รายละเอียด: {node.get('detail')}"
    )

    flash("Node set to inactive", "success")
    return redirect(url_for('nodes', room_id=room_id))




@app.route('/node/configure/<int:node_id>', methods=['GET','POST'])
@login_required
def configure_node(node_id):
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Node WHERE node_id=%s", (node_id,))
    node = cursor.fetchone()
    cursor.close()
    conn.close()

    if not node:
        flash("Node not found", "danger")
        return redirect(request.referrer or '/')

    node_type = node['node_type']

    config_pages = {
        "led": "config_led",
        "projector": "config_projector",
        "air_conditioner": "config_air",
        "audio_equipment": "config_audio",
        "computer": "config_computer",
        "door": "config_door"
    }

    if node_type in config_pages:
        return redirect(url_for(config_pages[node_type], node_id=node_id))
    else:
        flash("No configuration available for this node type", "warning")
        return redirect(request.referrer or '/')


# ------------------ LED CONFIG ------------------
@app.route('/config_led/<int:node_id>', methods=['GET', 'POST'])
@login_required
def config_led(node_id):

    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    # 🔍 ตรวจสอบ node
    cursor.execute("SELECT * FROM Node WHERE node_id=%s", (node_id,))
    node = cursor.fetchone()

    if not node or node['node_type'] != 'led':
        flash("This node is not LED", "danger")
        return redirect(url_for('index'))

    # 🔍 ดึง config_led
    cursor.execute("SELECT * FROM config_led WHERE node_id=%s", (node_id,))
    config = cursor.fetchone()

    # 🔍 ดึง GPIO ทั้งหมด
    cursor.execute("""
        SELECT * FROM device_channel
        WHERE node_id=%s
        ORDER BY id ASC
    """, (node_id,))
    channels = cursor.fetchall()

    # 🔍 หา room_id
    cursor.execute("SELECT room_id FROM Installation_Node WHERE node_id=%s", (node_id,))
    room = cursor.fetchone()
    room_id = room['room_id'] if room else None

    # ------------------ SAVE CONFIG ------------------
    if request.method == 'POST':
        broker = request.form['mqtt_broker']
        port = request.form['mqtt_port']
        on = request.form['command_led_on']
        off = request.form['command_led_off']

        if config:
            cursor.execute("""
                UPDATE config_led
                SET mqtt_broker=%s, mqtt_port=%s,
                    command_led_on=%s, command_led_off=%s
                WHERE node_id=%s
            """, (broker, port, on, off, node_id))
        else:
            cursor.execute("""
                INSERT INTO config_led
                (node_id, mqtt_broker, mqtt_port, command_led_on, command_led_off)
                VALUES (%s,%s,%s,%s,%s)
            """, (node_id, broker, port, on, off))

        conn.commit()
        publish_sync_event("config_led")

        flash("LED config saved", "success")
        return redirect(url_for('config_led', node_id=node_id))

    cursor.close()
    conn.close()

    return render_template(
        'led_config.html',
        node=node,
        config=config,
        channels=channels,   # 🔥 สำคัญ
        room_id=room_id
    )


# ------------------ ADD GPIO ------------------
@app.route('/led/channel/add/<int:node_id>', methods=['POST'])
@login_required
def add_led_channel(node_id):

    conn = connect_db()
    cursor = conn.cursor()

    gpio = request.form['gpio']
    name = request.form['name']


    cursor.execute("""
        INSERT INTO device_channel
        (node_id, device_type, gpio, name,  is_active)
        VALUES (%s, 'led', %s, %s,  1)
    """, (node_id, gpio, name,))

    conn.commit()
    cursor.close()
    conn.close()

    flash("GPIO added", "success")
    return redirect(request.referrer)


# ------------------ DELETE GPIO ------------------
@app.route('/led/channel/delete/<int:channel_id>', methods=['POST'])
@login_required
def delete_led_channel(channel_id):

    conn = connect_db()
    cursor = conn.cursor()

    cursor.execute("""
        UPDATE device_channel
        SET is_active='0'
        WHERE id=%s
    """, (channel_id,))

    conn.commit()
    cursor.close()
    conn.close()

    flash("GPIO deleted", "success")
    return redirect(request.referrer)

@app.route('/led/channel/update/<int:channel_id>', methods=['POST'])
@login_required
def update_led_channel(channel_id):

    conn = connect_db()
    cursor = conn.cursor()

    gpio = request.form['gpio']
    name = request.form['name']

    cursor.execute("""
        UPDATE device_channel
        SET gpio=%s,
            name=%s
        WHERE id=%s
    """, (gpio, name, channel_id))

    conn.commit()
    cursor.close()
    conn.close()

    flash("GPIO updated", "success")
    return redirect(request.referrer)
 
@app.route('/config_led/delete/<int:node_id>', methods=['POST'])
@login_required
def delete_led_config(node_id):
    conn = connect_db()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM config_led WHERE node_id=%s", (node_id,))
    '''
    cursor.execute("""
        UPDATE config_led
        SET status='inactive'
        WHERE node_id=%s
    """, (node_id,))'''
    conn.commit()
    publish_sync_event("config_led")
    publish_sync_event("installation_node")
    cursor.close()
    conn.close()

    flash("LED configuration deleted", "warning")
    return redirect(request.referrer or '/')


# ---------------- PROJECTOR ----------------

@app.route('/config_projector/<int:node_id>', methods=['GET', 'POST'])
@login_required
def config_projector(node_id):
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    # ดึง node จาก DB แทน cache
    cursor.execute("SELECT * FROM Node WHERE node_id=%s", (node_id,))
    node = cursor.fetchone()
    if not node or node['node_type'] != 'projector':
        cursor.close()
        conn.close()
        flash("This node is not of type 'Projector'", "danger")
        return redirect(url_for('index'))

    # ดึง room_id จาก Installation_Node
    cursor.execute("SELECT room_id FROM Installation_Node WHERE node_id=%s", (node_id,))
    row = cursor.fetchone()
    room_id = row['room_id'] if row else None

    # ดึง config จาก DB
    cursor.execute("SELECT * FROM config_projector WHERE node_id=%s", (node_id,))
    config = cursor.fetchone()

    if request.method == 'POST':
        rm_pro_ip = request.form['rm_pro_ip']
        rm_pro_mac = request.form['rm_pro_mac']
        ir_command_pro_on = request.form['ir_command_pro_on']
        ir_command_pro_off = request.form['ir_command_pro_off']

        if config:
            cursor.execute("""
                UPDATE config_projector
                SET rm_pro_ip=%s, rm_pro_mac=%s, ir_command_pro_on=%s, ir_command_pro_off=%s
                WHERE node_id=%s
            """, (rm_pro_ip, rm_pro_mac, ir_command_pro_on, ir_command_pro_off, node_id))
            flash("Projector configuration updated", "success")
        else:
            cursor.execute("""
                INSERT INTO config_projector (node_id, rm_pro_ip, rm_pro_mac, ir_command_pro_on, ir_command_pro_off)
                VALUES (%s, %s, %s, %s, %s)
            """, (node_id, rm_pro_ip, rm_pro_mac, ir_command_pro_on, ir_command_pro_off))
            flash("Projector configuration added", "success")

        conn.commit()
        publish_sync_event("config_projector")
        cursor.close()
        conn.close()

        return redirect(url_for('config_projector', node_id=node_id))

    cursor.close()
    conn.close()
    return render_template(
        "projector_config.html",
        node=node,
        config=config,
        room_id=room_id,
        node_id=node_id
    )


@app.route('/config_projector/delete/<int:node_id>', methods=['POST'])
@login_required
def delete_projector_config(node_id):
    conn = connect_db()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM config_projector WHERE node_id=%s", (node_id,))
    conn.commit()
    publish_sync_event("config_projector")
    cursor.close()
    conn.close()

    flash("Projector configuration deleted", "warning")
    return redirect(request.referrer or '/')

    
# ---------------- AIR CONDITIONER ----------------

@app.route('/config_air/<int:node_id>', methods=['GET', 'POST'])
@login_required
def config_air(node_id):
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    # ดึง node จาก DB แทน cache
    cursor.execute("SELECT * FROM Node WHERE node_id=%s", (node_id,))
    node = cursor.fetchone()
    if not node or node['node_type'] != 'air_conditioner':
        cursor.close()
        conn.close()
        flash("This node is not of type 'Air Conditioner'", "danger")
        return redirect(url_for('index'))

    # ดึง room_id จาก Installation_Node
    cursor.execute("SELECT room_id FROM Installation_Node WHERE node_id=%s", (node_id,))
    row = cursor.fetchone()
    room_id = row['room_id'] if row else None

    # ดึง config จาก DB
    cursor.execute("SELECT * FROM config_air WHERE node_id=%s", (node_id,))
    config = cursor.fetchone()

    if request.method == 'POST':
        rm_air_ip = request.form['rm_air_ip']
        rm_air_mac = request.form['rm_air_mac']
        ir_command_air_on = request.form['ir_command_air_on']
        ir_command_air_off = request.form['ir_command_air_off']

        if config:
            cursor.execute("""
                UPDATE config_air
                SET rm_air_ip=%s, rm_air_mac=%s, ir_command_air_on=%s, ir_command_air_off=%s
                WHERE node_id=%s
            """, (rm_air_ip, rm_air_mac, ir_command_air_on, ir_command_air_off, node_id))
            flash("Air configuration updated", "success")
        else:
            cursor.execute("""
                INSERT INTO config_air (node_id, rm_air_ip, rm_air_mac, ir_command_air_on, ir_command_air_off)
                VALUES (%s, %s, %s, %s, %s)
            """, (node_id, rm_air_ip, rm_air_mac, ir_command_air_on, ir_command_air_off))
            flash("Air configuration added", "success")

        conn.commit()
        publish_sync_event("config_air")
        cursor.close()
        conn.close()

        return redirect(url_for('config_air', node_id=node_id))

    cursor.close()
    conn.close()
    return render_template(
        "air_config.html",
        node=node,
        node_id=node_id,
        config=config,
        room_id=room_id
    )


@app.route('/config_air/delete/<int:node_id>', methods=['POST'])
@login_required
def delete_air_config(node_id):
    conn = connect_db()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM config_air WHERE node_id=%s", (node_id,))
    conn.commit()
    publish_sync_event("config_air")
    cursor.close()
    conn.close()

    flash("Air configuration deleted", "warning")
    return redirect(request.referrer or '/')
    
    

# ------------------ AUDIO ------------------
@app.route('/config_audio/<int:node_id>', methods=['GET', 'POST'])
@login_required
def config_audio(node_id):
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    # ดึง node จาก DB แทน cache
    cursor.execute("SELECT * FROM Node WHERE node_id=%s", (node_id,))
    node = cursor.fetchone()
    if not node or node['node_type'] != 'audio_equipment':
        cursor.close()
        conn.close()
        flash("This node is not of type 'Audio Equipment'", "danger")
        return redirect(url_for('index'))

    # ดึง room_id จาก Installation_Node
    cursor.execute("SELECT room_id FROM Installation_Node WHERE node_id=%s", (node_id,))
    row = cursor.fetchone()
    room_id = row['room_id'] if row else None

    # ดึง config จาก DB
    cursor.execute("SELECT * FROM config_audio_equipment WHERE node_id=%s", (node_id,))
    config = cursor.fetchone()

    if request.method == 'POST':
        mqtt_broker = request.form['mqtt_broker']
        mqtt_port = request.form['mqtt_port']
        command_audio_on = request.form['command_audio_on']
        command_audio_off = request.form['command_audio_off']

        if config:
            cursor.execute("""
                UPDATE config_audio_equipment
                SET mqtt_broker=%s, mqtt_port=%s, command_audio_on=%s, command_audio_off=%s
                WHERE node_id=%s
            """, (mqtt_broker, mqtt_port, command_audio_on, command_audio_off, node_id))
            flash("Audio configuration updated", "success")
        else:
            cursor.execute("""
                INSERT INTO config_audio_equipment (node_id, mqtt_broker, mqtt_port, command_audio_on, command_audio_off)
                VALUES (%s,%s,%s,%s,%s)
            """, (node_id, mqtt_broker, mqtt_port, command_audio_on, command_audio_off))
            flash("Audio configuration added", "success")

        conn.commit()
        publish_sync_event("config_audio_equipment")
        cursor.close()
        conn.close()

        return redirect(url_for('config_audio', node_id=node_id))

    cursor.close()
    conn.close()
    return render_template('audio_config.html', node=node, config=config, room_id=room_id)


@app.route('/config_audio/delete/<int:node_id>', methods=['POST'])
@login_required
def delete_audio_config(node_id):
    conn = connect_db()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM config_audio_equipment WHERE node_id=%s", (node_id,))
    conn.commit()
    publish_sync_event("config_audio_equipment")
    cursor.close()
    conn.close()

    flash("Audio configuration deleted", "warning")
    return redirect(request.referrer or '/')


# ------------------ COMPUTER CONFIG ------------------
@app.route('/config_computer/<int:node_id>', methods=['GET', 'POST'])
@login_required
def config_computer(node_id):

    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM Node WHERE node_id=%s",
        (node_id,)
    )
    node = cursor.fetchone()

    if not node or node['node_type'] != 'computer':
        cursor.close()
        conn.close()
        flash("This node is not of type 'Computer'", "danger")
        return redirect(url_for('index'))

    role = node.get("computer_role")

    cursor.execute(
        "SELECT room_id FROM Installation_Node WHERE node_id=%s",
        (node_id,)
    )
    row = cursor.fetchone()
    room_id = row['room_id'] if row else None

    cursor.execute(
        "SELECT * FROM config_computer WHERE node_id=%s",
        (node_id,)
    )
    config = cursor.fetchone()


    if request.method == 'POST':

        ip_address = request.form['ip_address']
        port_on = request.form.get('port_on')
        port_off = request.form.get('port_off')
        command_com_on = request.form.get('command_com_on')
        command_com_off = request.form.get('command_com_off')
        mqtt_broker = request.form.get('mqtt_broker')
        mqtt_port = request.form.get('mqtt_port')


        # ✅ สำคัญมาก สำหรับ Smart Classroom
        if role == "student":
            port_on = 0
            mqtt_broker = None
            mqtt_port = None


        if config:

            cursor.execute("""
                UPDATE config_computer
                SET ip_address=%s,
                    port_on=%s,
                    port_off=%s,
                    command_com_on=%s,
                    command_com_off=%s,
                    mqtt_broker=%s,
                    mqtt_port=%s
                WHERE node_id=%s
            """, (
                ip_address,
                port_on,
                port_off,
                command_com_on,
                command_com_off,
                mqtt_broker,
                mqtt_port,
                node_id
            ))

            flash("Computer configuration updated", "success")

        else:

            cursor.execute("""
                INSERT INTO config_computer
                (
                    node_id,
                    ip_address,
                    port_on,
                    port_off,
                    command_com_on,
                    command_com_off,
                    mqtt_broker,
                    mqtt_port
                )
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
            """, (
                node_id,
                ip_address,
                port_on,
                port_off,
                command_com_on,
                command_com_off,
                mqtt_broker,
                mqtt_port
            ))

            flash("Computer configuration added", "success")


        conn.commit()

        publish_sync_event("config_computer")

        cursor.close()
        conn.close()

        return redirect(
            url_for(
                'config_computer',
                node_id=node_id
            )
        )


    cursor.close()
    conn.close()

    return render_template(
        'computer_config.html',
        node=node,
        config=config,
        room_id=room_id,
        role=role
    )


@app.route('/config_computer/delete/<int:node_id>', methods=['POST'])
@login_required
def delete_computer_config(node_id):
    conn = connect_db()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM config_computer WHERE node_id=%s", (node_id,))
    conn.commit()
    publish_sync_event("config_computer")
    cursor.close()
    conn.close()

    flash("Computer configuration deleted", "warning")
    return redirect(request.referrer or '/')



# ---------------- DOOR CONFIG ----------------
@app.route('/config_door/<int:node_id>', methods=['GET', 'POST'])
@login_required
def config_door(node_id):
    conn = connect_db()
    cursor = conn.cursor(dictionary=True)

    # ดึง node จาก DB แทน cache
    cursor.execute("SELECT * FROM Node WHERE node_id=%s", (node_id,))
    node = cursor.fetchone()
    if not node or node['node_type'] != 'door':
        cursor.close()
        conn.close()
        flash("This node is not of type 'Door'", "danger")
        return redirect(url_for('index'))

    # ดึง room_id จาก Installation_Node
    cursor.execute("SELECT room_id FROM Installation_Node WHERE node_id=%s", (node_id,))
    row = cursor.fetchone()
    room_id = row['room_id'] if row else None

    # ดึง config จาก DB
    cursor.execute("SELECT * FROM config_door WHERE node_id=%s", (node_id,))
    config = cursor.fetchone()

    if request.method == 'POST':
        mqtt_broker = request.form['mqtt_broker']
        mqtt_port = request.form['mqtt_port']
        command_door_open = request.form['command_door_open']
        command_door_close = request.form['command_door_close']

        if config:
            cursor.execute("""
                UPDATE config_door 
                SET mqtt_broker=%s, mqtt_port=%s, command_door_open=%s, command_door_close=%s
                WHERE node_id=%s
            """, (mqtt_broker, mqtt_port, command_door_open, command_door_close, node_id))
            flash("Door configuration updated", "success")
        else:
            cursor.execute("""
                INSERT INTO config_door (node_id, mqtt_broker, mqtt_port, command_door_open, command_door_close)
                VALUES (%s,%s,%s,%s,%s)
            """, (node_id, mqtt_broker, mqtt_port, command_door_open, command_door_close))
            flash("Door configuration added", "success")

        conn.commit()
        publish_sync_event("config_door")
        cursor.close()
        conn.close()

        return redirect(url_for('config_door', node_id=node_id))

    cursor.close()
    conn.close()
    return render_template('door_config.html', node=node, config=config, room_id=room_id)


@app.route('/config_door/delete/<int:node_id>', methods=['POST'])
@login_required
def delete_door_config(node_id):
    conn = connect_db()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM config_door WHERE node_id=%s", (node_id,))
    conn.commit()
    publish_sync_event("config_door")
    cursor.close()
    conn.close()

    flash("Door configuration deleted", "warning")
    return redirect(request.referrer or '/')



    
if __name__ == '__main__':
    app.run(
        host='0.0.0.0',
        port=5000,
        debug=True
    )
