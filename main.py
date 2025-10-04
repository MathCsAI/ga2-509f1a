from fastapi import FastAPI
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from fastapi.responses import Response
import time

app = FastAPI(title="deployment-ready-ga2-509f1a Observability API")

REQUESTS = Counter("deployment_requests_total", "Total requests")
start_time = time.time()

@app.get("/")
def root():
    REQUESTS.inc()
    return {"status": "ok", "service": "deployment-ready-ga2-509f1a"}

@app.get("/health")
def health():
    return {"status": "healthy", "uptime_seconds": int(time.time() - start_time)}

@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
