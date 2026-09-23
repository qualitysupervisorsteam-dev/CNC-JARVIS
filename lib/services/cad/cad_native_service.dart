import '../../models/cad_mesh.dart';
import '../../models/engineering_model.dart';
import '../../models/geometry_model.dart';
import '../../models/geometry_source.dart';
import '../../models/geometry_status.dart';
import 'cad_ffi.dart';

class CadNativeService {
  const CadNativeService();

  CadFfi get _cad => CadFfi.instance;

  Future<void> initialize() async {
    _cad.load();

    final result = _cad.initialize();

    if (result != 0) {
      throw StateError(
        'Native CAD initialization failed. '
        'Error code: $result',
      );
    }
  }

  Future<GeometryModel> importSource(
    GeometrySource source, {
    EngineeringModel? engineeringModel,
  }) async {
    if (source.path.trim().isEmpty) {
      throw ArgumentError(
        'Geometry source path cannot be empty.',
      );
    }

    switch (source.format) {
      case GeometrySourceFormat.step:
        return importStep(
          source.path,
          engineeringModel: engineeringModel,
        );

      case GeometrySourceFormat.iges:
        return importIges(
          source.path,
          engineeringModel: engineeringModel,
        );

      case GeometrySourceFormat.stl:
      case GeometrySourceFormat.dxf:
      case GeometrySourceFormat.dwg:
      case GeometrySourceFormat.pdf:
      case GeometrySourceFormat.image:
        throw UnsupportedError(
          'Geometry format ${source.extension} '
          'is not supported by the native CAD '
          'engine yet.',
        );
    }
  }

  Future<GeometryModel> importStep(
    String path, {
    EngineeringModel? engineeringModel,
  }) async {
    if (path.trim().isEmpty) {
      throw ArgumentError(
        'STEP file path cannot be empty.',
      );
    }

    await initialize();

    final result = _cad.importStep(
      path.trim(),
    );

    if (result != 0) {
      throw StateError(
        'Native STEP import failed. '
        'Error code: $result',
      );
    }

    return _buildGeometryModel(
      path: path.trim(),
      engineeringModel: engineeringModel,
      format: 'STEP',
    );
  }

  Future<GeometryModel> importIges(
    String path, {
    EngineeringModel? engineeringModel,
  }) async {
    if (path.trim().isEmpty) {
      throw ArgumentError(
        'IGES file path cannot be empty.',
      );
    }

    await initialize();

    final result = _cad.importIges(
      path.trim(),
    );

    if (result != 0) {
      throw StateError(
        'Native IGES import failed. '
        'Error code: $result',
      );
    }

    return _buildGeometryModel(
      path: path.trim(),
      engineeringModel: engineeringModel,
      format: 'IGES',
    );
  }

  Future<CadMesh> getMesh({double deflection = 0.5}) async {
    await initialize();
    final result = _cad.tessellate(deflection);
    if (result != 0) {
      throw StateError('Native tessellation failed. Error code: $result');
    }
    final (vertexCount, triangleCount) = _cad.meshCounts();
    final mesh = _cad.exportMesh(vertexCount, triangleCount);
    return CadMesh(positions: mesh.positions, indices: mesh.indices);
  }

  Future<void> clear() async {
    if (!_cad.isLoaded) {
      return;
    }

    _cad.clear();
  }

  Future<void> dispose() async {
    if (!_cad.isLoaded) {
      return;
    }

    _cad.shutdown();
  }

  GeometryModel _buildGeometryModel({
    required String path,
    required String format,
    EngineeringModel? engineeringModel,
  }) {
    final bodyCount = _cad.bodyCount();
    final solidCount = _cad.solidCount();
    final surfaceCount = _cad.surfaceCount();

    final name =
        engineeringModel?.name ??
        _fileNameFromPath(path);

    final confidence =
        engineeringModel?.confidence ??
        1.0;

    return GeometryModel(
      id: engineeringModel != null
          ? 'GEO-${engineeringModel.id}'
          : 'GEO-NATIVE-'
              '${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      status: GeometryStatus.ready,
      geometryFormat: format,
      geometryPath: path,
      bodyCount: bodyCount,
      solidCount: solidCount,
      surfaceCount: surfaceCount,
      confidence: confidence,
      hasSolidGeometry: solidCount > 0,
      verified: true,
      note:
          'Geometry imported through the native CAD bridge.',
    );
  }

  String _fileNameFromPath(
    String path,
  ) {
    final normalizedPath =
        path.replaceAll('\\', '/');

    final separatorIndex =
        normalizedPath.lastIndexOf('/');

    if (separatorIndex < 0) {
      return normalizedPath;
    }

    return normalizedPath.substring(
      separatorIndex + 1,
    );
  }
}
