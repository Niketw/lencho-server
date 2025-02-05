import 'package:flutter/material.dart';
import '../BushCloudPainter.dart'; // Adjust the path as needed
import '../../screens/auth/details_page.dart'; // For navigating to the AdditionalDetailsPage

/// Widget that builds the background (top yellow and bottom green).
class OtpBackgroundWidget extends StatelessWidget {
  const OtpBackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        // Top background container (yellow)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenHeight * 0.7,
          child: Container(color: const Color(0xFFFFF4BE)),
        ),
        // Bottom background container (green)
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
class OtpBackButtonWidget extends StatelessWidget {
  const OtpBackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double backButtonSize = screenWidth * 0.08;
    return Positioned(
      top: screenHeight * 0.05, // Approximately 5% from the top
      left: screenWidth * 0.04, // Approximately 4% from the left
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
class OtpBushWidget extends StatelessWidget {
  const OtpBushWidget({Key? key}) : super(key: key);

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

/// Widget that displays the logo and title.
class OtpLogoTitleWidget extends StatelessWidget {
  const OtpLogoTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double logoSize = screenWidth * 0.15;
    final double verticalSpace = screenHeight * 0.02;

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

/// Widget for the OTP form (text field and confirm button).
class OtpFormWidget extends StatelessWidget {
  const OtpFormWidget({Key? key}) : super(key: key);

  void _goToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DetailsPage()),
    );
  }

  Widget _buildOtpTextField(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double width  = screenWidth * 0.85;
    final double height = screenHeight * 0.06;

    return SizedBox(
      width: width,
      height: height,
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
            horizontal: width * 0.05,
            vertical: height * 0.2,
          ),
        ),
      ),
    );
  }

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
            _buildOtpTextField(context),
            SizedBox(height: verticalSpace * 1.2),
            SizedBox(
              width: textFieldWidth,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () => _goToDetails(context),
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
    );
  }
}

/// Widget for the flower image pinned at the bottom.
class OtpFlowerWidget extends StatelessWidget {
  const OtpFlowerWidget({Key? key}) : super(key: key);

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
          height: screenHeight * 0.0, // Adjust height if needed
        ),
      ),
    );
  }
}
