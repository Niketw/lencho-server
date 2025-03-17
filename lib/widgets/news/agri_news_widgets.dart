import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/controllers/news/agri_news_controller.dart';

class AgricultureNewsSection extends StatelessWidget {
  const AgricultureNewsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AgricultureNewsController controller =
        Get.put(AgricultureNewsController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.errorMessage.isNotEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      }
      // Use a horizontal scroll view with a Row.
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.newsList.map((newsItem) {
            return Container(
              width: 300, // Fixed width for each card; height is determined by its content.
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ExpandableNewsCard(newsItem: newsItem),
            );
          }).toList(),
        ),
      );
    });
  }
}

class ExpandableNewsCard extends StatefulWidget {
  final Map<String, dynamic> newsItem;

  const ExpandableNewsCard({Key? key, required this.newsItem})
      : super(key: key);

  @override
  _ExpandableNewsCardState createState() => _ExpandableNewsCardState();
}

class _ExpandableNewsCardState extends State<ExpandableNewsCard>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      // No vsync parameter is needed in newer Flutter versions.
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Let the Column size itself to its content.
            children: [
              // Title
              Text(
                widget.newsItem['title'] ?? 'No Title',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Description: show only two lines if not expanded.
              Text(
                widget.newsItem['description'] ?? 'No description available',
                maxLines: isExpanded ? null : 2,
                overflow:
                    isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              // Expand/Collapse button.
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
