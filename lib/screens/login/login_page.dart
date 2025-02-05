import 'package:flutter/material.dart';
import '../home/home_page.dart';
import 'Register_Page.dart';
import 'Forgot_Page.dart'; // Import the forgot password page
import '../../widgets/BushCloudPainter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  bool _showLogin = false;

  void _onGetStarted() {
    setState(() {
      _showLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1) Obtain screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth  = MediaQuery.of(context).size.width;

    // 2) Define reusable "responsive" dimensions
    final double verticalSpace    = screenHeight * 0.02;  // 2% of height
    final double horizontalSpace  = screenWidth  * 0.05;  // 5% of width
    final double fieldWidth       = screenWidth  * 0.85;  // 85% of width
    final double buttonHeight     = screenHeight * 0.065; // ~6.5% of height
    final double borderRadius     = screenHeight * 0.015; // for rounded corners
    final double fontSizeNormal   = screenHeight * 0.02;  // 2% of height
    final double fontSizeLarge    = screenHeight * 0.03;  // 3% of height
    final double logoSizeBig      = screenWidth  * 0.4;   // 40% of width
    final double logoSizeSmall    = screenWidth  * 0.25;  // 25% of width

    // 3) Bush animation logic remains the same
    const double bushHeight = 100;
    final double bushTopNotShown = screenHeight * 0.5 - bushHeight + 20;
    final double bushTopShown    = screenHeight * 0.5 - bushHeight;

    return Scaffold(
      // Prevent the layout from resizing when the keyboard appears.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // -- Background: Top (yellow) & Bottom (green) --
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

          // -- Optional top dots --
          Padding(
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
          ),

          // -- Animated Bush using the BushCloudPainter --
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            top: _showLogin ? bushTopShown : bushTopNotShown,
            left: 0,
            right: 0,
            child: SizedBox(
              height: bushHeight,
              width: screenWidth,
              child: CustomPaint(
                painter: BushCloudPainter(heightShift: 1.5),
              ),
            ),
          ),

          // -- Logo & Company Name --
          Positioned(
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
                  width: _showLogin ? logoSizeSmall : logoSizeBig,
                  height: _showLogin ? logoSizeSmall : logoSizeBig,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: verticalSpace * 0.4),
                // Animated text size
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 500),
                  style: TextStyle(
                    fontSize: _showLogin ? fontSizeNormal : fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D522C),
                  ),
                  child: const Text('Lencho Inc.'),
                ),
              ],
            ),
          ),

          // -- "Get Started" button (visible before login) --
          if (!_showLogin)
            Center(
              child: SizedBox(
                width: fieldWidth * 0.7, // e.g. 70% of fieldWidth
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: _onGetStarted,
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
            ),

          // -- Login Form (centered vertically between text & flower) --
          if (_showLogin)
            Positioned(
              // ~45% of screen height to visually center between "Lencho Inc." & bottom flower
              top: screenHeight * 0.30,
              left: (screenWidth - fieldWidth) / 2,
              right: (screenWidth - fieldWidth) / 2,
              child: AnimatedOpacity(
                opacity: _showLogin ? 1.0 : 0.0,
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

                        // Forgot link that redirects to the Forgot Password page
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
                            Container(
                              width: screenWidth * 0.12,
                              height: screenWidth * 0.12,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.03),
                                child: Image.asset(
                                  'assets/images/icon/google.png',
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.06),
                            Container(
                              width: screenWidth * 0.12,
                              height: screenWidth * 0.12,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.03),
                                child: Image.asset(
                                  'assets/images/icon/meta.png',
                                ),
                              ),
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
            ),

          // -- Flower pinned at bottom (fixed, even if keyboard opens) --
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/flower.png',
              fit: BoxFit.contain,
              height: screenHeight * 0.1, // 10% of screen height
            ),
          ),
        ],
      ),
    );
  }
}
