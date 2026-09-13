class News {
  final int id;
  final String articleId;
  final String link;
  final String title;
  final String? description;
  final String? imageUrl;
  final List<String> keywords;
  final List<String> categories;
  final List<String> countries;
  final DateTime publicationDate;
  final String sourceName;
  final String sourceIcon;
  final DateTime? readAt;
  final bool? bookmarked;

  News({
    required this.id,
    required this.articleId,
    required this.link,
    required this.title,
    this.description,
    this.imageUrl,
    required this.keywords,
    required this.categories,
    required this.countries,
    required this.publicationDate,
    required this.sourceName,
    required this.sourceIcon,
    this.readAt,
    this.bookmarked,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      articleId: json['articleId'],
      link: json['link'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      keywords: List<String>.from(json['keywords']),
      categories: List<String>.from(json['categories']),
      countries: List<String>.from(json['countries']),
      publicationDate: DateTime.parse(json['publicationDate']),
      sourceName: json['sourceName'],
      sourceIcon: json['sourceIcon'],
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt']),
      bookmarked: json['bookmarked'],
    );
  }
}