import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signal_app/news/news_service.dart';
import 'package:signal_app/utils/error_page.dart';

import 'news.dart';
import 'news_list.dart';

class NewsSaved extends StatefulWidget {
  const NewsSaved({super.key});

  @override
  State createState() => NewsSavedState();
}

class NewsSavedState extends State<NewsSaved> {
  final newsService = NewsService();

  List<News> newsList = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      final result = await newsService.getBookmarkNews();

      setState(() {
        newsList = result;
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
          ? ErrorPage(onRetry: _loadNews)
          : newsList.isEmpty
          ? Center(child: Text("Aucun favori pour l'instant"))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 50),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: NewsList(
                    key: ValueKey(news.id),
                    news: news,
                    onTap: () async {
                      final result = await context.push(
                        '/news',
                        extra: news.id,
                      );

                      if (result == true) {
                        _loadNews();
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
