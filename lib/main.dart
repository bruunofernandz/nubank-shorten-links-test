import 'package:flutter/material.dart';
import 'package:nubank_shorten_links/core/di/app_bindings.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/url_shortener_page.dart';

void main() {
  AppInjector.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shorten URL App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}
