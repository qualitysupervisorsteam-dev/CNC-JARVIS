import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/drawing_project.dart';

class ProjectNotifier extends Notifier<DrawingProject?> {
  @override
  DrawingProject? build() {
    return null;
  }

  void setProject(DrawingProject project) {
    state = project;
  }

  void clearProject() {
    state = null;
  }
}

final projectProvider =
    NotifierProvider<ProjectNotifier, DrawingProject?>(
  ProjectNotifier.new,
);
