import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:cnc_jarvis/services/cad/cad_ffi.dart';

void main() {
  group('CadFfi', () {
    test('reports unsupported platform outside Windows', () {
      if (Platform.isWindows) return;
      expect(() => CadFfi.instance.load(), throwsUnsupportedError);
    });

    test('imports a real STEP fixture on Windows', () {
      if (!Platform.isWindows) return;
      final path = File('test/fixtures/box_20x20x20.step').absolute.path;
      final cad = CadFfi.instance;
      expect(cad.initialize(), 0);
      expect(cad.importStep(path), 0);
      expect(cad.bodyCount(), 1);
      expect(cad.solidCount(), 1);
      expect(cad.surfaceCount(), 6);
      expect(cad.tessellate(0.5), 0);
      final (vertexCount, triangleCount) = cad.meshCounts();
      expect(vertexCount, 8);
      expect(triangleCount, 12);
      final mesh = cad.exportMesh(vertexCount, triangleCount);
      expect(mesh.positions.length, 24);
      expect(mesh.indices.length, 36);
      cad.clear();
      expect(cad.bodyCount(), 0);
      cad.shutdown();
      expect(cad.isLoaded, isFalse);
    });

    test('imports a real IGES fixture on Windows', () {
      if (!Platform.isWindows) return;
      final path = File('test/fixtures/line_20mm.iges').absolute.path;
      final cad = CadFfi.instance;
      expect(cad.initialize(), 0);
      expect(cad.importIges(path), 0);
      expect(cad.solidCount(), 0);
      expect(cad.surfaceCount(), 0);
      cad.shutdown();
    });

    test('rejects a missing STEP file on Windows', () {
      if (!Platform.isWindows) return;
      final cad = CadFfi.instance;
      expect(cad.initialize(), 0);
      expect(cad.importStep('this_file_does_not_exist.step'), isNot(0));
      cad.shutdown();
    });
  });
}
