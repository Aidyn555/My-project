import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki_reader/ui/article_page/article_view.dart';
import 'package:wiki_reader/ui/random_article/cubits/random_article.dart';


class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticleCubit(),
    child: ArticleView(
    ),
    );
  }
}
