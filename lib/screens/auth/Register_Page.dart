import 'package:flutter/material.dart';
import 'Email_Verification_Page.dart'; // Your Email OTP page
import 'Phone_Verification_Page.dart'; // Your Phone Verification page
import '../../widgets/auth/register_widgets.dart'; // Import the custom widgets

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const BackgroundWidget(),
          const BackButtonWidget(),
          const BushWidget(),
          const LogoTitleWidget(),
          // Make only the form scrollable:
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: RegistrationFormWidget(),
            ),
          ),
          const FlowerWidget(),
        ],
      ),
    );
  }
}
