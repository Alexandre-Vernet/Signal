import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:signal_app/news/news.dart';
import 'dart:typed_data';

import 'package:signal_app/user/user_service.dart';

class NewsService {
  final String baseUrl = "https://signal-api.alexandre-vernet.fr/api";
  // final String baseUrl = "http://localhost:8080/api";

  final UserService userService = UserService();

  Future<List<News>> findAllNews() async {
    final uuid = await userService.getUuid();
    final response = await http.get(
      Uri.parse('$baseUrl/news'),
      headers: {"X-User-UUID": uuid},
    );
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);

      return json.map((item) => News.fromJson(item)).toList();
    }

    throw Exception('Erreur lors du chargement des actualités');
  }

  Future<News> findNews(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/news/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      return News.fromJson(json);
    }

    throw Exception('Erreur lors du chargement des actualités');
  }

  Future<Uint8List> getPublicationImage(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/news/$id/image/publication-image'),
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception('Erreur lors du chargement des images');
  }

  Future<Uint8List> getSourceIcon(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/news/$id/image/source-icon'),
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception('Erreur lors du chargement des images');
  }

  Future<List<String>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/news/categories'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast();
    }

    throw Exception('Erreur lors du chargement des catégories');
  }

  Future<List<News>> getNewsByCategories(List<String> categories) async {
    final uri = Uri.parse('$baseUrl/news/category').replace(
      query: categories
          .map(
            (category) =>
                'category=${Uri.encodeQueryComponent(category.toLowerCase())}',
          )
          .join('&'),
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => News.fromJson(json)).toList();
    }

    throw Exception('Erreur lors du chargement des news');
  }

  Future<News> markNewsAsRead(int id) async {
    final uuid = await userService.getUuid();
    final response = await http.post(
      Uri.parse('$baseUrl/news/$id/read'),
      headers: {"X-User-UUID": uuid},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      return News.fromJson(json);
    }

    throw Exception('Erreur lors du chargement des actualités');
  }

  Future<News> toggleBookmark(int id) async {
    final uuid = await userService.getUuid();
    final response = await http.post(
      Uri.parse('$baseUrl/news/$id/bookmark'),
      headers: {"X-User-UUID": uuid},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      return News.fromJson(json);
    }

    throw Exception('Erreur lors du chargement des actualités');
  }

  Future<List<News>> getBookmarkNews() async {
    final uuid = await userService.getUuid();
    final response = await http.get(
      Uri.parse('$baseUrl/news/bookmark'),
      headers: {"X-User-UUID": uuid},
    );
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);

      return json.map((item) => News.fromJson(item)).toList();
    }

    throw Exception('Erreur lors du chargement des actualités');
  }
}
