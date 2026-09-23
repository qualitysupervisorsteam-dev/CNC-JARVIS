from pathlib import Path
import sys

root = Path(__file__).resolve().parents[1]
required = [
    'pubspec.yaml', 'lib/main.dart', 'native/cad/CMakeLists.txt',
    'native/cad/include/cnc_cad.h', 'native/cad/src/cnc_cad.cpp',
    '.github/workflows/ci.yml', 'server/app/main.py', 'server/requirements.txt',
    'test/fixtures/box_20x20x20.step', 'test/fixtures/line_20mm.iges',
    'docs/CNC-JARVIS-Catalog-AR.pdf',
]
missing = [p for p in required if not (root / p).exists()]
if missing:
    print('Missing files:')
    for item in missing: print(' -', item)
    sys.exit(1)
print('CNC-JARVIS project structure: OK')
print('Root:', root)
