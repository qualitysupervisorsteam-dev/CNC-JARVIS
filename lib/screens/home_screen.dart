import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/engineering_model.dart';
import '../providers/engineering_model_provider.dart';
import '../providers/geometry_provider.dart';
import '../providers/mesh_provider.dart';
import '../services/cad/cad_native_service.dart';
import 'engineering_workspace_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF10171D),
        elevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.precision_manufacturing,
              size: 22,
            ),
            SizedBox(width: 10),
            Text(
              'CNC JARVIS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  const Icon(
                    Icons.precision_manufacturing,
                    size: 72,
                    color: Color(0xFF64B5F6),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'CNC JARVIS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'AI Engineering Assistant',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF90A4AE),
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _HomeActionCard(
                    icon: Icons.view_in_ar,
                    title: 'Engineering Workspace',
                    description:
                        'View geometry, dimensions, sections and engineering data.',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const EngineeringWorkspaceScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  _HomeActionCard(
                    icon: Icons.upload_file,
                    title: 'Import CAD File',
                    description:
                        'Open a STEP or IGES file and process it with native CAD on Windows.',
                    onPressed: () async {
                      final picked = await FilePicker.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: const [
                          'step',
                          'stp',
                          'iges',
                          'igs',
                        ],
                        allowMultiple: false,
                        dialogTitle: 'Open CAD file',
                      );

                      if (!context.mounted) {
                        return;
                      }

                      final path = picked?.files.single.path;

                      if (path == null || path.isEmpty) {
                        return;
                      }

                      await _importCadFile(
                        context,
                        ref,
                        path,
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'CNC JARVIS • Engineering Intelligence',
                    style: TextStyle(
                      color: Color(0xFF546E7A),
                      fontSize: 11,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _importCadFile(
    BuildContext context,
    WidgetRef ref,
    String path,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final extension = path.split('.').last.toLowerCase();

    final isStep =
        extension == 'step' || extension == 'stp';

    final isIges =
        extension == 'iges' || extension == 'igs';

    if (!isStep && !isIges) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Only STEP and IGES are supported.',
          ),
        ),
      );
      return;
    }

    messenger.showSnackBar(
      const SnackBar(
        content: Text(
          'Importing CAD file...',
        ),
        duration: Duration(seconds: 30),
      ),
    );

    try {
      const service = CadNativeService();

      final geometry = isStep
          ? await service.importStep(path)
          : await service.importIges(path);

      final mesh = await service.getMesh();

      ref
          .read(geometryProvider.notifier)
          .setGeometry(geometry);

      ref
          .read(meshProvider.notifier)
          .setMesh(mesh);

      ref
          .read(
            engineeringModelProvider.notifier,
          )
          .setModel(
            EngineeringModel(
              id:
                  'EM-${DateTime.now().millisecondsSinceEpoch}',
              name: geometry.name,
              confidence: geometry.confidence,
              geometryReady: true,
              verified: geometry.verified,
              unitSystem: 'mm',
              note:
                  'Imported from '
                  '${geometry.geometryFormat} '
                  'via OpenCASCADE.',
            ),
          );

      messenger.hideCurrentSnackBar();

      if (!context.mounted) {
        return;
      }

      await navigator.push(
        MaterialPageRoute(
          builder: (_) =>
              const EngineeringWorkspaceScreen(),
        ),
      );
    } on UnsupportedError catch (error) {
      messenger.hideCurrentSnackBar();

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            error.message ??
                'Native CAD is available on Windows only.',
          ),
        ),
      );
    } catch (error) {
      messenger.hideCurrentSnackBar();

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Import failed: $error',
          ),
        ),
      );
    }
  }
}

class _HomeActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onPressed;

  const _HomeActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Material(
      color: const Color(0xFF10171D),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF1E2A32),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF16232C),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF64B5F6),
                  size: 25,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFF78909C),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              const Icon(
                Icons.chevron_right,
                color: Color(0xFF546E7A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
