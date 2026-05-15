import 'package:flutter/material.dart';
import 'package:wiki_reader/ui/article_page/article_screen.dart';
import 'package:wiki_reader/ui/article_page/article_view.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ArticleScreen()
    );
  }
}