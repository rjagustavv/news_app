import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NewsController extends GetxController {
  var url = 'https://berita-indo-api.vercel.app/v1/cnn-news/'.obs;
  var isTheme = false.obs;
  var search = ''.obs;
  var bookmark = <Map<String, dynamic>>[].obs;
  var newsList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedCategory = ''.obs;

  Future<List<Map<String, dynamic>>> getNews() async {
    final response = await http.get(Uri.parse(url.value));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> data = json['data'];
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Gagal menampilkan berita');
    }
  }

  Future<Map<String, dynamic>> getDetail(String id) async {
    final response = await http.get(Uri.parse(url.value + id));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return json['data'];
    } else {
      throw Exception('Gagal menampilkan detail berita');
    }
  }

  void fetchNews([String category = '']) async {
    try {
      isLoading.value = true;

      String apiUrl;
      if (category.isEmpty) {
        apiUrl = 'https://berita-indo-api.vercel.app/v1/cnn-news/';
      } else {
        switch (category) {
          case 'ekonomi':
            apiUrl = 'https://berita-indo-api.vercel.app/v1/cnbc-news/';
            break;
          case 'teknologi':
            apiUrl = 'https://berita-indo-api.vercel.app/v1/cnn-news/';
            break;
          case 'nasional':
          case 'internasional':
          case 'olahraga':
          case 'hiburan':
            apiUrl = 'https://berita-indo-api.vercel.app/v1/cnn-news/';
            break;
          default:
            apiUrl = 'https://berita-indo-api.vercel.app/v1/cnn-news/';
        }
      }

      url.value = apiUrl;
      selectedCategory.value = category;

      print('Fetching news from: $apiUrl');
      print('Selected category: $category');

      final news = await getNews();

      List<Map<String, dynamic>> filteredNews = news;

      if (category.isNotEmpty && news.isNotEmpty) {
        filteredNews = _filterNewsByCategory(news, category);
      }

      newsList.value = filteredNews;

      print(
        'News loaded: ${filteredNews.length} items for category: $category',
      );

      if (filteredNews.isEmpty && category.isNotEmpty) {
        newsList.value = news;
        selectedCategory.value = '';
        Get.snackbar(
          'Info',
          'No news found for "$category" category, showing all news instead',
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error fetching news: $e');
      Get.snackbar(
        'Error',
        'Failed to load news: Check your internet connection',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> _filterNewsByCategory(
    List<Map<String, dynamic>> news,
    String category,
  ) {
    Map<String, List<String>> categoryKeywords = {
      'ekonomi': [
        'ekonomi',
        'bisnis',
        'saham',
        'rupiah',
        'investasi',
        'bank',
        'keuangan',
        'pasar',
      ],
      'teknologi': [
        'teknologi',
        'digital',
        'internet',
        'smartphone',
        'komputer',
        'AI',
        'startup',
        'aplikasi',
      ],
      'nasional': [
        'indonesia',
        'jakarta',
        'presiden',
        'menteri',
        'pemerintah',
        'nasional',
        'dpr',
        'politik',
      ],
      'internasional': [
        'dunia',
        'amerika',
        'china',
        'eropa',
        'internasional',
        'global',
        'luar negeri',
      ],
      'olahraga': [
        'sepak bola',
        'olahraga',
        'liga',
        'timnas',
        'atlet',
        'pertandingan',
        'kompetisi',
      ],
      'hiburan': [
        'hiburan',
        'film',
        'musik',
        'artis',
        'selebriti',
        'konser',
        'entertainment',
      ],
    };

    if (!categoryKeywords.containsKey(category)) {
      return news;
    }

    List<String> keywords = categoryKeywords[category]!;

    return news.where((item) {
      String title = (item['title'] ?? '').toString().toLowerCase();
      String description = (item['description'] ?? '').toString().toLowerCase();
      String content = title + ' ' + description;

      return keywords.any((keyword) => content.contains(keyword.toLowerCase()));
    }).toList();
  }

  List<Map<String, dynamic>> get filteredNews {
    if (search.value.isEmpty) {
      return newsList;
    }

    return newsList.where((news) {
      final title = (news['title'] ?? '').toString().toLowerCase();
      final description = (news['description'] ?? '').toString().toLowerCase();
      return title.contains(search.value.toLowerCase()) ||
          description.contains(search.value.toLowerCase());
    }).toList();
  }

  void changeTheme() {
    isTheme.value = !isTheme.value;

    if (isTheme.value) {
      Get.changeTheme(
        ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[900],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[850],
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardColor: Colors.grey[800],
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            headlineMedium: TextStyle(color: Colors.white),
            titleLarge: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          dividerColor: Colors.grey[600],
        ),
      );
    } else {
      Get.changeTheme(
        ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardColor: Colors.white,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black87),
            bodyMedium: TextStyle(color: Colors.black54),
            headlineMedium: TextStyle(color: Colors.black87),
            titleLarge: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.black54),
          dividerColor: Colors.grey[300],
        ),
      );
    }

    update();
  }

  bool get isDarkMode => isTheme.value;

  Color get backgroundColor => isDarkMode ? Colors.grey[900]! : Colors.white;
  Color get cardColor => isDarkMode ? Colors.grey[800]! : Colors.white;
  Color get textColor => isDarkMode ? Colors.white : Colors.black87;
  Color get subtitleColor => isDarkMode ? Colors.white70 : Colors.black54;

  void addBookmark(Map<String, dynamic> news) {
    if (!bookmark.contains(news)) {
      bookmark.add(news);
      Get.snackbar(
        'Success',
        'Bookmark added',
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.blue,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Bookmark already exists',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void removeBookmark(Map<String, dynamic> news) {
    bookmark.remove(news);
    Get.snackbar(
      'Success',
      'Bookmark removed',
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.blue,
      colorText: Colors.white,
    );
  }

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }
}
