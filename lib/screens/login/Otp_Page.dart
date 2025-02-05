import 'package:flutter/material.dart';
import '../../widgets/BushCloudPainter.dart'; // Adjust path as needed
import 'details_page.dart'; // Import the additional details page

/// The OtpPage allows the user to enter an OTP and then navigates to the additional details page.
class OtpPage extends StatelessWidget {
  const OtpPage({Key? key}) : super(key: key);

  void _goToAdditionalDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdditionalDetailsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtain screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Helpful relative sizes
    final double verticalSpace = screenHeight * 0.02;
    final double horizontalPadding = screenWidth * 0.05;
    final double textFieldWidth = screenWidth * 0.85;
    final double textFieldHeight = screenHeight * 0.06;
    final double buttonHeight = screenHeight * 0.06;
    final double backButtonSize = screenWidth * 0.08; // e.g. 8% of screen width
    final double logoSize = screenWidth * 0.15;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // -- Background
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

          // -- Bush
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

          // -- OTP Field
          Positioned(
            top: screenHeight * 0.3,
            left: horizontalPadding,
            right: horizontalPadding,
            child: Container(
              padding: EdgeInsets.all(verticalSpace),
              color: Colors.transparent,
              child: Column(
                children: [
                  // OTP text field
                  SizedBox(
                    width: textFieldWidth,
                    height: textFieldHeight,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter OTP',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: textFieldWidth * 0.05,
                          vertical: textFieldHeight * 0.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: verticalSpace * 1.2),
                  // Confirm button
                  SizedBox(
                    width: textFieldWidth,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: () => _goToAdditionalDetails(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0D522C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirm',
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

  // Reusable dots row
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
