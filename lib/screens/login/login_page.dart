import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class BushCloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF90C789)  // Light green color
      ..style = PaintingStyle.fill;

    // Create the main bush shape
    final Path bushPath = Path();
    
    // Start from the left edge
    bushPath.moveTo(0, size.height);
    
    // Left bump
    bushPath.quadraticBezierTo(
      size.width * 0.25,  // Control point X
      size.height * 0.2,  // Control point Y - higher up for more rounded top
      size.width * 0.5,   // End point X - middle of the screen
      size.height * 0.5,  // End point Y - creates the dip
    );
    
    // Right bump
    bushPath.quadraticBezierTo(
      size.width * 0.75,  // Control point X
      size.height * 0.2,  // Control point Y - matches left bump
      size.width,         // End point X - right edge
      size.height,        // End point Y - bottom right corner
    );
    
    // Close the path
    bushPath.lineTo(size.width, size.height);
    bushPath.lineTo(0, size.height);
    bushPath.close();

    // Draw the main shape
    canvas.drawPath(bushPath, paint);

    // Add subtle gradient overlay for depth
    final Paint gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF90C789).withOpacity(0.2),
          const Color(0xFF90C789).withOpacity(0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(bushPath, gradientPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  bool _showLogin = false;
  
  /// When the Get Started button is pressed, update the state so that the
  /// bush animates upward and the login form is shown.
  void _onGetStarted() {
    setState(() {
      _showLogin = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Define the height for the bush container.
    const double bushHeight = 100;
    // When the login form is NOT shown, the bush is positioned slightly lower.
    // When shown, it animates upward so that its bottom edge exactly aligns
    // with the yellow/green partition (at screenHeight * 0.5).
    final double bushTopNotShown = screenHeight * 0.5 - bushHeight + 20;
    final double bushTopShown = screenHeight * 0.5 - bushHeight;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background layers:
          // Top half (yellowish)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.5,
            child: Container(color: const Color.fromARGB(255, 255, 234, 138)),
          ),
          // Bottom half (greenish)
          Positioned(
            top: screenHeight * 0.5,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(color: const Color(0xfface268)),
          ),

          // Animated Bush using CustomPaint to draw multiple curved elements.
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            top: _showLogin ? bushTopShown : bushTopNotShown,
            left: 0,
            right: 0,
            child: SizedBox(
              height: bushHeight,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width, bushHeight),
                painter: BushCloudPainter(),
              ),
            ),
          ),

          // Top Section (Logo & Company Name)
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
                  width: _showLogin ? 100 : 150,
                  height: _showLogin ? 100 : 150,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 500),
                  style: TextStyle(
                    fontSize: _showLogin ? 20 : 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff0d522c),
                  ),
                  child: const Text("Lencho Inc."),
                ),
              ],
            ),
          ),

          // Get Started Button (only shown before login)
          if (!_showLogin)
            Center(
              child: ElevatedButton(
                onPressed: _onGetStarted,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text("Get Started"),
              ),
            ),

          // Login Form (animated fade in after Get Started is pressed)
          if (_showLogin)
            Positioned(
              top: screenHeight * 0.40,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: _showLogin ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.translate(
                          offset: Offset(0, -screenHeight * 0.05),
                          child: Column(
                            children: const [
                              Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff5d9c59),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Sign in to continue",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Transform.translate(
                          offset: Offset(0, screenHeight * 0.05),
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const HomePage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Log In",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {},
                                child: const Text("Forgot Password"),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "www.reallygreatsite.com",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Bottom Flower Image (remains unchanged)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/flower.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
