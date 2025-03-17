import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/controllers/campaign/campPost_controller.dart';
import 'package:lencho/models/campaign.dart';

class CampaignListWidget extends StatelessWidget {
  CampaignListWidget({Key? key}) : super(key: key);

  final CampaignController controller = Get.put(CampaignController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Campaign>>(
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
          return const Center(child: Text('No campaigns posted yet.'));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: campaigns.length,
          itemBuilder: (context, index) {
            final campaign = campaigns[index];
            return ExpandableCampaignCard(campaign: campaign);
          },
        );
      },
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
  // Fixed collapsed height to show title, organisation, and location.
  final double collapsedHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: 300, // Fixed width for every card.
            height: isExpanded ? null : collapsedHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campaign Title in bold (limited to 2 lines if needed)
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
                // Organisation (non-bold)
                Text(
                  widget.campaign.organisation,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                // Location (non-bold)
                Text(
                  widget.campaign.location,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                // Expand/Collapse arrow button.
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
                // After expansion, show campaign details.
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
    );
  }
}
