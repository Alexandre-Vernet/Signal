import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signal_app/news/news_service.dart';
import 'package:signal_app/utils/date_utils.dart';
import '../images/proxy_image.dart';
import '../images/source_icon.dart';
import 'news.dart';

class NewsList extends StatefulWidget {
  final News news;
  final VoidCallback? onTap;

  const NewsList({super.key, required this.news, this.onTap});

  @override
  State createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  final newsService = NewsService();
  late final Future<Uint8List> imageFuture;
  late final Future<Uint8List> sourceIconFuture;

  @override
  void initState() {
    super.initState();
    imageFuture = newsService.getPublicationImage(widget.news.id);
    sourceIconFuture = newsService.getSourceIcon(widget.news.id);
  }

  @override
  Widget build(BuildContext context) {
    final isRead = widget.news.readAt != null;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPublicationImage(),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSourceIcon(),

                    const SizedBox(height: 8),

                    Text(
                      widget.news.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        isRead ? FontWeight.w500 : FontWeight.w700,
                        height: 1.2,
                        color: isRead
                            ? Colors.grey.shade700
                            : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 7),

                    if (widget.news.description != null)
                      Text(
                        widget.news.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.35,
                          color: Colors.grey.shade600,
                        ),
                      ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        if (widget.news.categories.isNotEmpty)
                          _buildTag(widget.news.categories.first),

                        const Spacer(),

                        if (isRead)
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 17,
                            color: Colors.grey.shade400,
                          ),

                        if (isRead)
                          const SizedBox(width: 8),

                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPublicationImage() {
    if (widget.news.imageUrl == null || widget.news.imageUrl!.isEmpty) {
      return Container(
        width: 115,
        height: 130,
        color: Colors.grey.shade100,
        child: Icon(Icons.image_outlined, color: Colors.grey.shade400),
      );
    }

    return ProxyImage(
      imageFuture: imageFuture,
      fallbackUrl: widget.news.imageUrl,
      width: 115,
      height: 130,
      borderRadius: BorderRadius.circular(14),
    );
  }

  Widget _buildSourceIcon() {
    return Row(
      children: [
        if (widget.news.sourceIcon.isNotEmpty)
          SourceIcon(
            imageFuture: sourceIconFuture,
            fallbackUrl: widget.news.sourceIcon,
            size: 22,
          ),

        const SizedBox(width: 7),

        Expanded(
          child: Text(
            widget.news.sourceName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),

        Text(
          CustomDateUtils.formatDate(widget.news.publicationDate),
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.blue,
        ),
      ),
    );
  }
}
