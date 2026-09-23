import 'engineering_dimension.dart';
import 'engineering_feature.dart';
import 'engineering_hole.dart';
import 'engineering_material.dart';
import 'engineering_thread.dart';
import 'engineering_tolerance.dart';

class EngineeringModel {
  final String id;
  final String name;

  final List<EngineeringDimension> dimensions;
  final List<EngineeringHole> holes;
  final List<EngineeringThread> threads;
  final List<EngineeringTolerance> tolerances;
  final List<EngineeringMaterial> materials;
  final List<EngineeringFeature> features;

  final double confidence;

  final bool geometryReady;
  final bool verified;

  final String? unitSystem;
  final String? note;

  const EngineeringModel({
    required this.id,
    required this.name,
    this.dimensions = const [],
    this.holes = const [],
    this.threads = const [],
    this.tolerances = const [],
    this.materials = const [],
    this.features = const [],
    this.confidence = 0,
    this.geometryReady = false,
    this.verified = false,
    this.unitSystem,
    this.note,
  });

  bool get hasDimensions =>
      dimensions.isNotEmpty;

  bool get hasHoles =>
      holes.isNotEmpty;

  bool get hasThreads =>
      threads.isNotEmpty;

  bool get hasTolerances =>
      tolerances.isNotEmpty;

  bool get hasMaterials =>
      materials.isNotEmpty;

  bool get hasFeatures =>
      features.isNotEmpty;

  bool get hasGeometry =>
      geometryReady;

  bool get requiresVerification =>
      !verified ||
      dimensions.any(
        (dimension) => dimension.requiresVerification,
      ) ||
      holes.any(
        (hole) => hole.requiresVerification,
      ) ||
      threads.any(
        (thread) => thread.requiresVerification,
      ) ||
      tolerances.any(
        (tolerance) => tolerance.requiresVerification,
      ) ||
      materials.any(
        (material) => material.requiresVerification,
      ) ||
      features.any(
        (feature) => feature.requiresVerification,
      );
}
