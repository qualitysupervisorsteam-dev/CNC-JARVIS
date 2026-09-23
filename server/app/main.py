from __future__ import annotations

import hashlib
import os
import shutil
import uuid
from pathlib import Path
from typing import Annotated

from fastapi import FastAPI, File, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
UPLOADS = DATA / "uploads"
UPLOADS.mkdir(parents=True, exist_ok=True)
MAX_UPLOAD_BYTES = int(os.getenv("MAX_UPLOAD_BYTES", str(50 * 1024 * 1024)))

app = FastAPI(title="CNC-JARVIS API", version="0.2.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=[x.strip() for x in os.getenv("CORS_ORIGINS", "*").split(",")],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

SUPPORTED = {"pdf", "png", "jpg", "jpeg", "webp", "dxf", "dwg", "step", "stp", "iges", "igs"}


def extension(name: str) -> str:
    return Path(name).suffix.lower().lstrip(".")


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "service": "cnc-jarvis-api", "version": app.version}


@app.get("/api/v1/capabilities")
def capabilities() -> dict:
    return {
        "formats": sorted(SUPPORTED),
        "native_cad": "windows-client",
        "analysis": "local-registry-plus-server-ready",
        "storage": "local-filesystem",
    }


@app.post("/api/v1/files")
async def upload_file(file: Annotated[UploadFile, File(...)]) -> dict:
    ext = extension(file.filename or "")
    if ext not in SUPPORTED:
        raise HTTPException(status_code=415, detail=f"Unsupported format: {ext or 'unknown'}")

    file_id = uuid.uuid4().hex
    destination = UPLOADS / f"{file_id}.{ext}"
    total = 0
    sha = hashlib.sha256()
    try:
        with destination.open("wb") as output:
            while True:
                chunk = await file.read(1024 * 1024)
                if not chunk:
                    break
                total += len(chunk)
                if total > MAX_UPLOAD_BYTES:
                    raise HTTPException(status_code=413, detail="File exceeds MAX_UPLOAD_BYTES")
                sha.update(chunk)
                output.write(chunk)
    except Exception:
        destination.unlink(missing_ok=True)
        raise

    return {
        "id": file_id,
        "name": file.filename,
        "extension": ext,
        "size": total,
        "sha256": sha.hexdigest(),
        "status": "stored",
    }


@app.post("/api/v1/analyze/{file_id}")
def analyze(file_id: str) -> dict:
    matches = list(UPLOADS.glob(f"{file_id}.*"))
    if not matches:
        raise HTTPException(status_code=404, detail="File not found")
    path = matches[0]
    ext = extension(path.name)
    direct_cad = ext in {"step", "stp", "iges", "igs"}
    return {
        "file_id": file_id,
        "status": "accepted",
        "format": ext.upper(),
        "native_geometry": direct_cad,
        "message": "Direct CAD geometry is processed by the Windows OpenCASCADE client; server analysis endpoint is the integration seam for future AI/document services.",
    }
