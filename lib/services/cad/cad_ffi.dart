import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

typedef _InitializeNative = Int32 Function();
typedef _InitializeDart = int Function();

typedef _ImportNative = Int32 Function(
  Pointer<Utf8> path,
);
typedef _ImportDart = int Function(
  Pointer<Utf8> path,
);

typedef _CountNative = Int32 Function();
typedef _CountDart = int Function();

typedef _ClearNative = Void Function();
typedef _ClearDart = void Function();

typedef _ShutdownNative = Void Function();
typedef _ShutdownDart = void Function();

typedef _TessellateNative = Int32 Function(Double deflection);
typedef _TessellateDart = int Function(double deflection);

typedef _MeshCountsNative = Int32 Function(
  Pointer<Int32> vertexCount,
  Pointer<Int32> triangleCount,
);
typedef _MeshCountsDart = int Function(
  Pointer<Int32> vertexCount,
  Pointer<Int32> triangleCount,
);

typedef _ExportMeshNative = Int32 Function(
  Pointer<Float> positions,
  Int32 positionCapacity,
  Pointer<Int32> indices,
  Int32 indexCapacity,
);
typedef _ExportMeshDart = int Function(
  Pointer<Float> positions,
  int positionCapacity,
  Pointer<Int32> indices,
  int indexCapacity,
);

class CadFfi {
  CadFfi._();

  static final CadFfi instance = CadFfi._();

  _InitializeDart? _initialize;
  _ImportDart? _importStep;
  _ImportDart? _importIges;

  _CountDart? _bodyCount;
  _CountDart? _solidCount;
  _CountDart? _surfaceCount;

  _ClearDart? _clear;
  _ShutdownDart? _shutdown;
  _TessellateDart? _tessellate;
  _MeshCountsDart? _meshCounts;
  _ExportMeshDart? _exportMesh;

  bool _loaded = false;

  bool get isLoaded => _loaded;

  void load() {
    if (_loaded) {
      return;
    }

    if (!Platform.isWindows) {
      throw UnsupportedError(
        'CNC CAD FFI is currently available on Windows only.',
      );
    }

    final library = _openLibrary();

    _initialize = library
        .lookupFunction<
            _InitializeNative,
            _InitializeDart>(
      'cnc_cad_initialize',
    );

    _importStep = library
        .lookupFunction<
            _ImportNative,
            _ImportDart>(
      'cnc_cad_import_step',
    );

    _importIges = library
        .lookupFunction<
            _ImportNative,
            _ImportDart>(
      'cnc_cad_import_iges',
    );

    _bodyCount = library
        .lookupFunction<
            _CountNative,
            _CountDart>(
      'cnc_cad_body_count',
    );

    _solidCount = library
        .lookupFunction<
            _CountNative,
            _CountDart>(
      'cnc_cad_solid_count',
    );

    _surfaceCount = library
        .lookupFunction<
            _CountNative,
            _CountDart>(
      'cnc_cad_surface_count',
    );

    _clear = library
        .lookupFunction<
            _ClearNative,
            _ClearDart>(
      'cnc_cad_clear',
    );

    _shutdown = library.lookupFunction<_ShutdownNative, _ShutdownDart>(
      'cnc_cad_shutdown',
    );
    _tessellate = library.lookupFunction<_TessellateNative, _TessellateDart>(
      'cnc_cad_tessellate',
    );
    _meshCounts = library.lookupFunction<_MeshCountsNative, _MeshCountsDart>(
      'cnc_cad_mesh_counts',
    );
    _exportMesh = library.lookupFunction<_ExportMeshNative, _ExportMeshDart>(
      'cnc_cad_export_mesh',
    );

    _loaded = true;
  }

  DynamicLibrary _openLibrary() {
    final candidates = <String>[
      'cnc_cad.dll',
      '${Directory.current.path}${Platform.pathSeparator}'
          'build${Platform.pathSeparator}'
          'windows${Platform.pathSeparator}'
          'runner${Platform.pathSeparator}'
          'Release${Platform.pathSeparator}'
          'cnc_cad.dll',
      '${Directory.current.path}${Platform.pathSeparator}'
          'native${Platform.pathSeparator}'
          'cad${Platform.pathSeparator}'
          'build${Platform.pathSeparator}'
          'Release${Platform.pathSeparator}'
          'cnc_cad.dll',
    ];

    for (final candidate in candidates) {
      if (candidate == 'cnc_cad.dll') {
        try {
          return DynamicLibrary.open(
            candidate,
          );
        } on ArgumentError {
          continue;
        } on Object {
          continue;
        }
      }

      final file = File(candidate);

      if (file.existsSync()) {
        return DynamicLibrary.open(
          file.path,
        );
      }
    }

    throw StateError(
      'Unable to locate cnc_cad.dll. '
      'Searched the application directory, '
      'Flutter Windows build output, and '
      'the native CAD build directory.',
    );
  }

  int initialize() {
    _ensureLoaded();

    return _initialize!();
  }

  int importStep(
    String path,
  ) {
    _ensureLoaded();

    final pathPointer =
        path.toNativeUtf8();

    try {
      return _importStep!(
        pathPointer,
      );
    } finally {
      malloc.free(pathPointer);
    }
  }

  int importIges(
    String path,
  ) {
    _ensureLoaded();

    final pathPointer =
        path.toNativeUtf8();

    try {
      return _importIges!(
        pathPointer,
      );
    } finally {
      malloc.free(pathPointer);
    }
  }

  int bodyCount() {
    _ensureLoaded();

    return _bodyCount!();
  }

  int solidCount() {
    _ensureLoaded();

    return _solidCount!();
  }

  int surfaceCount() {
    _ensureLoaded();

    return _surfaceCount!();
  }

  void clear() {
    _ensureLoaded();

    _clear!();
  }

  void shutdown() {
    if (!_loaded) {
      return;
    }

    _shutdown!();

    _initialize = null;
    _importStep = null;
    _importIges = null;
    _bodyCount = null;
    _solidCount = null;
    _surfaceCount = null;
    _clear = null;
    _shutdown = null;
    _tessellate = null;
    _meshCounts = null;
    _exportMesh = null;

    _loaded = false;
  }


  int tessellate(double deflection) {
    _ensureLoaded();
    return _tessellate!(deflection);
  }

  (int, int) meshCounts() {
    _ensureLoaded();
    final vertexCount = calloc<Int32>();
    final triangleCount = calloc<Int32>();
    try {
      final result = _meshCounts!(vertexCount, triangleCount);
      if (result != 0) {
        throw StateError('Native mesh count failed. Error code: $result');
      }
      return (vertexCount.value, triangleCount.value);
    } finally {
      calloc.free(vertexCount);
      calloc.free(triangleCount);
    }
  }

  ({Float32List positions, Int32List indices}) exportMesh(
    int vertexCount,
    int triangleCount,
  ) {
    _ensureLoaded();
    final positionCount = vertexCount * 3;
    final indexCount = triangleCount * 3;
    final positions = calloc<Float>(positionCount);
    final indices = calloc<Int32>(indexCount);
    try {
      final result = _exportMesh!(positions, positionCount, indices, indexCount);
      if (result != 0) {
        throw StateError('Native mesh export failed. Error code: $result');
      }
      final positionList = Float32List(positionCount);
      positionList.setRange(0, positionCount, positions.asTypedList(positionCount));
      final indexList = Int32List(indexCount);
      indexList.setRange(0, indexCount, indices.asTypedList(indexCount));
      return (positions: positionList, indices: indexList);
    } finally {
      calloc.free(positions);
      calloc.free(indices);
    }
  }

  void _ensureLoaded() {
    if (!_loaded) {
      load();
    }
  }
}
