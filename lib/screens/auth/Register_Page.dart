import 'package:flutter/material.dart';
import 'Otp_Page.dart'; // Your OTP page
import '../../widgets/auth/register_widgets.dart'; // Import the custom widgets

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  void _goToOtpPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OtpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery here only if needed for layout (e.g., padding)
    final screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const BackgroundWidget(),
          const BackButtonWidget(),
          const BushWidget(),
          const LogoTitleWidget(),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: horizontalPadding,
            right: horizontalPadding,
            child: SingleChildScrollView(
              child: RegistrationFormWidget(
              ),
            ),
          ),
          const FlowerWidget(),
        ],
      ),
    );
  }
}
