import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/engineering_model.dart';

class EngineeringModelNotifier
    extends Notifier<EngineeringModel?> {
  @override
  EngineeringModel? build() {
    return null;
  }

  void setModel(EngineeringModel model) {
    state = model;
  }

  void clearModel() {
    state = null;
  }

  void updateModel(EngineeringModel model) {
    state = model;
  }
}

final engineeringModelProvider =
    NotifierProvider<
        EngineeringModelNotifier,
        EngineeringModel?>(
  EngineeringModelNotifier.new,
);
