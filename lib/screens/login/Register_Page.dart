import 'package:flutter/material.dart';
import '../../widgets/BushCloudPainter.dart'; // Adjust path as needed
import 'Otp_Page.dart'; // Navigates to the OTP page

/// The RegisterPage allows the user to register.
/// When the user taps "Send OTP," they are navigated to the OTP page.
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
    // Obtain screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Some helpful relative sizes
    final double verticalSpace = screenHeight * 0.02; // e.g. 2% of screen height
    final double horizontalPadding = screenWidth * 0.05; // 5% horizontal padding
    final double textFieldWidth = screenWidth * 0.85; // text fields ~85% width
    final double textFieldHeight = screenHeight * 0.06;
    final double buttonHeight = screenHeight * 0.06;
    final double backButtonSize = screenWidth * 0.08; // e.g. 8% of screen width
    final double logoSize = screenWidth * 0.25; // e.g. 25% of screen width

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // -- Background: Top (yellow), Bottom (green)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.7,
            child: Container(color: const Color(0xFFFFF4BE)),
          ),
          Positioned(
            top: screenHeight * 0.7,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(color: const Color(0xFFACE268)),
          ),

          // -- Back button (relative positioning)
          Positioned(
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
          ),

          // -- Bush pinned around half the screen
          Positioned(
            top: screenHeight * 0.5,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 100,
              child: CustomPaint(
                painter: BushCloudPainter(heightShift: 1.5),
              ),
            ),
          ),

          // -- Logo & Title at the top
          Positioned(
            top: screenHeight * 0.1,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Logo
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
          ),

          // -- Registration Form
          Positioned(
            top: screenHeight * 0.3,
            left: horizontalPadding,
            right: horizontalPadding,
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(verticalSpace),
                color: Colors.transparent,
                child: Column(
                  children: [
                    // First Name
                    _buildTextField(
                      hint: 'First Name',
                      width: textFieldWidth,
                      height: textFieldHeight,
                    ),
                    SizedBox(height: verticalSpace),
                    // Last Name
                    _buildTextField(
                      hint: 'Last Name',
                      width: textFieldWidth,
                      height: textFieldHeight,
                    ),
                    SizedBox(height: verticalSpace),
                    // Email
                    _buildTextField(
                      hint: 'Email',
                      width: textFieldWidth,
                      height: textFieldHeight,
                    ),
                    SizedBox(height: verticalSpace),
                    // Password
                    _buildTextField(
                      hint: 'Password',
                      obscureText: true,
                      width: textFieldWidth,
                      height: textFieldHeight,
                    ),
                    SizedBox(height: verticalSpace),
                    // Confirm Password
                    _buildTextField(
                      hint: 'Confirm Password',
                      obscureText: true,
                      width: textFieldWidth,
                      height: textFieldHeight,
                    ),
                    SizedBox(height: verticalSpace),
                    // Mobile
                    _buildTextField(
                      hint: 'Mobile',
                      width: textFieldWidth,
                      height: textFieldHeight,
                    ),
                    SizedBox(height: verticalSpace * 1.2),
                    // Send OTP button
                    SizedBox(
                      width: textFieldWidth,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () => _goToOtpPage(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0D522C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Send OTP',
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
          ),

          // -- Flower pinned at bottom
         Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Image.asset(
                'assets/images/flower.png',
                fit: BoxFit.contain,
                height: screenHeight * 0.0, // 0% of screen height
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable method for building text fields with dynamic size
  Widget _buildTextField({
    required String hint,
    required double width,
    required double height,
    bool obscureText = false,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
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

  // Optional: Reusable dots row (if needed elsewhere)
  Widget _buildDotsRow() {
    return Row(
      children: List.generate(
        3,
        (_) => Container(
          margin: const EdgeInsets.only(right: 4),
          width: 3,
          height: 3,
          decoration: const BoxDecoration(
            color: Color(0xFF0D522C),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
