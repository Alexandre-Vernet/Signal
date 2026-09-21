import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signal_app/news/news_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../images/proxy_image.dart';
import '../images/source_icon.dart';
import '../utils/date_utils.dart';
import '../utils/error_page.dart';
import '../utils/toast.dart';
import 'news.dart';

class NewsDetail extends StatefulWidget {
  final int newsId;

  const NewsDetail({super.key, required this.newsId});

  @override
  State createState() => NewsDetailState();
}

class NewsDetailState extends State<NewsDetail> {
  final newsService = NewsService();
  News? news;
  bool isLoading = false;
  bool hasError = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
    markNewsAsRead();
  }

  Future<void> markNewsAsRead() async {
    await newsService.markNewsAsRead(widget.newsId);
  }

  Future<void> _loadNews() async {
    try {
      final result = await newsService.findNews(widget.newsId);

      setState(() {
        news = result;
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
    final currentNews = news;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(true),
        ),
        title: const Text(
          'Article',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: currentNews != null
            ? [
                IconButton(
                  tooltip: currentNews.bookmarked == true
                      ? 'Retirer des favoris'
                      : 'Ajouter aux favoris',
                  icon: Icon(
                    currentNews.bookmarked == true
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                  ),
                  onPressed: _toggleBookmark,
                ),
              ]
            : null,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
          ? ErrorPage(onRetry: _loadNews)
          : currentNews != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPublicationImage(currentNews),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSourceIcon(currentNews),

                        const SizedBox(height: 18),

                        Text(
                          currentNews.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),

                        const SizedBox(height: 20),

                        if (currentNews.description != null)
                          Text(
                            currentNews.description!,
                            style: TextStyle(
                              fontSize: 17,
                              height: 1.55,
                              color: Colors.grey.shade700,
                            ),
                          ),

                        const SizedBox(height: 28),

                        _buildTags(currentNews),

                        const SizedBox(height: 32),

                        _buildOriginalArticleButton(currentNews, context),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildPublicationImage(News news) {
    return ProxyImage(
      imageFuture: news.imageUrl != null
          ? newsService.getPublicationImage(news.id)
          : null,
      fallbackUrl: news.imageUrl,
      width: double.infinity,
      height: 280,
    );
  }

  Widget _buildSourceIcon(News news) {
    return Row(
      children: [
        if (news.sourceIcon.isNotEmpty)
          SourceIcon(
            imageFuture: newsService.getSourceIcon(news.id),
            fallbackUrl: news.sourceIcon,
            size: 32,
          ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news.sourceName,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              CustomDateUtils.formatDate(news.publicationDate),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTags(News news) {
    final tags = [...news.categories, ...news.keywords];

    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.take(8).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tag,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOriginalArticleButton(News news, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () async {
          final uri = Uri.parse(news.link);

          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        icon: const Icon(Icons.open_in_new_rounded),
        label: const Text('Lire l’article original'),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleBookmark() async {
    try {
      final response = await newsService.toggleBookmark(widget.newsId);
      if (!mounted) return;

      setState(() {
        news = response;
      });
    } catch (e) {
      if (!mounted) return;

      showToast(context, "Impossible d'enregistrer l'actualité");
    }
  }
}
