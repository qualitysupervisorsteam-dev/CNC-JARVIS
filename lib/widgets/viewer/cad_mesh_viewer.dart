import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../models/cad_mesh.dart';

class CadMeshViewer extends StatefulWidget {
  final CadMesh mesh;

  const CadMeshViewer({
    super.key,
    required this.mesh,
  });

  @override
  State<CadMeshViewer> createState() =>
      _CadMeshViewerState();
}

class _CadMeshViewerState
    extends State<CadMeshViewer> {
  double _rotationX = -0.6;
  double _rotationY = 0.7;
  double _zoom = 1.0;
  bool _wireframe = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B1015),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1E2A32),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _rotationY +=
                      details.delta.dx * 0.01;
                  _rotationX +=
                      details.delta.dy * 0.01;
                });
              },
              child: CustomPaint(
                painter: _CadMeshPainter(
                  mesh: widget.mesh,
                  rotationX: _rotationX,
                  rotationY: _rotationY,
                  zoom: _zoom,
                  wireframe: _wireframe,
                ),
              ),
            ),
          ),

          Positioned(
            top: 12,
            right: 12,
            child: Column(
              children: [
                _ViewerButton(
                  icon: Icons.add,
                  onPressed: () {
                    setState(() {
                      _zoom = math.min(
                        _zoom * 1.15,
                        50.0,
                      );
                    });
                  },
                ),

                const SizedBox(height: 6),

                _ViewerButton(
                  icon: Icons.remove,
                  onPressed: () {
                    setState(() {
                      _zoom = math.max(
                        _zoom / 1.15,
                        0.05,
                      );
                    });
                  },
                ),

                const SizedBox(height: 6),

                _ViewerButton(
                  icon: Icons.grid_3x3,
                  active: _wireframe,
                  onPressed: () {
                    setState(() {
                      _wireframe = !_wireframe;
                    });
                  },
                ),

                const SizedBox(height: 6),

                _ViewerButton(
                  icon: Icons.refresh,
                  onPressed: () {
                    setState(() {
                      _rotationX = -0.6;
                      _rotationY = 0.7;
                      _zoom = 1.0;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewerButton extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onPressed;

  const _ViewerButton({
    required this.icon,
    required this.onPressed,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xCC080B0F),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active
                  ? const Color(0xFF00E676)
                  : const Color(0xFF26343D),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: active
                ? const Color(0xFF00E676)
                : const Color(0xFFB0BEC5),
          ),
        ),
      ),
    );
  }
}

class _CadMeshPainter extends CustomPainter {
  final CadMesh mesh;
  final double rotationX;
  final double rotationY;
  final double zoom;
  final bool wireframe;

  _CadMeshPainter({
    required this.mesh,
    required this.rotationX,
    required this.rotationY,
    required this.zoom,
    required this.wireframe,
  });

  static const Color _dark =
      Color(0xFF06281F);

  static const Color _light =
      Color(0xFF00E676);

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final vertexCount = mesh.vertexCount;
    final triangleCount = mesh.triangleCount;

    if (vertexCount == 0 ||
        triangleCount == 0) {
      return;
    }

    final positions = mesh.positions;
    final indices = mesh.indices;

    double minX = double.infinity;
    double minY = double.infinity;
    double minZ = double.infinity;

    double maxX = -double.infinity;
    double maxY = -double.infinity;
    double maxZ = -double.infinity;

    for (var i = 0; i < vertexCount; i++) {
      final x = positions[i * 3];
      final y = positions[i * 3 + 1];
      final z = positions[i * 3 + 2];

      if (x < minX) minX = x;
      if (y < minY) minY = y;
      if (z < minZ) minZ = z;

      if (x > maxX) maxX = x;
      if (y > maxY) maxY = y;
      if (z > maxZ) maxZ = z;
    }

    final centerX = (minX + maxX) / 2;
    final centerY = (minY + maxY) / 2;
    final centerZ = (minZ + maxZ) / 2;

    final extentX = maxX - minX;
    final extentY = maxY - minY;
    final extentZ = maxZ - minZ;

    final maxExtent = math.max(
      extentX,
      math.max(extentY, extentZ),
    );

    if (maxExtent <= 0) {
      return;
    }

    final scale =
        0.75 *
        math.min(
          size.width,
          size.height,
        ) /
        maxExtent *
        zoom;

    final center = size.center(Offset.zero);

    final cosX = math.cos(rotationX);
    final sinX = math.sin(rotationX);

    final cosY = math.cos(rotationY);
    final sinY = math.sin(rotationY);

    final projected =
        Float32List(vertexCount * 2);

    final depths =
        Float32List(vertexCount);

    for (var i = 0; i < vertexCount; i++) {
      final x =
          positions[i * 3] - centerX;

      final y =
          positions[i * 3 + 1] - centerY;

      final z =
          positions[i * 3 + 2] - centerZ;

      final y1 =
          y * cosX - z * sinX;

      final z1 =
          y * sinX + z * cosX;

      final x2 =
          x * cosY + z1 * sinY;

      final z2 =
          -x * sinY + z1 * cosY;

      projected[i * 2] =
          center.dx + x2 * scale;

      projected[i * 2 + 1] =
          center.dy - y1 * scale;

      depths[i] = z2;
    }

    final order =
        List<int>.generate(
      triangleCount,
      (i) => i,
    );

    final shade =
        Float32List(triangleCount);

    final avgDepth =
        Float32List(triangleCount);

    const lightX = 0.5;
    const lightY = -0.7;
    const lightZ = 0.5;

    final lightLength = math.sqrt(
      lightX * lightX +
          lightY * lightY +
          lightZ * lightZ,
    );

    final lx = lightX / lightLength;
    final ly = lightY / lightLength;
    final lz = lightZ / lightLength;

    for (var t = 0;
        t < triangleCount;
        t++) {
      final i0 = indices[t * 3];
      final i1 = indices[t * 3 + 1];
      final i2 = indices[t * 3 + 2];

      final ax =
          positions[i1 * 3] -
              positions[i0 * 3];

      final ay =
          positions[i1 * 3 + 1] -
              positions[i0 * 3 + 1];

      final az =
          positions[i1 * 3 + 2] -
              positions[i0 * 3 + 2];

      final bx =
          positions[i2 * 3] -
              positions[i0 * 3];

      final by =
          positions[i2 * 3 + 1] -
              positions[i0 * 3 + 1];

      final bz =
          positions[i2 * 3 + 2] -
              positions[i0 * 3 + 2];

      var nx =
          ay * bz - az * by;

      var ny =
          az * bx - ax * bz;

      var nz =
          ax * by - ay * bx;

      final nLength = math.sqrt(
        nx * nx +
            ny * ny +
            nz * nz,
      );

      if (nLength > 0) {
        nx /= nLength;
        ny /= nLength;
        nz /= nLength;
      }

      final ny1 =
          ny * cosX - nz * sinX;

      final nz1 =
          ny * sinX + nz * cosX;

      final nx2 =
          nx * cosY + nz1 * sinY;

      final nz2 =
          -nx * sinY + nz1 * cosY;

      var dot =
          nx2 * lx +
          ny1 * ly +
          nz2 * lz;

      dot = dot.clamp(-1.0, 1.0);

      shade[t] =
          0.2 +
          0.8 * math.max(0.0, dot);

      avgDepth[t] =
          (depths[i0] +
                  depths[i1] +
                  depths[i2]) /
              3;
    }

    order.sort(
      (a, b) => avgDepth[a].compareTo(
        avgDepth[b],
      ),
    );

    final verts = List<Offset>.filled(
      triangleCount * 3,
      Offset.zero,
    );

    final colors = List<Color>.filled(
      triangleCount * 3,
      _light,
    );

    for (var s = 0;
        s < triangleCount;
        s++) {
      final t = order[s];

      final i0 = indices[t * 3];
      final i1 = indices[t * 3 + 1];
      final i2 = indices[t * 3 + 2];

      final faceColor = Color.lerp(
        _dark,
        _light,
        shade[t],
      )!;

      verts[s * 3] = Offset(
        projected[i0 * 2],
        projected[i0 * 2 + 1],
      );

      verts[s * 3 + 1] = Offset(
        projected[i1 * 2],
        projected[i1 * 2 + 1],
      );

      verts[s * 3 + 2] = Offset(
        projected[i2 * 2],
        projected[i2 * 2 + 1],
      );

      colors[s * 3] = faceColor;
      colors[s * 3 + 1] = faceColor;
      colors[s * 3 + 2] = faceColor;
    }

    canvas.drawVertices(
      ui.Vertices(
        ui.VertexMode.triangles,
        verts,
        colors: colors,
      ),
      BlendMode.srcOver,
      Paint(),
    );

    if (wireframe) {
      final wirePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..color = const Color(0x5900E676);

      for (var t = 0;
          t < triangleCount;
          t++) {
        final i0 = indices[t * 3];
        final i1 = indices[t * 3 + 1];
        final i2 = indices[t * 3 + 2];

        final path = Path()
          ..moveTo(
            projected[i0 * 2],
            projected[i0 * 2 + 1],
          )
          ..lineTo(
            projected[i1 * 2],
            projected[i1 * 2 + 1],
          )
          ..lineTo(
            projected[i2 * 2],
            projected[i2 * 2 + 1],
          )
          ..close();

        canvas.drawPath(
          path,
          wirePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant _CadMeshPainter oldDelegate,
  ) {
    return oldDelegate.mesh != mesh ||
        oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.zoom != zoom ||
        oldDelegate.wireframe != wireframe;
  }
}
