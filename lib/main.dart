import 'package:flutter/material.dart';
import 'package:nubank_shorten_links/core/injection_container.dart' as di;
import 'package:nubank_shorten_links/features/url_shortener/presentation/url_shortener_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shorten URL App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const UrlShortenerPage(),
    );
  }
}
