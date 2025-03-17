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
          return const Center(child: Text('Error loading campaigns.'));
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
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              child: ListTile(
                title: Text(campaign.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Organisation: ${campaign.organisation}'),
                    Text('Location: ${campaign.location}'),
                    Text('Details: ${campaign.details}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
