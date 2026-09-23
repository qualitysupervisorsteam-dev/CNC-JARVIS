class DrawingImportResult {
  final String? path;
  final String? name;
  final String? extension;

  const DrawingImportResult({
    this.path,
    this.name,
    this.extension,
  });

  bool get hasFile =>
      path != null && path!.isNotEmpty;
}

class DrawingImportService {
  const DrawingImportService();

  Future<DrawingImportResult?> pickDrawing() async {
    return null;
  }

  Future<DrawingImportResult?> importFromPath(
    String path,
  ) async {
    if (path.trim().isEmpty) {
      return null;
    }

    final normalizedPath =
        path.trim();

    final lastSeparator =
        normalizedPath.lastIndexOf(
      RegExp(r'[/\\]'),
    );

    final name = lastSeparator >= 0
        ? normalizedPath.substring(
            lastSeparator + 1,
          )
        : normalizedPath;

    final dotIndex =
        name.lastIndexOf('.');

    final extension =
        dotIndex >= 0
            ? name
                .substring(dotIndex + 1)
                .toLowerCase()
            : null;

    return DrawingImportResult(
      path: normalizedPath,
      name: name,
      extension: extension,
    );
  }
}
