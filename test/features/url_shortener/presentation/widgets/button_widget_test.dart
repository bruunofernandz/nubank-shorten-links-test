import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/widgets/button_widget.dart';

void main() {
  testWidgets('should ButtonWidget displays the correct text', (
    WidgetTester tester,
  ) async {
    const buttonText = 'Press Me';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonWidget(onPressed: () {}, text: buttonText),
        ),
      ),
    );

    expect(find.text(buttonText), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('should ButtonWidget calls onPressed when tapped', (
    WidgetTester tester,
  ) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonWidget(
            onPressed: () {
              pressed = true;
            },
            text: 'Tap',
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    expect(pressed, isTrue);
  });

  testWidgets(
    'should ButtonWidget has correct minimum size and border radius',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonWidget(onPressed: () {}, text: 'Test'),
          ),
        ),
      );

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final ButtonStyle? style = elevatedButton.style;
      expect(style, isNotNull);

      final WidgetStateProperty<Size?>? minSizeProp = style?.minimumSize;
      expect(minSizeProp?.resolve({}), const Size(100, 50));

      final WidgetStateProperty<OutlinedBorder?>? shapeProp = style?.shape;
      final shape = shapeProp?.resolve({});
      expect(shape, isA<RoundedRectangleBorder>());
      final borderRadius = (shape as RoundedRectangleBorder).borderRadius;
      expect(borderRadius, BorderRadius.circular(8.0));
    },
  );
}
