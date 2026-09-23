# CNC-JARVIS

CNC-JARVIS is a Flutter engineering workspace with a Windows-native OpenCASCADE bridge, a cross-platform Flutter UI, an Android release target, and a small HTTP backend integration seam.

## What is included

- Flutter application: engineering workspace, project state, drawing-file selection, analysis registry, geometry state and 3D mesh viewer.
- Windows native CAD: C++17 + OpenCASCADE for STEP/IGES import, topology counts and tessellation exported through Dart FFI.
- Android: release APK and AAB builds. The Android UI is fully buildable; the OpenCASCADE DLL bridge is intentionally Windows-only in this release.
- Backend: FastAPI service for health, capability discovery, upload storage and analysis-job integration.
- CI/CD: one authoritative GitHub Actions workflow that builds/tests Flutter, builds Windows + native CAD, builds Android APK/AAB, tests the backend, and can publish tagged releases.
- Fixtures: deterministic STEP cube and IGES line fixtures for native CAD tests.
- Arabic project catalog: `docs/CNC-JARVIS-Catalog-AR.pdf`.

## Architecture

```text
Flutter UI
   |
   +-- Riverpod state
   |
   +-- local analyzers / geometry services
   |
   +-- Windows Dart FFI --------------------+
                                            |
                                      cnc_cad.dll
                                            |
                                      OpenCASCADE 8.0.1
                                            |
                                      STEP / IGES

Flutter app --------------------> FastAPI backend
                                      |
                                      +-- uploads
                                      +-- capabilities
                                      +-- analysis integration seam
```

## Repository layout

- `lib/` Flutter application code.
- `native/cad/` C++ OpenCASCADE bridge.
- `test/` Dart tests and CAD fixtures.
- `server/` FastAPI backend and tests.
- `.github/workflows/ci.yml` complete CI/CD pipeline.
- `tool/generate_fixtures.py` regenerates deterministic CAD fixtures.
- `docs/` project documentation and catalog.

## GitHub usage

1. Create a new repository.
2. Upload the **contents of this ZIP** so that `pubspec.yaml`, `lib/`, `test/`, `.github/` and `server/` are at repository root.
3. Commit to `main`.
4. Open **Actions** and run `CNC-JARVIS CI`.
5. Download `CNC-JARVIS-Windows-x64`, `CNC-JARVIS-Android-APK` or `CNC-JARVIS-Android-AAB` from the workflow artifacts.

The workflow generates Flutter platform scaffolding only when the platform folder is missing, so the Dart package name remains the valid `cnc_jarvis` identifier.

## Windows CAD pipeline

The workflow pins the OCCT 8.0.1 combined Windows release asset instead of querying the mutable `latest` API. It locates `Standard.hxx`, `TKernel.lib` and `TKernel.dll`, configures CMake with the actual SDK root, builds `cnc_cad.dll`, runs native tests, stages runtime DLLs, and then builds the Flutter Windows release.

OCCT 8.0.1 is the current upstream maintenance release used by this project. See the official release assets in the Open-Cascade-SAS/OCCT repository.

## Android

Android builds are produced as both APK and AAB. The native OpenCASCADE bridge is not loaded on Android; STEP/IGES native geometry is therefore a Windows capability in this release. The backend seam is present so a future server-side CAD service can be connected without redesigning the Flutter state model.

## Backend

Run locally:

```bash
cd server
python -m pip install -r requirements.txt
python -m uvicorn app.main:app --reload --port 8080
```

Or:

```bash
docker compose up --build
```

Health endpoint: `GET /health`.

## Important release note

This package is structured to be uploaded directly to a new GitHub repository and to build through Actions. The environment used to assemble this ZIP does not contain the Flutter SDK, so a local Flutter build was not executed here. The CI workflow is the authoritative build/test environment.

GitHub Actions still requires the account/repository billing state to permit hosted runners. If GitHub blocks a run before a job starts, that is an account billing/usage setting rather than a repository-code failure.
