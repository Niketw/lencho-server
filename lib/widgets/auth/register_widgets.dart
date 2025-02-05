import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/controllers/register_controller.dart';
import 'package:lencho/widgets/BushCloudPainter.dart';

// Import your verification pages.
import 'package:lencho/screens/auth/Email_Verification_Page.dart';
import 'package:lencho/screens/auth/Phone_Verification_Page.dart';

/// Widget that paints the top and bottom background colors.
class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to obtain the screen height.
    final screenHeight = MediaQuery.of(context).size.height;
    const Color topColor = Color(0xFFFFF4BE);
    const Color bottomColor = Color(0xFFACE268);
    return Stack(
      children: [
        // Top background container.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenHeight * 0.7,
          child: Container(color: topColor),
        ),
        // Bottom background container.
        Positioned(
          top: screenHeight * 0.7,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(color: bottomColor),
        ),
      ],
    );
  }
}

/// Widget for the back button.
class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions.
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double backButtonSize = screenWidth * 0.08;
    return Positioned(
      top: screenHeight * 0.05, // ~5% from top.
      left: screenWidth * 0.04, // ~4% from left.
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

/// Widget for the bush design using a CustomPainter.
class BushWidget extends StatelessWidget {
  const BushWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtain screen height from MediaQuery.
    final screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      top: screenHeight * 0.5,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 100,
        child: CustomPaint(
          painter: BushCloudPainter(heightShift: 1.5),
        ),
      ),
    );
  }
}

/// Widget for displaying the logo and company title.
class LogoTitleWidget extends StatelessWidget {
  const LogoTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtain screen dimensions and define sizes.
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double logoSize = screenWidth * 0.25;
    final double verticalSpace = screenHeight * 0.02;

    return Positioned(
      top: screenHeight * 0.1,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Logo image.
          Image.asset(
            'assets/images/logo.png',
            width: logoSize,
            height: logoSize,
          ),
          SizedBox(height: verticalSpace * 0.4),
          const Text(
            'Lencho Inc.',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D522C),
            ),
          ),
        ],
      ),
    );
  }
}

/// The registration form widget containing text fields and two buttons.
class RegistrationFormWidget extends StatelessWidget {
  RegistrationFormWidget({Key? key}) : super(key: key);

  // Retrieve the RegisterController instance via GetX.
  final RegisterController controller = Get.put(RegisterController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Obtain screen dimensions and compute relative sizes.
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double verticalSpace = screenHeight * 0.02;
    final double textFieldWidth = screenWidth * 0.85;
    final double buttonHeight = screenHeight * 0.06;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(verticalSpace),
      color: Colors.transparent,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field.
            RegisterTextField(
              controller: controller.nameController,
              hint: 'Name',
            ),
            SizedBox(height: verticalSpace),
            // Email field.
            RegisterTextField(
              controller: controller.emailController,
              hint: 'Email',
            ),
            SizedBox(height: verticalSpace),
            // Password field.
            RegisterTextField(
              controller: controller.passwordController,
              hint: 'Password',
              obscureText: true,
            ),
            SizedBox(height: verticalSpace),
            // Confirm Password field.
            RegisterTextField(
              controller: controller.confirmPasswordController,
              hint: 'Confirm Password',
              obscureText: true,
            ),
            SizedBox(height: verticalSpace),
            // Mobile field.
            RegisterTextField(
              controller: controller.mobileController,
              hint: 'Mobile',
            ),
            SizedBox(height: verticalSpace * 1.2),
            // Row with two buttons: Register with Email and Register with Phone.
            SizedBox(
              width: textFieldWidth,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmailVerificationPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0D522C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Register with Email',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PhoneVerificationPage(verificationId: ''),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0D522C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Register with Phone',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A reusable text field for the registration form.
class RegisterTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController controller;

  const RegisterTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Compute dimensions internally.
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double width = screenWidth * 0.85;
    final double height = screenHeight * 0.06;

    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.2,
          ),
        ),
      ),
    );
  }
}

/// Widget for the flower image pinned at the bottom.
class FlowerWidget extends StatelessWidget {
  const FlowerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen height for possible adjustments.
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
