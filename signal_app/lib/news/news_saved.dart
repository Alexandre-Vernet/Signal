import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signal_app/news/news_service.dart';

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
  bool isLoadingNews = true;

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
        isLoadingNews = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoadingNews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: newsList.isEmpty
          ? Center(child: Text("Aucun favori pour l'instant"))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: NewsList(
                    key: ValueKey(news.id),
                    news: news,
                    onTap: () {
                      context.push('/news', extra: news.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}
