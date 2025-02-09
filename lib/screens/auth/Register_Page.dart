import 'package:flutter/material.dart';
import 'package:lencho/screens/auth/Email_Verification_Page.dart'; // Your Email OTP page
import 'package:lencho/screens/auth/Phone_Verification_Page.dart'; // Your Phone Verification page
import 'package:lencho/widgets/auth/register_widgets.dart'; // Import your custom widgets

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Prevent automatic resizing when the keyboard appears.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const BackgroundWidget(),
          const BackButtonWidget(),
          const BushWidget(),
          const LogoTitleWidget(),
          RegistrationFormWidget(),
          const FlowerWidget(),
        ],
      ),
    );
  }
}
