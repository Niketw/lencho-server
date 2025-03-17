import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/controllers/campaign/campPost_controller.dart';

class CampaignPostingWidget extends StatelessWidget {
  CampaignPostingWidget({Key? key}) : super(key: key);

  final CampaignController controller = Get.put(CampaignController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers for the form fields.
  final TextEditingController titleController = TextEditingController();
  final TextEditingController organisationController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double verticalSpace = screenHeight * 0.02;
    final double textFieldWidth = screenWidth * 0.85;
    final double buttonHeight = screenHeight * 0.06;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Campaign'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(verticalSpace),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title Field
              SizedBox(
                width: textFieldWidth,
                child: TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Campaign Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a campaign title';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: verticalSpace),
              // Organisation Field
              SizedBox(
                width: textFieldWidth,
                child: TextFormField(
                  controller: organisationController,
                  decoration: const InputDecoration(
                    labelText: 'Organisation',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an organisation';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: verticalSpace),
              // Location Field
              SizedBox(
                width: textFieldWidth,
                child: TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: verticalSpace),
              // Details Field
              SizedBox(
                width: textFieldWidth,
                child: TextFormField(
                  controller: detailsController,
                  decoration: const InputDecoration(
                    labelText: 'Details',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter campaign details';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: verticalSpace * 1.5),
              // Submit Button
              SizedBox(
                width: textFieldWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await controller.postCampaign(
                        title: titleController.text.trim(),
                        organisation: organisationController.text.trim(),
                        location: locationController.text.trim(),
                        details: detailsController.text.trim(),
                      );
                      // Optionally clear the form fields after posting.
                      titleController.clear();
                      organisationController.clear();
                      locationController.clear();
                      detailsController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Post Campaign',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
