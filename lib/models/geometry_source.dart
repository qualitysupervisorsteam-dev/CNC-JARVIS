enum GeometrySourceFormat {
  step,
  iges,
  stl,
  dxf,
  dwg,
  pdf,
  image,
}

class GeometrySource {
  final String path;
  final GeometrySourceFormat format;

  const GeometrySource({
    required this.path,
    required this.format,
  });

  bool get isStep =>
      format == GeometrySourceFormat.step;

  bool get isIges =>
      format == GeometrySourceFormat.iges;

  bool get isDirectCadFormat =>
      isStep || isIges;

  bool get isDrawingFormat =>
      format == GeometrySourceFormat.dxf ||
      format == GeometrySourceFormat.dwg ||
      format == GeometrySourceFormat.pdf ||
      format == GeometrySourceFormat.image;

  String get extension {
    switch (format) {
      case GeometrySourceFormat.step:
        return 'step';
      case GeometrySourceFormat.iges:
        return 'iges';
      case GeometrySourceFormat.stl:
        return 'stl';
      case GeometrySourceFormat.dxf:
        return 'dxf';
      case GeometrySourceFormat.dwg:
        return 'dwg';
      case GeometrySourceFormat.pdf:
        return 'pdf';
      case GeometrySourceFormat.image:
        return 'image';
    }
  }
}
