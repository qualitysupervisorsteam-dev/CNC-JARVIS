import 'package:flutter_test/flutter_test.dart';

import 'package:cnc_jarvis/models/engineering_dimension.dart';
import 'package:cnc_jarvis/models/engineering_feature.dart';
import 'package:cnc_jarvis/models/engineering_hole.dart';
import 'package:cnc_jarvis/models/engineering_material.dart';
import 'package:cnc_jarvis/models/engineering_model.dart';
import 'package:cnc_jarvis/models/engineering_thread.dart';
import 'package:cnc_jarvis/models/engineering_tolerance.dart';

void main() {
  group('Engineering Dimension', () {
    test('source dimension does not require verification', () {
      const dimension = EngineeringDimension(
        id: 'D1',
        value: 50,
        unit: 'mm',
        type: DimensionType.linear,
        source: DimensionSource.source,
        confidence: 1.0,
      );

      expect(dimension.isSource, true);
      expect(dimension.requiresVerification, false);
    });

    test('estimated dimension requires verification', () {
      const dimension = EngineeringDimension(
        id: 'D2',
        value: 25,
        unit: 'mm',
        type: DimensionType.diameter,
        source: DimensionSource.estimated,
        confidence: 0.95,
      );

      expect(dimension.isEstimated, true);
      expect(dimension.requiresVerification, true);
    });

    test('low confidence dimension requires verification', () {
      const dimension = EngineeringDimension(
        id: 'D3',
        value: 10,
        unit: 'mm',
        type: DimensionType.radius,
        source: DimensionSource.source,
        confidence: 0.70,
      );

      expect(dimension.requiresVerification, true);
    });
  });

  group('Engineering Hole', () {
    test('threaded hole is detected correctly', () {
      const hole = EngineeringHole(
        id: 'H1',
        diameter: 10,
        depth: 20,
        type: HoleType.threaded,
        source: HoleSource.source,
        confidence: 1.0,
        threadSpecification: 'M10 x 1.5',
      );

      expect(hole.hasDiameter, true);
      expect(hole.hasDepth, true);
      expect(hole.isThreaded, true);
      expect(hole.requiresVerification, false);
    });
  });

  group('Engineering Thread', () {
    test('metric internal thread is detected', () {
      const thread = EngineeringThread(
        id: 'T1',
        standard: ThreadStandard.metric,
        type: ThreadType.internal,
        designation: 'M10 x 1.5',
        nominalDiameter: 10,
        pitch: 1.5,
        source: ThreadSource.source,
        confidence: 1.0,
      );

      expect(thread.isMetric, true);
      expect(thread.isInternal, true);
      expect(thread.isSource, true);
      expect(thread.requiresVerification, false);
    });
  });

  group('Engineering Tolerance', () {
    test('bilateral tolerance is detected', () {
      const tolerance = EngineeringTolerance(
        id: 'TOL1',
        type: ToleranceType.bilateral,
        upper: 0.05,
        lower: -0.05,
        source: ToleranceSource.source,
        confidence: 1.0,
      );

      expect(tolerance.isBilateral, true);
      expect(tolerance.hasUpper, true);
      expect(tolerance.hasLower, true);
      expect(tolerance.requiresVerification, false);
    });
  });

  group('Engineering Material', () {
    test('material with grade is detected', () {
      const material = EngineeringMaterial(
        name: 'Steel',
        standard: 'EN',
        grade: 'S355',
        source: MaterialSource.source,
        confidence: 1.0,
      );

      expect(material.hasStandard, true);
      expect(material.hasGrade, true);
      expect(material.isSource, true);
      expect(material.requiresVerification, false);
    });
  });

  group('Engineering Feature', () {
    test('hole feature is detected', () {
      const feature = EngineeringFeature(
        id: 'F1',
        type: EngineeringFeatureType.hole,
        source: FeatureSource.source,
        confidence: 1.0,
      );

      expect(feature.isHole, true);
      expect(feature.isSource, true);
      expect(feature.requiresVerification, false);
    });
  });

  group('Engineering Model', () {
    test('verified engineering model does not require verification', () {
      const model = EngineeringModel(
        id: 'MODEL1',
        name: 'Test Part',
        confidence: 1.0,
        geometryReady: true,
        verified: true,
      );

      expect(model.hasGeometry, true);
      expect(model.requiresVerification, false);
    });

    test('model containing estimated data requires verification', () {
      const dimension = EngineeringDimension(
        id: 'D1',
        value: 40,
        unit: 'mm',
        type: DimensionType.linear,
        source: DimensionSource.estimated,
        confidence: 0.95,
      );

      const model = EngineeringModel(
        id: 'MODEL2',
        name: 'Estimated Part',
        dimensions: [
          dimension,
        ],
        confidence: 0.95,
        geometryReady: true,
        verified: false,
      );

      expect(model.hasDimensions, true);
      expect(model.requiresVerification, true);
    });
  });
}
