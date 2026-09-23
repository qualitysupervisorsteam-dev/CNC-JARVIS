import 'dart:typed_data';

class CadMesh {
  final Float32List positions;
  final Int32List indices;

  const CadMesh({required this.positions, required this.indices});

  int get vertexCount => positions.length ~/ 3;
  int get triangleCount => indices.length ~/ 3;
  bool get isEmpty => indices.isEmpty;
}
