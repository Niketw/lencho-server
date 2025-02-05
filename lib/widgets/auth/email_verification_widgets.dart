// verification_widgets.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/screens/auth/Details_Page.dart'; // Adjust: destination after EmailVerification
import 'package:lencho/widgets/BushCloudPainter.dart'; // Adjust the path as needed

/// -----------------------
/// VerficationBackgroundWidget (unchanged)
/// -----------------------
class EmailVerificationBackgroundWidget extends StatelessWidget {
  const EmailVerificationBackgroundWidget({Key? key}) : super(key: key);

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

/// -----------------------
/// VerficationBackButtonWidget (unchanged)
/// -----------------------
class EmailVerificationBackButtonWidget extends StatelessWidget {
  const EmailVerificationBackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double backButtonSize = screenWidth * 0.08;
    return Positioned(
      top: screenHeight * 0.05,
      left: screenWidth * 0.04,
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

/// -----------------------
/// VerficationBushWidget (unchanged)
/// -----------------------
class EmailVerificationBushWidget extends StatelessWidget {
  const EmailVerificationBushWidget({Key? key}) : super(key: key);

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

/// -----------------------
/// VerficationLogoTitleWidget (unchanged)
/// -----------------------
class EmailVerificationLogoTitleWidget extends StatelessWidget {
  const EmailVerificationLogoTitleWidget({Key? key}) : super(key: key);

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

/// -----------------------
/// VerficationFlowerWidget (unchanged)
/// -----------------------
class EmailVerificationFlowerWidget extends StatelessWidget {
  const EmailVerificationFlowerWidget({Key? key}) : super(key: key);

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

/// -----------------------
/// EmailEmailVerificationWidget
/// -----------------------
/// This widget replaces the Verfication form (textfield and button) with a full-screen
/// EmailVerification indicator. It displays a large loading image while checking
/// email EmailVerification status. When verified, it switches to a tick image and then
/// navigates to the next screen.
class EmailVerificationWidget extends StatefulWidget {
  const EmailVerificationWidget({Key? key}) : super(key: key);

  @override
  State<EmailVerificationWidget> createState() => _EmailVerificationWidgetState();
}

class _EmailVerificationWidgetState extends State<EmailVerificationWidget> {
  bool isVerifying = true;
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    _checkEmailVerified();
  }

  Future<void> _checkEmailVerified() async {
    setState(() {
      isVerifying = true;
    });

    // Optionally, wait a moment to simulate a smooth transition.
    await Future.delayed(const Duration(seconds: 2));

    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      setState(() {
        isVerified = true;
        isVerifying = false;
      });
      Get.snackbar('Success', 'Email verified successfully.');
      // Wait briefly to show the tick image before navigating.
      await Future.delayed(const Duration(seconds: 1));
      Get.offAll(() => const DetailsPage());
    } else {
      // If not verified, stop the spinner and let the user retry by tapping.
      setState(() {
        isVerifying = false;
      });
      Get.snackbar('Not Verified', 'Email not verified yet. Please check your inbox.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      left: screenWidth * 0.05,
      right: screenWidth * 0.05,
      child: Center(
        child: isVerifying
            ? Image.asset(
                'assets/images/loading.png', // Your loading image asset
                width: screenWidth * 0.5,
              )
            : isVerified
                ? Image.asset(
                    'assets/images/tick.png', // Your tick image asset
                    width: screenWidth * 0.5,
                  )
                : GestureDetector(
                    onTap: _checkEmailVerified,
                    child: Image.asset(
                      'assets/images/loading.png', // Still show the loading asset so user can tap to retry
                      width: screenWidth * 0.5,
                    ),
                  ),
      ),
    );
  }
}
