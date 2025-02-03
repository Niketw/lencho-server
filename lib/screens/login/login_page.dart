import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

/// A custom painter to draw a bush-like cloud using ovals.
class BushCloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xfface268)
      ..style = PaintingStyle.fill;

    // A constant to shift the vertical positions.
    const heightShift = 2.0;
    
    // Draw several ovals to form an uneven bush.
    final List<Rect> ellipses = [
      Rect.fromCenter(
        center: Offset(size.width * 0.07, size.height * (0.2 + heightShift)),
        width: size.width * 0.3,
        height: size.height * 1.5,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.25, size.height * (0.3 + heightShift)),
        width: size.width * 0.25,
        height: size.height * 0.9,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.4, size.height * (0.3 + heightShift)),
        width: size.width * 0.1,
        height: size.height * 0.35,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * (0.18 + heightShift)),
        width: size.width * 0.15,
        height: size.height * 0.35,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.7, size.height * (0.25 + heightShift)),
        width: size.width * 0.4,
        height: size.height * 1.5,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.95, size.height * (0.2 + heightShift)),
        width: size.width * 0.3,
        height: size.height * 0.8,
      ),
    ];

    for (final ellipse in ellipses) {
      canvas.drawOval(ellipse, paint);
    }

    // Draw a rectangle to fill the bottom part of the bush.
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        size.height * (0.3 + heightShift),
        size.width,
        size.height * (0.7 + heightShift),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  bool _showLogin = false;
  
  /// Called when the "Get Started" button is pressed.
  void _onGetStarted() {
    setState(() {
      _showLogin = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth  = MediaQuery.of(context).size.width;
    
    // Define bush dimensions and positions for animation.
    const double bushHeight = 100;
    final double bushTopNotShown = screenHeight * 0.5 - bushHeight + 20;
    final double bushTopShown = screenHeight * 0.5 - bushHeight;
    
    return Scaffold(
      // We do not set a scaffold background because our custom
      // Positioned containers (yellow and green) will serve as the background.
      body: Stack(
        children: [
          // 1) Background: Top half (yellow)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.7,
            child: Container(color: const Color(0xFFFFF4BE)),
          ),
          // 2) Background: Bottom half (green)
          Positioned(
            top: screenHeight * 0.7,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(color: const Color(0xFFACE268)),
          ),
          // 3) Optional top menu dots (if needed)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 4),
                      width: 3,
                      height: 3,
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
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 4),
                      width: 3,
                      height: 3,
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
          // 4) Animated bush behind the form.
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            top: _showLogin ? bushTopShown : bushTopNotShown,
            left: 0,
            right: 0,
            child: SizedBox(
              height: bushHeight,
              width: screenWidth,
              child: CustomPaint(
                size: Size(screenWidth, bushHeight),
                painter: BushCloudPainter(),
              ),
            ),
          ),
          // 5) Top Section (Logo & Company Name)
          Positioned(
            top: screenHeight * 0.1,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  width: _showLogin ? 80 : 150,
                  height: _showLogin ? 80 : 150,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 500),
                  style: TextStyle(
                    fontSize: _showLogin ? 20 : 30,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D522C),
                  ),
                  child: const Text('Lencho Inc.'),
                ),
              ],
            ),
          ),
          // 6) "Get Started" button (only shown before login)
          if (!_showLogin)
            Center(
              child: ElevatedButton(
                onPressed: _onGetStarted,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                ),
                child: const Text("Get Started"),
              ),
            ),
          // 7) Login Form (appears after Get Started is pressed)
          if (_showLogin)
            Positioned(
              top: screenHeight * 0.30,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: _showLogin ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  // Ensure the form container is transparent.
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Simple login form fields.
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot?',
                              style: TextStyle(
                                color: Color(0xFF0D522C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
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
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              Expanded(child: Divider(color: Colors.black54)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Or',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.black54)),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Color(0xFF0D522C),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/icon/google.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/icon/meta.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'www.lencho.com',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // 8) Flower pinned at the bottom using Align.
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/flower.png',
              fit: BoxFit.contain,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
