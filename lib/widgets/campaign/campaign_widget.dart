import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/controllers/campaign/campPost_controller.dart';
import 'package:lencho/models/campaign.dart';
import 'package:lencho/widgets/home/section_widgets.dart';

class CampaignsSection extends StatelessWidget {
  const CampaignsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure the CampaignController is registered.
    final CampaignController controller = Get.put(CampaignController());

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
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No campaigns posted yet.'),
          );
        }
        // Map each campaign to a SectionItem.
        final items = campaigns.map((campaign) {
          return SectionItem(
            title: campaign.title,
            onTap: () {
              // Navigate to a detailed campaign view.
              Navigator.pushNamed(context, '/campaign/${campaign.id}');
            },
          );
        }).toList();
        return ScrollableSection(
          title: 'Campaigns',
          items: items,
        );
      },
    );
  }
}
