import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/controllers/campaign/campPost_controller.dart';
import 'package:lencho/models/campaign.dart';

class CampaignsSection extends StatelessWidget {
  const CampaignsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure the CampaignController is registered.
    final CampaignController controller = Get.put(CampaignController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Overall horizontal padding
      child: StreamBuilder<List<Campaign>>(
        stream: controller.streamCampaigns(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading campaigns: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final campaigns = snapshot.data!;
          if (campaigns.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No campaigns posted yet.'),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section title
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Campaigns',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              // Horizontal list of expandable campaign cards.
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: campaigns.map((campaign) {
                    return Container(
                      width: 300, // Fixed width for each card.
                      margin: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                      child: ExpandableCampaignCard(campaign: campaign),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ExpandableCampaignCard extends StatefulWidget {
  final Campaign campaign;

  const ExpandableCampaignCard({Key? key, required this.campaign})
      : super(key: key);

  @override
  _ExpandableCampaignCardState createState() => _ExpandableCampaignCardState();
}

class _ExpandableCampaignCardState extends State<ExpandableCampaignCard> {
  bool isExpanded = false;
  // Fixed collapsed height to display:
  // - Title (2 lines)
  // - Organisation (1 line)
  // - Location (1 line)
  final double collapsedHeight = 146.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        elevation: 2,
        // Use same color scheme as news section.
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
            width: 300, // Fixed width for every card.
            // When collapsed, constrain the height; when expanded, let content dictate height.
            child: ConstrainedBox(
              constraints: isExpanded
                  ? const BoxConstraints()
                  : BoxConstraints(maxHeight: collapsedHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campaign Title in bold (2 lines max when collapsed)
                  Text(
                    widget.campaign.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: isExpanded ? null : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Organisation (non-bold, single line)
                  Text(
                    widget.campaign.organisation,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Location (non-bold, single line)
                  Text(
                    widget.campaign.location,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                  // When expanded, show campaign details.
                  if (isExpanded) ...[
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      widget.campaign.details,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
