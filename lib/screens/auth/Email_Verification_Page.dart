// email_verification_page.dart
import 'package:flutter/material.dart';
import 'package:lencho/widgets/auth/email_verification_widgets.dart'; // Adjust the import path as needed

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Optionally set resizeToAvoidBottomInset if needed.
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Email Verification')),
      body: Stack(
        children: const [
          EmailVerificationBackgroundWidget(),
          EmailVerificationBackButtonWidget(),
          EmailVerificationBushWidget(),
          EmailVerificationLogoTitleWidget(),
          EmailVerificationWidget(),
          EmailVerificationFlowerWidget(),
        ],
      ),
    );
  }
}
