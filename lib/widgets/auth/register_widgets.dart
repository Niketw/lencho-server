import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/controllers/auth/register_controller.dart';
import 'package:lencho/widgets/BushCloudPainter.dart';

void main() => runApp(GetMaterialApp(home: RegistrationPage()));

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the screen height for positioning.
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Prevent the Scaffold from resizing when the keyboard opens.
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        // Wrap the entire content in a Container with fixed height.
        child: Container(
          height: screenHeight,
          // Use a Stack so that background elements and the form can overlap.
          child: Stack(
            children: [
              const BackgroundWidget(),
              const BackButtonWidget(),
              const BushWidget(),
              const LogoTitleWidget(),
              // Position the registration form 35% from the top.
              Positioned(
                top: screenHeight * 0.35,
                left: 0,
                right: 0,
                // Wrap the form in a SingleChildScrollView to allow scrolling
                // when the keyboard is open.
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: RegistrationFormWidget(),
                ),
              ),
              const FlowerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget that paints the top and bottom background colors.
class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const Color topColor = Color(0xFFFFF4BE);
    const Color bottomColor = Color(0xFFACE268);
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenHeight * 0.7,
          child: Container(color: topColor),
        ),
        Positioned(
          top: screenHeight * 0.7,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(color: bottomColor),
        ),
      ],
    );
  }
}

/// Widget for the back button.
class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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

/// Widget for the bush design using a CustomPainter.
class BushWidget extends StatelessWidget {
  const BushWidget({Key? key}) : super(key: key);

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
          painter: BushCloudPainter(heightShift: 1.5),
        ),
      ),
    );
  }
}

/// Widget for displaying the logo and company title.
class LogoTitleWidget extends StatelessWidget {
  const LogoTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double logoSize = screenWidth * 0.25;
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

/// The registration form widget containing text fields and two buttons.
class RegistrationFormWidget extends StatelessWidget {
  RegistrationFormWidget({Key? key}) : super(key: key);

  final RegisterController controller = Get.put(RegisterController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double verticalSpace = screenHeight * 0.02;
    final double textFieldWidth = screenWidth * 0.85;
    final double buttonHeight = screenHeight * 0.06;

    return Positioned(
      top: screenHeight * 0.35,
      left: screenWidth * 0.05,
      right: screenWidth * 0.05,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(verticalSpace),
        color: Colors.transparent,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegisterTextField(
                controller: controller.nameController,
                hint: 'Name',
              ),
              SizedBox(height: verticalSpace),
              RegisterTextField(
                controller: controller.emailController,
                hint: 'Email',
              ),
              SizedBox(height: verticalSpace),
              RegisterTextField(
                controller: controller.passwordController,
                hint: 'Password',
                obscureText: true,
              ),
              SizedBox(height: verticalSpace),
              RegisterTextField(
                controller: controller.confirmPasswordController,
                hint: 'Confirm Password',
                obscureText: true,
              ),
              SizedBox(height: verticalSpace),
              RegisterTextField(
                controller: controller.mobileController,
                hint: 'Mobile',
              ),
              SizedBox(height: verticalSpace * 1.2),
              SizedBox(
                width: textFieldWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: buttonHeight,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Call the email registration method.
                            await controller.sendOtp();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0D522C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Register with Email',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: buttonHeight,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Call the phone registration method.
                            await controller.sendPhoneOtp();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0D522C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Register with Phone',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// A reusable text field for the registration form.
class RegisterTextField extends StatefulWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController controller;

  const RegisterTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _RegisterTextFieldState createState() => _RegisterTextFieldState();
}

class _RegisterTextFieldState extends State<RegisterTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double width = screenWidth * 0.85;
    final double height = screenHeight * 0.06;

    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          hintText: widget.hint,
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

/// Widget for the flower image pinned at the bottom.
/// Wrapped in IgnorePointer to allow taps to pass through.
class FlowerWidget extends StatelessWidget {
  const FlowerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          'assets/images/flower.png',
          fit: BoxFit.contain,
          height: 80,
        ),
      ),
    );
  }
}
