import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/mesh_provider.dart';
import '../widgets/viewer/cad_mesh_viewer.dart';

class EngineeringWorkspaceScreen
    extends ConsumerWidget {
  const EngineeringWorkspaceScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final mesh = ref.watch(meshProvider);

    return Scaffold(
      backgroundColor:
          const Color(0xFF080B0F),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF10171D),
        elevation: 0,

        title: const Row(
          children: [
            Icon(
              Icons.view_in_ar,
              size: 22,
            ),
            SizedBox(width: 10),
            Text(
              'Engineering Workspace',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      const Color(0xFF10171D),
                  borderRadius:
                      BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        const Color(0xFF1E2A32),
                  ),
                ),
                child: mesh != null
                    ? CadMeshViewer(
                        mesh: mesh,
                      )
                    : const _EmptyWorkspace(),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                    const Color(0xFF10171D),
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color:
                      const Color(0xFF1E2A32),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    mesh != null
                        ? Icons.check_circle
                        : Icons.info_outline,
                    color: mesh != null
                        ? const Color(0xFF00E676)
                        : const Color(0xFF90A4AE),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      mesh != null
                          ? 'CAD geometry loaded'
                          : 'No CAD geometry loaded',
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),

                  if (mesh != null)
                    Text(
                      '${mesh.vertexCount} vertices • '
                      '${mesh.triangleCount} triangles',
                      style:
                          const TextStyle(
                        color:
                            Color(0xFF78909C),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyWorkspace
    extends StatelessWidget {
  const _EmptyWorkspace();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(32),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons.view_in_ar,
              size: 72,
              color:
                  const Color(0xFF455A64),
            ),

            const SizedBox(height: 20),

            const Text(
              'No CAD model loaded',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Import a STEP or IGES file from the home screen.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    Color(0xFF78909C),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
