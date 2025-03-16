import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/controllers/news/agri_news_controller.dart';

class AgricultureNewsWidget extends StatelessWidget {
  const AgricultureNewsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make sure the controller is available in the dependency tree.
    final AgricultureNewsController controller = Get.find();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.errorMessage.isNotEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      }
      return ListView.builder(
        itemCount: controller.newsList.length,
        itemBuilder: (context, index) {
          final newsItem = controller.newsList[index];
          return ListTile(
            title: Text(newsItem['title'] ?? 'No Title'),
            subtitle:
                Text(newsItem['description'] ?? 'No description available'),
            onTap: () {
              // Optionally, implement navigation to a details page or open the URL.
            },
          );
        },
      );
    });
  }
}
