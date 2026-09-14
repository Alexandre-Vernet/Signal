import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signal_app/home.dart';
import 'package:signal_app/news/news_saved.dart';

import '../custom_navigation_bar.dart';
import '../news/news_detail.dart';

final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: CustomNavigationBar(),
        );
      },
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) {
            return Home();
          },
        ),
        GoRoute(
          path: "/news",
          builder: (context, state) {
            final newsId = state.extra as int;

            return NewsDetail(newsId: newsId);
          },
        ),
        GoRoute(
          path: "/news-saved",
          builder: (context, state) {
            return NewsSaved();
          },
        ),
      ],
    ),
  ],
);
