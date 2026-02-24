import 'package:flutter_test/flutter_test.dart';
import 'package:hue/app/app.dart';

void main() {
  testWidgets('HueApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HueApp());
    expect(find.byType(HueApp), findsOneWidget);
  });
}
