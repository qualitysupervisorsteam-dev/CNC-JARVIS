import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cad_mesh.dart';

class MeshNotifier extends Notifier<CadMesh?> {
  @override
  CadMesh? build() => null;

  void setMesh(CadMesh? mesh) => state = mesh;
  void clear() => state = null;
}

final meshProvider = NotifierProvider<MeshNotifier, CadMesh?>(MeshNotifier.new);
