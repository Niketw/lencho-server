import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/controllers/news/agri_news_controller.dart';

class AgricultureNewsSection extends StatelessWidget {
  const AgricultureNewsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure the AgricultureNewsController is registered.
    final AgricultureNewsController controller =
        Get.put(AgricultureNewsController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        if (controller.newsList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No news available at the moment.'),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Agriculture News',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            // Horizontal list of expandable news cards.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.newsList.map((newsItem) {
                  return Container(
                    width: 300, // Fixed width for each card.
                    margin: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                    child: ExpandableNewsCard(newsItem: newsItem),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class ExpandableNewsCard extends StatefulWidget {
  final Map<String, dynamic> newsItem;

  const ExpandableNewsCard({Key? key, required this.newsItem})
      : super(key: key);

  @override
  _ExpandableNewsCardState createState() => _ExpandableNewsCardState();
}

class _ExpandableNewsCardState extends State<ExpandableNewsCard> {
  bool isExpanded = false;
  // Fixed collapsed height to show 3 lines for title and 2 lines for description.
  final double initialCardHeight = 165.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        elevation: 3,
        // Using the same color scheme as the campaigns section.
        color: const Color(0xFFE8F4FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFF2D5A27),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            // Fixed width for every card.
            width: 300,
            // When collapsed, constrain the height; when expanded, let content dictate height.
            child: ConstrainedBox(
              constraints: isExpanded
                  ? const BoxConstraints()
                  : BoxConstraints(maxHeight: initialCardHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // News Title (up to 3 lines when collapsed)
                  Text(
                    widget.newsItem['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: isExpanded ? null : 3,
                    overflow:
                        isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // News Description (up to 2 lines when collapsed)
                  Text(
                    widget.newsItem['description'] ?? 'No description available',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    maxLines: isExpanded ? null : 2,
                    overflow:
                        isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),
                  // Expand/Collapse arrow button.
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
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
        ),
      ),
    );
  }
}
