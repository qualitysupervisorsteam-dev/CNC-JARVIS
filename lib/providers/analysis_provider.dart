import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/analysis_status.dart';
import '../models/drawing_analysis.dart';
import '../models/drawing_project.dart';
import '../services/drawing_analysis_service.dart';
import 'engineering_model_provider.dart';
import 'geometry_provider.dart';

class AnalysisState {
  final AnalysisStatus status;
  final DrawingAnalysis analysis;
  final String? errorMessage;

  const AnalysisState({
    required this.status,
    required this.analysis,
    this.errorMessage,
  });

  const AnalysisState.initial()
      : status = AnalysisStatus.idle,
        analysis = const DrawingAnalysis.empty(),
        errorMessage = null;

  bool get isAnalyzing =>
      status == AnalysisStatus.analyzing;

  bool get isCompleted =>
      status == AnalysisStatus.completed;

  bool get hasFailed =>
      status == AnalysisStatus.failed;

  AnalysisState copyWith({
    AnalysisStatus? status,
    DrawingAnalysis? analysis,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AnalysisState(
      status: status ?? this.status,
      analysis: analysis ?? this.analysis,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class AnalysisNotifier
    extends Notifier<AnalysisState> {
  final DrawingAnalysisService _service =
      DrawingAnalysisService();

  @override
  AnalysisState build() {
    return const AnalysisState.initial();
  }

  Future<void> analyzeProject(
    DrawingProject project,
  ) async {
    state = state.copyWith(
      status: AnalysisStatus.analyzing,
      clearError: true,
    );

    ref
        .read(
          geometryProvider.notifier,
        )
        .clearGeometry();

    try {
      final result =
          await _service.analyze(project);

      final engineeringModel =
          result.engineeringModel;

      if (engineeringModel != null) {
        ref
            .read(
              engineeringModelProvider.notifier,
            )
            .setModel(
              engineeringModel,
            );

        await ref
            .read(
              geometryProvider.notifier,
            )
            .buildFromEngineeringModel(
              engineeringModel,
            );
      } else {
        ref
            .read(
              engineeringModelProvider.notifier,
            )
            .clearModel();
      }

      state = state.copyWith(
        status: AnalysisStatus.completed,
        analysis: result,
        clearError: true,
      );
    } catch (error) {
      ref
          .read(
            engineeringModelProvider.notifier,
          )
          .clearModel();

      ref
          .read(
            geometryProvider.notifier,
          )
          .clearGeometry();

      state = state.copyWith(
        status: AnalysisStatus.failed,
        errorMessage: error.toString(),
      );
    }
  }

  void reset() {
    ref
        .read(
          engineeringModelProvider.notifier,
        )
        .clearModel();

    ref
        .read(
          geometryProvider.notifier,
        )
        .clearGeometry();

    state = const AnalysisState.initial();
  }
}

final analysisProvider =
    NotifierProvider<
        AnalysisNotifier,
        AnalysisState>(
  AnalysisNotifier.new,
);
