import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/controllers/email.verification_controller.dart';
import 'package:lencho/widgets/auth/email_verification_widgets.dart'; // Adjust the import path as needed

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the EmailVerificationController (if you want to use it for resending, etc.)
    final EmailVerificationController controller =
        Get.put(EmailVerificationController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Email Verification')),
      body: Stack(
        children: const [
          EmailVerificationBackgroundWidget(),
          EmailVerificationBackButtonWidget(),
          EmailVerificationBushWidget(),
          EmailVerificationLogoTitleWidget(),
          VerificationWidget(), // The unified widget that checks for verification status.
          EmailVerificationFlowerWidget(),
        ],
      ),
      // Optionally, you can add a floating action button to resend the verification email.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.sendVerificationEmail,
        label: const Text("Resend Email"),
        icon: const Icon(Icons.email),
      ),
    );
  }
}
