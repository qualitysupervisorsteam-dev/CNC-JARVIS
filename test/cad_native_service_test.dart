import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:cnc_jarvis/services/cad/cad_native_service.dart';

void main() {
  group('CadNativeService', () {
    test('can initialize native CAD on Windows', () async {
      if (!Platform.isWindows) return;
      const service = CadNativeService();
      await service.initialize();
      await service.dispose();
    });

    test('imports STEP fixture through native CAD', () async {
      if (!Platform.isWindows) return;
      const service = CadNativeService();
      final path = File('test/fixtures/box_20x20x20.step').absolute.path;
      final geometry = await service.importStep(path);
      expect(geometry.geometryFormat, 'STEP');
      expect(geometry.bodyCount, 1);
      expect(geometry.solidCount, 1);
      expect(geometry.surfaceCount, 6);
      expect(geometry.hasSolidGeometry, isTrue);
      expect(geometry.verified, isTrue);
      final mesh = await service.getMesh();
      expect(mesh.vertexCount, 8);
      expect(mesh.triangleCount, 12);
      await service.dispose();
    });

    test('imports IGES fixture through native CAD', () async {
      if (!Platform.isWindows) return;
      const service = CadNativeService();
      final path = File('test/fixtures/line_20mm.iges').absolute.path;
      final geometry = await service.importIges(path);
      expect(geometry.geometryFormat, 'IGES');
      expect(geometry.verified, isTrue);
      expect(geometry.hasSolidGeometry, isFalse);
      await service.dispose();
    });

    test('rejects empty paths', () async {
      if (!Platform.isWindows) return;
      const service = CadNativeService();
      expect(() => service.importStep(''), throwsArgumentError);
      expect(() => service.importIges(''), throwsArgumentError);
    });
  });
}
