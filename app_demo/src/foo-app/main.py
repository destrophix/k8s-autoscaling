from fastapi import FastAPI
from fastapi.responses import JSONResponse

app = FastAPI()

@app.get("/health/liveness")
def liveness_probe():
    return JSONResponse(content={"status": "alive"})

@app.get("/health/readiness")
def readiness_probe():
    return JSONResponse(content={"status": "ready"})

@app.get("/foo")
def get_foo():
    return JSONResponse(content={"result": "bar"})