import 'package:flutter_test/flutter_test.dart';

import 'package:cnc_jarvis/models/geometry_source.dart';

void main() {
  group(
    'GeometrySource',
    () {
      test(
        'identifies STEP as a direct CAD format',
        () {
          const source = GeometrySource(
            path: 'part.step',
            format: GeometrySourceFormat.step,
          );

          expect(
            source.isStep,
            isTrue,
          );

          expect(
            source.isIges,
            isFalse,
          );

          expect(
            source.isDirectCadFormat,
            isTrue,
          );

          expect(
            source.isDrawingFormat,
            isFalse,
          );

          expect(
            source.extension,
            'step',
          );
        },
      );

      test(
        'identifies IGES as a direct CAD format',
        () {
          const source = GeometrySource(
            path: 'part.iges',
            format: GeometrySourceFormat.iges,
          );

          expect(
            source.isStep,
            isFalse,
          );

          expect(
            source.isIges,
            isTrue,
          );

          expect(
            source.isDirectCadFormat,
            isTrue,
          );

          expect(
            source.extension,
            'iges',
          );
        },
      );

      test(
        'identifies PDF as a drawing format',
        () {
          const source = GeometrySource(
            path: 'drawing.pdf',
            format: GeometrySourceFormat.pdf,
          );

          expect(
            source.isDirectCadFormat,
            isFalse,
          );

          expect(
            source.isDrawingFormat,
            isTrue,
          );

          expect(
            source.extension,
            'pdf',
          );
        },
      );

      test(
        'identifies DXF as a drawing format',
        () {
          const source = GeometrySource(
            path: 'drawing.dxf',
            format: GeometrySourceFormat.dxf,
          );

          expect(
            source.isDrawingFormat,
            isTrue,
          );

          expect(
            source.extension,
            'dxf',
          );
        },
      );

      test(
        'identifies DWG as a drawing format',
        () {
          const source = GeometrySource(
            path: 'drawing.dwg',
            format: GeometrySourceFormat.dwg,
          );

          expect(
            source.isDrawingFormat,
            isTrue,
          );

          expect(
            source.extension,
            'dwg',
          );
        },
      );

      test(
        'identifies image as a drawing format',
        () {
          const source = GeometrySource(
            path: 'drawing.png',
            format: GeometrySourceFormat.image,
          );

          expect(
            source.isDrawingFormat,
            isTrue,
          );

          expect(
            source.extension,
            'image',
          );
        },
      );
    },
  );
}
