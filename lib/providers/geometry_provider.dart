import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/engineering_model.dart';
import '../models/geometry_model.dart';
import '../models/geometry_status.dart';
import '../services/geometry/geometry_service.dart';

class GeometryNotifier
    extends Notifier<GeometryModel?> {
  final GeometryService _service =
      GeometryService();

  @override
  GeometryModel? build() {
    return null;
  }

  Future<void> buildFromEngineeringModel(
    EngineeringModel engineeringModel,
  ) async {
    state = GeometryModel(
      id: 'GEO-${engineeringModel.id}',
      name: engineeringModel.name,
      status: GeometryStatus.preparing,
      confidence: engineeringModel.confidence,
      verified: false,
    );

    try {
      state = GeometryModel(
        id: 'GEO-${engineeringModel.id}',
        name: engineeringModel.name,
        status: GeometryStatus.building,
        confidence: engineeringModel.confidence,
        verified: false,
      );

      final result =
          await _service.buildGeometry(
        engineeringModel,
      );

      state = result;
    } catch (error) {
      state = GeometryModel(
        id: 'GEO-${engineeringModel.id}',
        name: engineeringModel.name,
        status: GeometryStatus.failed,
        confidence: engineeringModel.confidence,
        verified: false,
        errorMessage: error.toString(),
      );
    }
  }

  void setGeometry(
    GeometryModel geometry,
  ) {
    state = geometry;
  }

  void updateGeometry(
    GeometryModel geometry,
  ) {
    state = geometry;
  }

  void setStatus(
    GeometryStatus status,
  ) {
    final current = state;

    if (current == null) {
      return;
    }

    state = GeometryModel(
      id: current.id,
      name: current.name,
      status: status,
      geometryFormat: current.geometryFormat,
      geometryPath: current.geometryPath,
      bodyCount: current.bodyCount,
      solidCount: current.solidCount,
      surfaceCount: current.surfaceCount,
      confidence: current.confidence,
      hasSolidGeometry: current.hasSolidGeometry,
      verified: current.verified,
      errorMessage: current.errorMessage,
      note: current.note,
    );
  }

  void clearGeometry() {
    state = null;
  }
}

final geometryProvider =
    NotifierProvider<
        GeometryNotifier,
        GeometryModel?>(
  GeometryNotifier.new,
);
