import 'package:flutter/material.dart';
import '../home/Home_Page.dart';
import '../../widgets/BushCloudPainter.dart'; // Adjust path as needed

/// The AdditionalDetailsPage collects extra address details.
class AdditionalDetailsPage extends StatelessWidget {
  const AdditionalDetailsPage({Key? key}) : super(key: key);

  void _redirectToHome(BuildContext context) {
    // Redirect to HomePage using pushReplacement
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double verticalSpace = screenHeight * 0.02;
    final double horizontalPadding = screenWidth * 0.05;
    final double textFieldWidth = screenWidth * 0.85;
    final double textFieldHeight = screenHeight * 0.06;
    final double buttonHeight = screenHeight * 0.06;
    final double logoSize = screenWidth * 0.25;
    final double backButtonSize = screenWidth * 0.08; // e.g. 8% of screen width

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

          // -- Bush
          Positioned(
            top: screenHeight * 0.5,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 100,
              child: CustomPaint(
                painter: BushCloudPainter(heightShift: 1.25),
              ),
            ),
          ),

          // -- Logo & Title (Address text removed)
          Positioned(
            top: screenHeight * 0.05,
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
                // 'Address' text removed.
              ],
            ),
          ),

          // -- Address Fields
          Positioned(
            top: screenHeight * 0.3,
            left: horizontalPadding,
            right: horizontalPadding,
            child: Container(
              padding: EdgeInsets.all(verticalSpace),
              color: Colors.transparent,
              child: Column(
                children: [
                  _buildTextField(
                    hint: 'Street Address',
                    width: textFieldWidth,
                    height: textFieldHeight,
                  ),
                  SizedBox(height: verticalSpace),
                  _buildTextField(
                    hint: 'City',
                    width: textFieldWidth,
                    height: textFieldHeight,
                  ),
                  SizedBox(height: verticalSpace),
                  _buildTextField(
                    hint: 'State',
                    width: textFieldWidth,
                    height: textFieldHeight,
                  ),
                  SizedBox(height: verticalSpace),
                  _buildTextField(
                    hint: 'Postal Zip',
                    width: textFieldWidth,
                    height: textFieldHeight,
                  ),
                  SizedBox(height: verticalSpace * 1.2),
                  // Submit button
                  SizedBox(
                    width: textFieldWidth,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: () => _redirectToHome(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0D522C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: verticalSpace * 0.6),
                  // Do this later button
                  SizedBox(
                    width: textFieldWidth,
                    height: buttonHeight,
                    child: OutlinedButton(
                      onPressed: () => _redirectToHome(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: const BorderSide(color: Color(0xFF0D522C)),
                      ),
                      child: const Text(
                        'Do this later',
                        style: TextStyle(
                          color: Color(0xFF0D522C),
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
                height: screenHeight * 0.000001, // 10% of screen height
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

  // Reusable method for building text fields
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
