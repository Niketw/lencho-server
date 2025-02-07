// phone_verification_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/controllers/auth/phone_verification_controller.dart';
import 'package:lencho/widgets/BushCloudPainter.dart';

class PhoneVerificationWidget extends StatelessWidget {
  PhoneVerificationWidget({Key? key}) : super(key: key);

  // Instantiate the PhoneVerificationController using GetX.
  final PhoneVerificationController controller =
      Get.put(PhoneVerificationController());

  @override
  Widget build(BuildContext context) {
    // Screen dimensions for responsive sizing.
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double verticalSpace = screenHeight * 0.02;
    final double textFieldWidth = screenWidth * 0.85;
    final double buttonHeight = screenHeight * 0.06;

    return Stack(
      children: [
        // Background colors.
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
        // Back Button using GetX for navigation.
        Positioned(
          top: screenHeight * 0.05,
          left: screenWidth * 0.04,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Image.asset(
              'assets/images/icon/back.png',
              width: screenWidth * 0.08,
              height: screenWidth * 0.08,
            ),
          ),
        ),
        // Logo and Title.
        Positioned(
          top: screenHeight * 0.1,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: screenWidth * 0.25,
                height: screenWidth * 0.25,
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
        ),
        // Phone Verification Form: Phone input, OTP input and two side-by-side buttons.
        Positioned(
          top: screenHeight * 0.3,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          child: Container(
            padding: EdgeInsets.all(verticalSpace),
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Phone Number Field.
                SizedBox(
                  width: textFieldWidth,
                  height: buttonHeight,
                  child: TextField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: textFieldWidth * 0.05,
                        vertical: buttonHeight * 0.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: verticalSpace),
                // OTP Input Widget (6 rounded boxes).
                OTPInputWidget(
                  onCompleted: (otp) {
                    // When OTP input is complete, update the controller's OTP value.
                    controller.otpController.text = otp;
                  },
                ),
                SizedBox(height: verticalSpace * 1.2),
                // Two buttons side-by-side.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Send OTP Button.
                    SizedBox(
                      width: textFieldWidth * 0.4,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: controller.sendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0D522C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Send OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: textFieldWidth * 0.1),
                    // Verify OTP Button.
                    SizedBox(
                      width: textFieldWidth * 0.4,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: controller.verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0D522C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Decorative Bush using a CustomPainter.
        Positioned(
          top: screenHeight * 0.5,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 100,
            child: CustomPaint(
              painter: BushCloudPainter(heightShift: 1.5),
            ),
          ),
        ),
        // Flower Image pinned at the bottom.
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Image.asset(
              'assets/images/flower.png',
              fit: BoxFit.contain,
              height: screenHeight * 0.1,
            ),
          ),
        ),
      ],
    );
  }
}

/// A custom widget for OTP input displayed as 6 rounded boxes.
class OTPInputWidget extends StatefulWidget {
  final Function(String)? onCompleted;

  const OTPInputWidget({Key? key, this.onCompleted}) : super(key: key);

  @override
  _OTPInputWidgetState createState() => _OTPInputWidgetState();
}

class _OTPInputWidgetState extends State<OTPInputWidget> {
  final int otpLength = 6;
  late List<FocusNode> focusNodes;
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(otpLength, (_) => FocusNode());
    controllers = List.generate(otpLength, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var fn in focusNodes) {
      fn.dispose();
    }
    for (var tc in controllers) {
      tc.dispose();
    }
    super.dispose();
  }

  void _onChanged() {
    String otp = controllers.map((c) => c.text).join();
    if (otp.length == otpLength && !otp.contains('')) {
      if (widget.onCompleted != null) {
        widget.onCompleted!(otp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate width for each OTP box (with a 10-pixel gap between boxes)
    double totalGap = 10 * (otpLength - 1);
    double boxWidth = (screenWidth * 0.85 - totalGap) / otpLength;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(otpLength, (index) {
        return Container(
          width: boxWidth,
          margin: EdgeInsets.only(right: index == otpLength - 1 ? 0 : 10),
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              if (value.length == 1 && index < otpLength - 1) {
                FocusScope.of(context).requestFocus(focusNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(focusNodes[index - 1]);
              }
              _onChanged();
            },
          ),
        );
      }),
    );
  }
}
