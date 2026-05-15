import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:wiki_reader/ui/article_page/article_screen.dart';
final router = GoRouter(
  initialLocation: "/random",
  routes: [
    StatefulShellRoute.indexedStack(
    builder: ,
  branches: [StatefulShellBranch(
    routes: [
      GoRoute(path: "/random",
    builder: (context, state) => ArticleScreen(),
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(path: "/fav",
      builder: (context, state) => Text('100 balov'),)
    ],
  ),


  ],
  ),
  ],
);