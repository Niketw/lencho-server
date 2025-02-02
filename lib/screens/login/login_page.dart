import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

/// Custom clipper to create a smooth, curvy top edge for the bush.
class BushClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    // Start at bottom left.
    path.moveTo(0, size.height);
    // Draw a line up to create a starting point for the curve.
    path.lineTo(0, 40);
    // Create a quadratic bezier curve from the top left to the top right.
    path.quadraticBezierTo(
      size.width / 2, 0, // control point: adjust this for a smoother curve
      size.width, 40,    // end point
    );
    // Draw line down to bottom right.
    path.lineTo(size.width, size.height);
    // Close the path.
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffffe98a),
      body: Stack(
        children: [
          // -------------------------------------------------
          // 1. Bottom: Green Bush Image with smooth curvy top
          //    (Drawn first so that other elements are layered on top.)
          // -------------------------------------------------
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              height: _showLogin
                  ? screenHeight * 0.65  // 50% + 15%
                  : screenHeight * 0.35, // 20% + 15%
              child: ClipPath(
                clipper: BushClipper(),
                child: Image.asset(
                  'assets/green-bush.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // -------------------------------------------------
          // 2. Top Section: Logo and Company Name
          //    (Now positioned 10% down from the top.)
          // -------------------------------------------------
          Positioned(
            top: screenHeight * 0.1, // 10% down from the top
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated logo size on transition.
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
                // Animated "Lencho Inc." text with bold style and new color.
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

          // -------------------------------------------------
          // 3. Center: Get Started Button (only when login form is hidden)
          // -------------------------------------------------
          if (!_showLogin)
            Center(
              child: ElevatedButton(
                onPressed: _onGetStarted,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text("Get Started"),
              ),
            ),

          // -------------------------------------------------
          // 4. Login Form: Appears over the bush once _showLogin is true.
          //     The container background remains transparent.
          //     (Positioned at 40% of the screen height.)
          // -------------------------------------------------
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
                        // Header: "Login" and "Sign in to continue"
                        Transform.translate(
                          offset: Offset(0, -screenHeight * 0.05), // 5% higher
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
                        // Form Fields & Buttons: shifted 5% lower.
                        Transform.translate(
                          offset: Offset(0, screenHeight * 0.05), // 5% lower
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
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
        ],
      ),
    );
  }
}
