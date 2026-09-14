import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signal_app/news/news.dart';
import 'package:signal_app/news/news_service.dart';
import 'package:signal_app/user/user_service.dart';
import 'package:signal_app/utils/string_utils.dart';

import 'news/news_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {
  List<News> newsList = [];
  bool isLoadingNews = true;

  bool isLoadingCategories = true;
  List<String> categories = [];
  Set<String> selectedCategories = {};

  final newsService = NewsService();
  final userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadNews();
    _loadCategories();
    _initUser();
  }

  Future<void> _loadNews() async {
    try {
      final result = selectedCategories.isEmpty
          ? await newsService.findAllNews()
          : await newsService.getNewsByCategories(selectedCategories.toList());

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

  Future<void> _loadCategories() async {
    try {
      final result = await newsService.getCategories();

      setState(() {
        categories = result;
        isLoadingCategories = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  Future<void> _initUser() async {
    try {
      await userService.getUuid();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),

      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF217EFA), Color(0xFF1946E4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.sensors_rounded,
                size: 19,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Signal',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),

      body: isLoadingNews
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadNews,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  // Hero
                  if (index == 0) {
                    return _buildHeroArea();
                  }

                  // Categories
                  if (index == 1) {
                    return _buildCategoryFilter();
                  }

                  // Spacer
                  if (index == 2) {
                    return const SizedBox(height: 16);
                  }

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
            ),
    );
  }

  Widget _buildHeroArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF217EFA), Color(0xFF1946E4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF217EFA).withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Icon(
                          Icons.sensors_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),

                      const SizedBox(width: 9),

                      const Text(
                        'VOTRE SIGNAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'L’essentiel de\nl’actualité.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Les informations qui comptent, sans le bruit.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.graphic_eq_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    setState(() {
      selectedCategories = selectedCategories;
    });

    _loadNews();
  }

  Widget _buildCategoryFilter() {
    if (isLoadingCategories) {
      return const SizedBox(
        height: 44,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = index == 0 ? null : categories[index - 1];

          final isSelected = category == null
              ? selectedCategories.isEmpty
              : selectedCategories.contains(category);

          return GestureDetector(
            onTap: () {
              if (category == null) {
                _clearCategories();
              } else {
                _selectCategory(category);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF217EFA), Color(0xFF1946E4)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : const Color(0xFFE8E8EF),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(
                            0xFF1946E4,
                          ).withValues(alpha: 0.20),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                category != null
                    ? StringUtils.firstLetterUpperCase(category)
                    : 'Toutes',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : const Color(0xFF5F5F70),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _clearCategories() {
    selectedCategories = {};
    _loadNews();
  }
}
