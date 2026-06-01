import os
import uuid
import time

from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional

from sqlalchemy import create_engine, Column, String, Boolean, BigInteger
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker

# -------------------------------------------------------
# Database connection
# Read credentials from environment variables (set in ECS task definition)
# -------------------------------------------------------
DB_HOST     = os.environ.get("DB_HOST", "localhost")
DB_PORT     = os.environ.get("DB_PORT", "5432")
DB_NAME     = os.environ.get("DB_NAME", "taskdb")
DB_USER     = os.environ.get("DB_USER", "taskadmin")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "")

DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# -------------------------------------------------------
# ORM Model
# -------------------------------------------------------
class Base(DeclarativeBase):
    pass

class TaskModel(Base):
    __tablename__ = "tasks"

    id          = Column(String, primary_key=True, index=True)
    title       = Column(String, nullable=False)
    description = Column(String, default="")
    completed   = Column(Boolean, default=False)
    created_at  = Column(BigInteger, default=lambda: int(time.time()))

# Create tables on startup
Base.metadata.create_all(bind=engine)

# -------------------------------------------------------
# FastAPI app
# -------------------------------------------------------
app = FastAPI(title="Task Manager API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# -------------------------------------------------------
# DB session dependency
# -------------------------------------------------------
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# -------------------------------------------------------
# Schemas
# -------------------------------------------------------
class TaskCreate(BaseModel):
    title: str
    description: Optional[str] = ""

class TaskUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    completed: Optional[bool] = None

class TaskResponse(BaseModel):
    id: str
    title: str
    description: str
    completed: bool
    created_at: int

    class Config:
        from_attributes = True

# -------------------------------------------------------
# Routes
# -------------------------------------------------------
@app.get("/")
def health_check():
    return {"status": "ok", "message": "Task Manager API is running"}


@app.get("/tasks", response_model=list[TaskResponse])
def list_tasks(db: Session = Depends(get_db)):
    return db.query(TaskModel).all()


@app.post("/tasks", response_model=TaskResponse, status_code=201)
def create_task(body: TaskCreate, db: Session = Depends(get_db)):
    task = TaskModel(
        id          = str(uuid.uuid4()),
        title       = body.title,
        description = body.description,
        completed   = False,
        created_at  = int(time.time()),
    )
    db.add(task)
    db.commit()
    db.refresh(task)
    return task


@app.get("/tasks/{task_id}", response_model=TaskResponse)
def get_task(task_id: str, db: Session = Depends(get_db)):
    task = db.query(TaskModel).filter(TaskModel.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    return task


@app.put("/tasks/{task_id}", response_model=TaskResponse)
def update_task(task_id: str, body: TaskUpdate, db: Session = Depends(get_db)):
    task = db.query(TaskModel).filter(TaskModel.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    if body.title is not None:
        task.title = body.title
    if body.description is not None:
        task.description = body.description
    if body.completed is not None:
        task.completed = body.completed
    db.commit()
    db.refresh(task)
    return task


@app.delete("/tasks/{task_id}", status_code=204)
def delete_task(task_id: str, db: Session = Depends(get_db)):
    task = db.query(TaskModel).filter(TaskModel.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    db.delete(task)
    db.commit()
