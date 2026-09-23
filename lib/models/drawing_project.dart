class DrawingProject {
  final String name;
  final String fileName;
  final String? filePath;
  final String fileExtension;

  const DrawingProject({
    required this.name,
    required this.fileName,
    required this.filePath,
    required this.fileExtension,
  });

  factory DrawingProject.fromFile({
    required String fileName,
    required String? filePath,
  }) {
    final cleanName = fileName.contains('.')
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;

    final extension = fileName.contains('.')
        ? fileName.split('.').last.toLowerCase()
        : '';

    return DrawingProject(
      name: cleanName,
      fileName: fileName,
      filePath: filePath,
      fileExtension: extension,
    );
  }
}
