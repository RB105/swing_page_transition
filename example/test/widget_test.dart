import 'package:flutter_test/flutter_test.dart';
import 'package:swing_page_transition_example/main.dart';

void main() {
  testWidgets('opens a venue and swipes back', (tester) async {
    await tester.pumpWidget(const SwingDemoApp());

    await tester.tap(find.text('Burger Lab'));
    await tester.pumpAndSettle();
    expect(find.text('Burger Lab special #1'), findsOneWidget);

    await tester.dragFrom(const Offset(5, 300), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Burger Lab special #1'), findsNothing);
    expect(find.text('Discovery'), findsOneWidget);
  });
}
