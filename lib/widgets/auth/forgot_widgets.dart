import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/widgets/BushCloudPainter.dart'; // Adjust the path as needed
import 'package:lencho/controllers/forgot_controller.dart'; // Import your controller

/// Widget that paints the top and bottom background colors.
class ForgotBackgroundWidget extends StatelessWidget {
  const ForgotBackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        // Top background container
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenHeight * 0.7,
          child: Container(color: const Color(0xFFFFF4BE)),
        ),
        // Bottom background container
        Positioned(
          top: screenHeight * 0.7,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(color: const Color(0xFFACE268)),
        ),
      ],
    );
  }
}

/// Widget for the back button (top left).
class ForgotBackButtonWidget extends StatelessWidget {
  const ForgotBackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double backButtonSize = screenWidth * 0.08;
    return Positioned(
      top: screenHeight * 0.05, // ~5% from top
      left: screenWidth * 0.04, // ~4% from left
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Image.asset(
          'assets/images/icon/back.png',
          width: backButtonSize,
          height: backButtonSize,
        ),
      ),
    );
  }
}

/// Widget for the decorative bush.
class ForgotBushWidget extends StatelessWidget {
  const ForgotBushWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      top: screenHeight * 0.5,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 100,
        child: CustomPaint(
          painter: BushCloudPainter(heightShift: 1.0),
        ),
      ),
    );
  }
}

/// Widget for displaying the logo.
class ForgotLogoWidget extends StatelessWidget {
  const ForgotLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double logoSize = screenWidth * 0.15;
    return Positioned(
      top: screenHeight * 0.1,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: logoSize,
            height: logoSize,
          ),
        ],
      ),
    );
  }
}

/// Widget for the email text field and reset password button.
class ForgotFormWidget extends StatelessWidget {
  ForgotFormWidget({Key? key}) : super(key: key);

  // Instantiate the ForgotPasswordController using GetX.
  final ForgotPasswordController forgotController = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double verticalSpace   = screenHeight * 0.02;
    final double buttonHeight      = screenHeight * 0.06;
    final double horizontalPadding = screenWidth * 0.05;
    final double textFieldWidth    = screenWidth * 0.85;

    return Positioned(
      top: screenHeight * 0.3,
      left: horizontalPadding,
      right: horizontalPadding,
      child: Container(
        padding: EdgeInsets.all(verticalSpace),
        color: Colors.transparent,
        child: Column(
          children: [
            // Email text field using the controller.
            SizedBox(
              width: textFieldWidth,
              height: screenHeight * 0.06,
              child: TextField(
                controller: forgotController.emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: textFieldWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                ),
              ),
            ),
            SizedBox(height: verticalSpace * 1.2),
            // Reset Password button
            SizedBox(
              width: textFieldWidth,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () => forgotController.resetPassword(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0D522C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Reset Password',
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
    );
  }
}

/// Widget for the flower image pinned at the bottom.
class ForgotFlowerWidget extends StatelessWidget {
  const ForgotFlowerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Image.asset(
          'assets/images/flower.png',
          fit: BoxFit.contain,
          height: screenHeight * 0.0, // Adjust height if needed.
        ),
      ),
    );
  }
}
