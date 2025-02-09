import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/screens/auth/Details_Page.dart';
import 'package:lencho/widgets/BushCloudPainter.dart';

/// -----------------------------------------------------------------
/// Email Verification Background (unchanged)
/// -----------------------------------------------------------------
class EmailVerificationBackgroundWidget extends StatelessWidget {
  const EmailVerificationBackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
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
      ],
    );
  }
}

/// -----------------------------------------------------------------
/// Email Verification Back Button (unchanged)
/// -----------------------------------------------------------------
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

/// -----------------------------------------------------------------
/// Email Verification Bush (unchanged)
/// -----------------------------------------------------------------
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

/// -----------------------------------------------------------------
/// Email Verification Logo & Title (unchanged)
/// -----------------------------------------------------------------
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

/// -----------------------------------------------------------------
/// Email Verification Flower (unchanged)
/// -----------------------------------------------------------------
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
          height: screenHeight * 0.1, // Adjust height if needed
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------
/// Unified Verification Widget
///
/// This widget checks if the user is verified by either email or phone.
/// While checking, it cycles continuously through three loading images.
/// Once verified, it displays a tick image briefly and then automatically navigates to DetailsPage.
/// -----------------------------------------------------------------
class VerificationWidget extends StatefulWidget {
  const VerificationWidget({Key? key}) : super(key: key);

  @override
  State<VerificationWidget> createState() => _VerificationWidgetState();
}

class _VerificationWidgetState extends State<VerificationWidget> {
  // Flags to control verification state.
  bool isVerifying = true;
  bool isVerified = false;

  // Timer for cycling through the loading images.
  late Timer loadingTimer;
  int loadingIndex = 0;

  // List of loading images to cycle through.
  final List<String> loadingImages = [
    'assets/images/loading-1.png',
    'assets/images/loading-2.png',
    'assets/images/loading-3.png',
  ];

  @override
  void initState() {
    super.initState();
    _startLoadingAnimation();
    _checkVerification();
  }

  void _startLoadingAnimation() {
    // This timer will update the loading image index every 500ms.
    loadingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      // Continue looping the loading images until verification is complete.
      if (!isVerified) {
        setState(() {
          loadingIndex = (loadingIndex + 1) % loadingImages.length;
        });
      }
    });
  }

  Future<void> _checkVerification() async {
    // Optionally wait for a short period before checking.
    await Future.delayed(const Duration(seconds: 2));

    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    // Check if the user is verified either by email or by phone.
    if (user != null &&
        (user.emailVerified ||
         (user.phoneNumber != null && user.phoneNumber!.isNotEmpty))) {
      setState(() {
        isVerified = true;
        isVerifying = false;
      });
      Get.snackbar('Success', 'Verification successful.');
      loadingTimer.cancel(); // Stop the loading animation.
      // Wait briefly to show the tick image before navigating.
      await Future.delayed(const Duration(seconds: 1));
      Get.offAll(() => const DetailsPage());
    } else {
      // If not verified, keep the animation running.
      setState(() {
        isVerifying = true;
      });
      // Optionally, schedule another verification check after a delay.
      Future.delayed(const Duration(seconds: 5), () {
        if (!isVerified) {
          _checkVerification();
        }
      });
    }
  }

  @override
  void dispose() {
    loadingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      left: screenWidth * 0.05,
      right: screenWidth * 0.05,
      child: Center(
        child: isVerified
            ? Image.asset(
                'assets/images/tick.png',
                width: screenWidth * 0.5,
              )
            : Image.asset(
                loadingImages[loadingIndex],
                width: screenWidth * 0.5,
              ),
      ),
    );
  }
}
