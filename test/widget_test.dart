import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cnc_jarvis/app/cnc_jarvis_app.dart';

void main() {
  testWidgets('CNC JARVIS app starts', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CncJarvisApp()));
    await tester.pumpAndSettle();

    expect(find.text('CNC JARVIS'), findsWidgets);
    expect(find.text('AI Engineering Assistant'), findsOneWidget);
    expect(find.text('Import CAD File'), findsOneWidget);
  });
}
