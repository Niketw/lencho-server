import 'package:flutter/material.dart';
import '../BushCloudPainter.dart';
import '../../screens/home/home_page.dart';
import '../../screens/auth/Register_Page.dart';
import '../../screens/auth/Forgot_Page.dart';

/// The background splits the screen into a yellow top and a green bottom.
class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({Key? key}) : super(key: key);

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

/// TopDotsWidget shows the decorative dots on the top.
class TopDotsWidget extends StatelessWidget {
  const TopDotsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth  = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(screenHeight * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(
              3,
              (_) => Container(
                margin: EdgeInsets.only(right: screenWidth * 0.01),
                width: screenWidth * 0.008,
                height: screenWidth * 0.008,
                decoration: const BoxDecoration(
                  color: Color(0xFF0D522C),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Row(
            children: List.generate(
              3,
              (_) => Container(
                margin: EdgeInsets.only(right: screenWidth * 0.01),
                width: screenWidth * 0.008,
                height: screenWidth * 0.008,
                decoration: const BoxDecoration(
                  color: Color(0xFF0D522C),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// BushAnimationWidget shows the animated bush using the custom painter.
class BushAnimationWidget extends StatelessWidget {
  final bool showLogin;
  const BushAnimationWidget({Key? key, required this.showLogin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth  = MediaQuery.of(context).size.width;
    const double bushHeight = 100;
    // Compute top positions for animation
    final double bushTopNotShown = screenHeight * 0.5 - bushHeight + 20;
    final double bushTopShown    = screenHeight * 0.5 - bushHeight;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      top: showLogin ? bushTopShown : bushTopNotShown,
      left: 0,
      right: 0,
      child: SizedBox(
        height: bushHeight,
        width: screenWidth,
        child: CustomPaint(
          painter: BushCloudPainter(heightShift: 1.5),
        ),
      ),
    );
  }
}

/// LogoCompanyWidget shows the company logo and name with animation.
class LogoCompanyWidget extends StatelessWidget {
  const LogoCompanyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Screen dimensions and responsive dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth  = MediaQuery.of(context).size.width;
    final double verticalSpace  = screenHeight * 0.02;
    final double fontSizeLarge  = screenHeight * 0.03;
    final double logoSizeBig    = screenWidth * 0.4;

    return Positioned(
      top: screenHeight * 0.1,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated logo size
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: logoSizeBig,
            height: logoSizeBig,
            // You could later pass a flag to change size when login is shown.
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: verticalSpace * 0.4),
          // Animated text style
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 500),
            style: TextStyle(
              fontSize: fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D522C),
            ),
            child: const Text('Lencho Inc.'),
          ),
        ],
      ),
    );
  }
}

/// GetStartedButtonWidget displays the "Get Started" button.
class GetStartedButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const GetStartedButtonWidget({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Compute dimensions responsively
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth  = MediaQuery.of(context).size.width;
    final double horizontalSpace = screenWidth * 0.05;
    final double fieldWidth  = screenWidth * 0.85;
    final double buttonHeight = screenHeight * 0.065;
    final double borderRadius = screenHeight * 0.015;
    final double fontSizeNormal = screenHeight * 0.02;

    return Center(
      child: SizedBox(
        width: fieldWidth * 0.7,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalSpace,
              vertical: screenHeight * 0.015,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: Text(
            "Get Started",
            style: TextStyle(
              fontSize: fontSizeNormal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// PositionedLoginForm holds the login form and related buttons.
class PositionedLoginForm extends StatelessWidget {
  const PositionedLoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth  = MediaQuery.of(context).size.width;
    final double verticalSpace   = screenHeight * 0.02;
    final double horizontalSpace = screenWidth * 0.05;
    final double fieldWidth      = screenWidth * 0.85;
    final double buttonHeight    = screenHeight * 0.065;
    final double borderRadius    = screenHeight * 0.015;
    final double fontSizeNormal  = screenHeight * 0.02;

    return Positioned(
      top: screenHeight * 0.35,
      left: (screenWidth - fieldWidth) / 2,
      right: (screenWidth - fieldWidth) / 2,
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: Container(
          padding: EdgeInsets.all(verticalSpace),
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name field
                SizedBox(
                  width: fieldWidth,
                  child: TextField(
                    style: TextStyle(fontSize: fontSizeNormal),
                    decoration: InputDecoration(
                      hintText: 'Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: horizontalSpace,
                        vertical: screenHeight * 0.015,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: verticalSpace),
                // Password field
                SizedBox(
                  width: fieldWidth,
                  child: TextField(
                    obscureText: true,
                    style: TextStyle(fontSize: fontSizeNormal),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: horizontalSpace,
                        vertical: screenHeight * 0.015,
                      ),
                    ),
                  ),
                ),
                // Forgot link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot?',
                      style: TextStyle(
                        color: const Color(0xFF0D522C),
                        fontWeight: FontWeight.w600,
                        fontSize: fontSizeNormal,
                      ),
                    ),
                  ),
                ),
                // Log In button
                SizedBox(
                  width: fieldWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0D522C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: fontSizeNormal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Or divider
                Padding(
                  padding: EdgeInsets.symmetric(vertical: verticalSpace),
                  child: Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.black54)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                        ),
                        child: Text(
                          'Or',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: fontSizeNormal,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.black54)),
                    ],
                  ),
                ),
                // Register button
                SizedBox(
                  width: fieldWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0D522C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: fontSizeNormal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Social login buttons
                SizedBox(height: verticalSpace),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIconButton(
                      assetPath: 'assets/images/icon/google.png',
                      screenWidth: screenWidth,
                    ),
                    SizedBox(width: screenWidth * 0.06),
                    SocialIconButton(
                      assetPath: 'assets/images/icon/meta.png',
                      screenWidth: screenWidth,
                    ),
                  ],
                ),
                SizedBox(height: verticalSpace),
                Text(
                  'www.lencho.com',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: fontSizeNormal * 0.9,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// SocialIconButton is a helper widget to display circular social icons.
class SocialIconButton extends StatelessWidget {
  final String assetPath;
  final double screenWidth;
  const SocialIconButton({
    Key? key,
    required this.assetPath,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.12,
      height: screenWidth * 0.12,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Image.asset(assetPath),
      ),
    );
  }
}

/// FlowerWidget shows the fixed flower at the bottom.
class FlowerWidget extends StatelessWidget {
  const FlowerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        'assets/images/flower.png',
        fit: BoxFit.contain,
        height: screenHeight * 0.1,
      ),
    );
  }
}
