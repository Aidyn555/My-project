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
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}

class ArticleModel {
  Future<Summary> getRandomArticle() async {
    final uri = Uri.https(
      'en.wikipedia.com'
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
  bool isloading = false;
  AricleViewModel(this.model) {
    fetchArticle();
  }
  void fetchArticle() async {
    isloading = true;
    notifyListeners();
    try {
      summary = await model.getRandomArticle();
      error = null;
    } on HttpException catch (e) {
      summary = null;
      error = e;
    }
    isloading = false;
    notifyListeners();
  }
}

class ArticleWidget extends StatelessWidget {
  final Summary summary;
  ArticleWidget({super.key, required this.summary})
  @override
  Widget build(BuildContext context){
    return Padding(padding: EdgeInsets.all(8.0),
    child: Column(
      spacing: 10,
      children: [if (summary.hasImage) Image.network(summary.originalImage!.source),
      Text(
        summary.titles.normalized,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.displaySmall,
        ),
      if (summary.description ! = null)
      Text(summary.description!
      overflow: TextOverflow,),

      Text(summary.extract),
      ],
    ),
    );
  }
}
