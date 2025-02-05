import 'package:flutter/material.dart';
import '../../widgets/BushCloudPainter.dart'; // Adjust path as needed

/// The ForgotPasswordPage allows the user to request a password reset.
/// It includes an email text field and a "Reset Password" button.
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  void _resetPassword(BuildContext context) {
    // TODO: Implement password reset logic (e.g., call a backend service)
    Navigator.pop(context); // For now, simply pop back.
  }

  @override
  Widget build(BuildContext context) {
    // Obtain screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define some relative sizes
    final double verticalSpace = screenHeight * 0.02;
    final double horizontalPadding = screenWidth * 0.05;
    final double textFieldWidth = screenWidth * 0.85;
    final double textFieldHeight = screenHeight * 0.06;
    final double buttonHeight = screenHeight * 0.06;
    final double logoSize = screenWidth * 0.15;
    final double backButtonSize = screenWidth * 0.08;

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

          // -- Back Button (top left)
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

          // -- Bush (decorative)
          Positioned(
            top: screenHeight * 0.5,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 100,
              child: CustomPaint(
                painter: BushCloudPainter(heightShift: 1.0),
              ),
            ),
          ),

          // -- Logo & Title
          Positioned(
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
          ),

          // -- Email Field and Reset Button
          Positioned(
            top: screenHeight * 0.3,
            left: horizontalPadding,
            right: horizontalPadding,
            child: Container(
              padding: EdgeInsets.all(verticalSpace),
              color: Colors.transparent,
              child: Column(
                children: [
                  // Email Text Field
                  _buildTextField(
                    hint: 'Email',
                    width: textFieldWidth,
                    height: textFieldHeight,
                  ),
                  SizedBox(height: verticalSpace * 1.2),
                  // Reset Password Button
                  SizedBox(
                    width: textFieldWidth,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: () => _resetPassword(context),
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

  // Reusable method for building a row of dots
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

  // Reusable method for building a text field
  Widget _buildTextField({
    required String hint,
    required double width,
    required double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
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
