// lib/main.dart
import 'package:flutter/material.dart';
import 'views/anime_search_view.dart';

void main() {
  runApp(AnimeExplorerApp());
}

class AnimeExplorerApp extends StatelessWidget {
  const AnimeExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primarySwatch: Colors.indigo,
      useMaterial3: false,
      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 20),
        titleMedium: TextStyle(fontSize: 16),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.grey[50],
    );

    return MaterialApp(
      title: 'Anime Explorer',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: AnimeSearchView(),
    );
  }
}
