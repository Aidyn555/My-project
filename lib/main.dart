import 'package:flutter/material.dart';
import 'summary.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: ArticleView())),
    );
  }
}

class ArticleModel {
  Future<Summary> getRandomArticle() async {
    final uri = Uri.https(
      'en.wikipedia.com',
      'api/rest_v1/page/random/summary',
    );
    final response = await get(uri);
    if (response.statusCode != 200) {
      throw HttpException("Failed to update resourse");
    }
    return Summary.fromJson(json.decode(response.body) as Map<String, Object?>);
  }
}

class AricleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  Exception? error;
  bool isLoading = false;
  AricleViewModel(this.model) {
    fetchArticle();
  }
  void fetchArticle() async {
    isLoading = true;
    notifyListeners();
    try {
      summary = await model.getRandomArticle();
      error = null;
    } on HttpException catch (e) {
      summary = null;
      error = e;
    }
    isLoading = false;
    notifyListeners();
  }
}

class ArticleWidget extends StatelessWidget {
  final Summary summary;
  ArticleWidget({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        spacing: 10,
        children: [
          if (summary.hasImage) Image.network(summary.originalImage!.source),
          Text(
            summary.titles.normalized,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          if (summary.description != null)
            Text(
              summary.description!,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          Text(summary.extract),
        ],
      ),
    );
  }
}

class ArticlePage extends StatelessWidget {
  final Summary summary;
  final VoidCallback nextArticle;
  ArticlePage({super.key, required this.summary, required this.nextArticle});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ArticleWidget(summary: summary),
          ElevatedButton(onPressed: nextArticle, child: Text("Next Article")),
        ],
      ),
    );
  }
}

class ArticleView extends StatefulWidget {
  const ArticleView({super.key});
  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final viewModel = AricleViewModel(ArticleModel());
  @override
  void initState() {
    super.initState();
    viewModel.fetchArticle();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Center(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return switch ((
              viewModel.isLoading,
              viewModel.summary,
              viewModel.error,
            )) {
              (true, _, _) => const CircularProgressIndicator(),
              (_, _, Exception e) => Text('error $e'),
              (_, Summary summary, _) => ArticlePage(
                summary: summary,
                nextArticle: viewModel.fetchArticle,
              ),
              _ => const Text("Something went wrong"),
            };
          },
        ),
      ),
    );
  }
}
