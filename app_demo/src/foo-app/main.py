from fastapi import FastAPI
from fastapi.responses import JSONResponse
import time

app = FastAPI()

@app.get("/health/liveness")
def liveness_probe():
    return JSONResponse(content={"status": "alive"})

@app.get("/health/readiness")
def readiness_probe():
    return JSONResponse(content={"status": "ready"})

@app.get("/foo")
def get_foo():
    time.sleep(0.2)  # Simulates work
    return JSONResponse(content={"result": "bar"})