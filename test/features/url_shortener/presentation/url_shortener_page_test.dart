import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/cubit/url_shortener_state.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/resources/url_shortener_strings.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/url_shortener_page.dart';

import '../../../mocks/url_shortener_page_test.mocks.dart';

void main() {
  late MockUrlShortenerCubit mockCubit;

  setUp(() {
    mockCubit = MockUrlShortenerCubit();

    when(mockCubit.state).thenReturn(UrlShortenerInitial());

    when(mockCubit.stream).thenAnswer(
      (_) => Stream<UrlShortenerState>.fromIterable([UrlShortenerInitial()]),
    );

    when(mockCubit.loadStoredUrls()).thenAnswer((_) async {});
    when(mockCubit.clearList()).thenAnswer((_) {});
    when(mockCubit.shortenUrl(any)).thenAnswer((_) => Future.value());
  });

  group('UrlShortenerPage Widget Tests', () {
    testWidgets('Should render UrlShortenerPage with initial state', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: UrlShortenerPage(cubit: mockCubit)),
      );

      expect(find.byType(UrlShortenerPage), findsOneWidget);
      expect(find.text(UrlShortenerStrings.pageTitle), findsOneWidget);
      expect(find.text(UrlShortenerStrings.descriptionOne), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text(UrlShortenerStrings.clearButton), findsOneWidget);
      expect(find.text(UrlShortenerStrings.shortenButton), findsOneWidget);
    });

    testWidgets('Should display CircularProgressIndicator when loading', (
      tester,
    ) async {
      when(mockCubit.state).thenReturn(UrlShortenerLoading());

      when(mockCubit.stream).thenAnswer(
        (_) => Stream<UrlShortenerState>.fromIterable([UrlShortenerLoading()]),
      );

      await tester.pumpWidget(
        MaterialApp(home: UrlShortenerPage(cubit: mockCubit)),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should display list of shortened URLs when loaded', (
      tester,
    ) async {
      final urls = [
        ShortUrlModel(
          originalUrl: 'https://example.com',
          shortUrl: 'https://short.ly/abc',
          alias: 'abc',
        ),
        ShortUrlModel(
          originalUrl: 'https://flutter.dev',
          shortUrl: 'https://short.ly/def',
          alias: 'def',
        ),
      ];
      when(
        mockCubit.state,
      ).thenReturn(UrlShortenerStoredUrlsLoaded(urls: urls));

      when(mockCubit.stream).thenAnswer(
        (_) => Stream<UrlShortenerState>.fromIterable([
          UrlShortenerStoredUrlsLoaded(urls: urls),
        ]),
      );

      await tester.pumpWidget(
        MaterialApp(home: UrlShortenerPage(cubit: mockCubit)),
      );
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('https://short.ly/abc'), findsOneWidget);
      expect(find.text('https://short.ly/def'), findsOneWidget);
    });

    testWidgets('Should call shortenUrl when pressing the Shorten button', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: UrlShortenerPage(cubit: mockCubit)),
      );

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, 'https://test.com');
      await tester.pump();

      final shortenButton = find.text(UrlShortenerStrings.shortenButton);
      expect(shortenButton, findsOneWidget);

      await tester.tap(shortenButton);
      await tester.pump();

      verify(mockCubit.shortenUrl('https://test.com')).called(1);
    });
  });
}
