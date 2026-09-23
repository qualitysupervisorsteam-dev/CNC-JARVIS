import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cnc_jarvis/models/engineering_model.dart';
import 'package:cnc_jarvis/providers/engineering_model_provider.dart';

void main() {
  group('Engineering Model Provider', () {
    test('starts with no engineering model', () {
      final container = ProviderContainer();

      addTearDown(container.dispose);

      final model =
          container.read(engineeringModelProvider);

      expect(model, isNull);
    });

    test('stores engineering model', () {
      final container = ProviderContainer();

      addTearDown(container.dispose);

      const model = EngineeringModel(
        id: 'MODEL1',
        name: 'Test Part',
        confidence: 1.0,
        geometryReady: true,
        verified: true,
      );

      container
          .read(
            engineeringModelProvider.notifier,
          )
          .setModel(model);

      final result =
          container.read(engineeringModelProvider);

      expect(result, isNotNull);
      expect(result!.id, 'MODEL1');
      expect(result.name, 'Test Part');
      expect(result.geometryReady, true);
      expect(result.verified, true);
    });

    test('clears engineering model', () {
      final container = ProviderContainer();

      addTearDown(container.dispose);

      const model = EngineeringModel(
        id: 'MODEL2',
        name: 'Part To Clear',
      );

      final notifier =
          container.read(
            engineeringModelProvider.notifier,
          );

      notifier.setModel(model);
      expect(
        container.read(engineeringModelProvider),
        isNotNull,
      );

      notifier.clearModel();

      expect(
        container.read(engineeringModelProvider),
        isNull,
      );
    });

    test('updates engineering model', () {
      final container = ProviderContainer();

      addTearDown(container.dispose);

      const firstModel = EngineeringModel(
        id: 'MODEL3',
        name: 'First Part',
      );

      const updatedModel = EngineeringModel(
        id: 'MODEL3',
        name: 'Updated Part',
        geometryReady: true,
      );

      final notifier =
          container.read(
            engineeringModelProvider.notifier,
          );

      notifier.setModel(firstModel);
      notifier.updateModel(updatedModel);

      final result =
          container.read(engineeringModelProvider);

      expect(result, isNotNull);
      expect(result!.name, 'Updated Part');
      expect(result.geometryReady, true);
    });
  });
}
