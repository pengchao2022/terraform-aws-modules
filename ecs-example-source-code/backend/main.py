import os
import pymysql
import boto3
import traceback
from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from typing import Optional

app = FastAPI()

# --- 配置参数 ---
DB_HOST = os.getenv("DB_HOST", "web-server-prod-db-instance.c6jyq0ka0zqf.us-east-1.rds.amazonaws.com")
DB_PORT = int(os.getenv("DB_PORT", 3306))
DB_USER = os.getenv("DB_USER", "iam_gopay_user")
DB_NAME = os.getenv("DB_NAME", "gopay_web_db")
AWS_REGION = os.getenv("AWS_REGION", "us-east-1")

# 初始化 RDS 客户端
session = boto3.Session(region_name=AWS_REGION)
rds_client = session.client("rds")

def get_db_connection():
    token = rds_client.generate_db_auth_token(
        DBHostname=DB_HOST, Port=DB_PORT, DBUsername=DB_USER, Region=AWS_REGION
    )
    return pymysql.connect(
        host=DB_HOST, port=DB_PORT, user=DB_USER, password=token,
        database=DB_NAME, ssl={'ssl': True}, connect_timeout=10,
        cursorclass=pymysql.cursors.DictCursor
    )

# --- 数据模型 ---
class TodoItem(BaseModel):
    task: str

class TodoUpdate(BaseModel):
    task: str

# --- 接口逻辑 ---

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.on_event("startup")
def startup_event():
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS todos (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    task VARCHAR(255) NOT NULL
                )
            """)
        connection.commit()
    finally:
        connection.close()

# 查 (Read)
@app.get("/api/todos")
def get_todos():
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT id, task FROM todos ORDER BY id DESC")
            return cursor.fetchall()
    finally:
        connection.close()

# 增 (Create)
@app.post("/api/todos")
def add_todo(todo: TodoItem):
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("INSERT INTO todos (task) VALUES (%s)", (todo.task,))
        connection.commit()
        return {"status": "success"}
    finally:
        connection.close()

# 改 (Update)
@app.put("/api/todos/{todo_id}")
def update_todo(todo_id: int, todo: TodoUpdate):
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            affected = cursor.execute("UPDATE todos SET task = %s WHERE id = %s", (todo.task, todo_id))
            if affected == 0:
                raise HTTPException(status_code=404, detail="Task not found")
        connection.commit()
        return {"status": "success"}
    finally:
        connection.close()

# 删 (Delete)
@app.delete("/api/todos/{todo_id}")
def delete_todo(todo_id: int):
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            affected = cursor.execute("DELETE FROM todos WHERE id = %s", (todo_id,))
            if affected == 0:
                raise HTTPException(status_code=404, detail="Task not found")
        connection.commit()
        return {"status": "success"}
    finally:
        connection.close()

@app.get("/", response_class=HTMLResponse)
def read_index():
    html_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "templates", "index.html")
    with open(html_path, "r", encoding="utf-8") as f:
        return f.read()