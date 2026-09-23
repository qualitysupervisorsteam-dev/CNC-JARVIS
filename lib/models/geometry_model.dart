import 'geometry_status.dart';

class GeometryModel {
  final String id;
  final String name;

  final GeometryStatus status;

  final String? geometryFormat;
  final String? geometryPath;

  final int bodyCount;
  final int solidCount;
  final int surfaceCount;

  final double confidence;

  final bool hasSolidGeometry;
  final bool verified;

  final String? errorMessage;
  final String? note;

  const GeometryModel({
    required this.id,
    required this.name,
    this.status = GeometryStatus.idle,
    this.geometryFormat,
    this.geometryPath,
    this.bodyCount = 0,
    this.solidCount = 0,
    this.surfaceCount = 0,
    this.confidence = 0,
    this.hasSolidGeometry = false,
    this.verified = false,
    this.errorMessage,
    this.note,
  });

  bool get isIdle =>
      status == GeometryStatus.idle;

  bool get isPreparing =>
      status == GeometryStatus.preparing;

  bool get isBuilding =>
      status == GeometryStatus.building;

  bool get isReady =>
      status == GeometryStatus.ready;

  bool get hasFailed =>
      status == GeometryStatus.failed;

  bool get hasGeometry =>
      hasSolidGeometry ||
      solidCount > 0;

  bool get requiresVerification =>
      !verified ||
      confidence < 0.8;

  bool get hasError =>
      errorMessage != null &&
      errorMessage!.isNotEmpty;
}
