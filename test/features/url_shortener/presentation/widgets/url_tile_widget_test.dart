import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/widgets/url_tile_widget.dart';

void main() {
  const testUrl = 'https://short.url/abc123';

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Clipboard.setData(const ClipboardData(text: ''));
  });

  testWidgets('UrlTileWidget displays the shortened URL', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: UrlTileWidget(index: 0, shorttedUrl: testUrl)),
      ),
    );

    expect(find.text(testUrl), findsOneWidget);
    expect(find.byIcon(Icons.copy), findsOneWidget);
  });

  testWidgets(
    'UrlTileWidget copies URL to clipboard and shows SnackBar on copy button tap',
    (WidgetTester tester) async {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {}
          return null;
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UrlTileWidget(index: 0, shorttedUrl: testUrl)),
        ),
      );

      await tester.tap(find.byIcon(Icons.copy));
      await tester.pumpAndSettle();

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    },
  );
}
