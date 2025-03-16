import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AgricultureNewsController extends GetxController {
  // Replace with your actual newsdata.io API key.
  final String apiKey = dotenv.env['NEWS_API'] ?? '';
  final String country = 'in';

  // Observable variables to update the UI.
  var isLoading = true.obs;
  var newsList = <dynamic>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  /// Fetches agriculture news from newsdata.io.
  Future<void> fetchNews() async {
    isLoading.value = true;
    try {
      final String url =
          'https://newsdata.io/api/1/news?apikey=$apiKey&q=agriculture%20farmer&country=$country';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        newsList.value = data['results'] ?? [];
      } else {
        errorMessage.value = 'Error fetching news: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching news: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
