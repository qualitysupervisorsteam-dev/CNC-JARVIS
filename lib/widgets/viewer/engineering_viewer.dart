import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/viewer_state.dart';
import '../../providers/viewer_provider.dart';

class EngineeringViewer extends ConsumerWidget {
  const EngineeringViewer({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final viewer =
        ref.watch(viewerProvider);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B1015),
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1E2A32),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _EngineeringViewerPainter(
                viewer: viewer,
              ),
            ),
          ),

          Positioned(
            top: 12,
            left: 12,
            child: _ViewerStatus(
              viewer: viewer,
            ),
          ),

          Positioned(
            top: 12,
            right: 12,
            child: _ViewerControls(
              viewer: viewer,
            ),
          ),

          Positioned(
            bottom: 12,
            left: 12,
            child: _ViewerInfo(
              viewer: viewer,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewerStatus extends StatelessWidget {
  final ViewerState viewer;

  const _ViewerStatus({
    required this.viewer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xCC080B0F),
        borderRadius:
            BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF26343D),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF00E676),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          const Text(
            '3D VIEWER',
            style: TextStyle(
              color: Color(0xFFE8F5E9),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewerControls extends ConsumerWidget {
  final ViewerState viewer;

  const _ViewerControls({
    required this.viewer,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final notifier =
        ref.read(viewerProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xCC080B0F),
        borderRadius:
            BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF26343D),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewerButton(
            icon: Icons.remove,
            tooltip: 'Zoom Out',
            onPressed: () {
              notifier.zoomOut();
            },
          ),
          _ViewerButton(
            icon: Icons.add,
            tooltip: 'Zoom In',
            onPressed: () {
              notifier.zoomIn();
            },
          ),
          _ViewerButton(
            icon: Icons.refresh,
            tooltip: 'Reset View',
            onPressed: () {
              notifier.resetView();
            },
          ),
          _ViewerButton(
            icon: Icons.grid_4x4,
            tooltip: 'Toggle Grid',
            active: viewer.showGrid,
            onPressed: () {
              notifier.toggleGrid();
            },
          ),
          _ViewerButton(
            icon: Icons.straighten,
            tooltip: 'Toggle Dimensions',
            active: viewer.showDimensions,
            onPressed: () {
              notifier.toggleDimensions();
            },
          ),
        ],
      ),
    );
  }
}

class _ViewerButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool active;

  const _ViewerButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 18,
          color: active
              ? const Color(0xFF00E676)
              : const Color(0xFFB0BEC5),
        ),
        splashRadius: 18,
        visualDensity:
            VisualDensity.compact,
      ),
    );
  }
}

class _ViewerInfo extends StatelessWidget {
  final ViewerState viewer;

  const _ViewerInfo({
    required this.viewer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xCC080B0F),
        borderRadius:
            BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF26343D),
        ),
      ),
      child: Text(
        'ZOOM ${viewer.zoom.toStringAsFixed(1)}x'
        '   •   '
        '${viewer.projection.name.toUpperCase()}'
        '   •   '
        '${viewer.renderMode.name.toUpperCase()}',
        style: const TextStyle(
          color: Color(0xFF90A4AE),
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _EngineeringViewerPainter
    extends CustomPainter {
  final ViewerState viewer;

  const _EngineeringViewerPainter({
    required this.viewer,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    _drawGrid(
      canvas,
      size,
    );

    _drawAxes(
      canvas,
      size,
    );

    _drawPlaceholderPart(
      canvas,
      size,
    );
  }

  void _drawGrid(
    Canvas canvas,
    Size size,
  ) {
    if (!viewer.showGrid) {
      return;
    }

    final paint = Paint()
      ..color = const Color(0xFF182127)
      ..strokeWidth = 1;

    const gridSize = 32.0;

    for (
      double x = 0;
      x <= size.width;
      x += gridSize
    ) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (
      double y = 0;
      y <= size.height;
      y += gridSize
    ) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  void _drawAxes(
    Canvas canvas,
    Size size,
  ) {
    if (!viewer.showAxes) {
      return;
    }

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final xPaint = Paint()
      ..color = const Color(0xFFEF5350)
      ..strokeWidth = 2;

    final yPaint = Paint()
      ..color = const Color(0xFF66BB6A)
      ..strokeWidth = 2;

    final zPaint = Paint()
      ..color = const Color(0xFF42A5F5)
      ..strokeWidth = 2;

    canvas.drawLine(
      center,
      Offset(
        center.dx + 90,
        center.dy,
      ),
      xPaint,
    );

    canvas.drawLine(
      center,
      Offset(
        center.dx,
        center.dy - 90,
      ),
      yPaint,
    );

    canvas.drawLine(
      center,
      Offset(
        center.dx - 55,
        center.dy + 55,
      ),
      zPaint,
    );
  }

  void _drawPlaceholderPart(
    Canvas canvas,
    Size size,
  ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final scale =
        0.75 * viewer.zoom;

    final bodyWidth =
        180 * scale;

    final bodyHeight =
        100 * scale;

    final rect = Rect.fromCenter(
      center: center,
      width: bodyWidth,
      height: bodyHeight,
    );

    final bodyPaint = Paint()
      ..color = const Color(0xFF26343D)
      ..style = PaintingStyle.fill;

    final edgePaint = Paint()
      ..color = const Color(0xFF78909C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        const Radius.circular(8),
      ),
      bodyPaint,
    );

    if (viewer.renderMode !=
        ViewerRenderMode.wireframe) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          const Radius.circular(8),
        ),
        edgePaint,
      );
    }

    if (viewer.renderMode ==
            ViewerRenderMode.wireframe ||
        viewer.renderMode ==
            ViewerRenderMode.shadedWireframe) {
      canvas.drawLine(
        Offset(
          rect.left,
          rect.center.dy,
        ),
        Offset(
          rect.right,
          rect.center.dy,
        ),
        edgePaint,
      );

      canvas.drawLine(
        Offset(
          rect.center.dx,
          rect.top,
        ),
        Offset(
          rect.center.dx,
          rect.bottom,
        ),
        edgePaint,
      );
    }

    final holePaint = Paint()
      ..color = const Color(0xFF080B0F)
      ..style = PaintingStyle.fill;

    final holeEdgePaint = Paint()
      ..color = const Color(0xFF90A4AE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final holeRadius =
        18 * scale;

    final leftHole = Offset(
      center.dx - 55 * scale,
      center.dy,
    );

    final rightHole = Offset(
      center.dx + 55 * scale,
      center.dy,
    );

    canvas.drawCircle(
      leftHole,
      holeRadius,
      holePaint,
    );

    canvas.drawCircle(
      leftHole,
      holeRadius,
      holeEdgePaint,
    );

    canvas.drawCircle(
      rightHole,
      holeRadius,
      holePaint,
    );

    canvas.drawCircle(
      rightHole,
      holeRadius,
      holeEdgePaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _EngineeringViewerPainter oldDelegate,
  ) {
    return oldDelegate.viewer != viewer;
  }
}
