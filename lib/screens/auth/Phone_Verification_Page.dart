import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/controllers/auth/phone_verification_controller.dart';

class PhoneVerificationPage extends StatelessWidget {
  final String verificationId;

  const PhoneVerificationPage({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize your controller if needed.
    final PhoneVerificationController controller =
        Get.put(PhoneVerificationController());

    return Scaffold(
      appBar: AppBar(title: const Text('Phone Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Enter the OTP sent to your phone"),
            const SizedBox(height: 16),
            TextField(
              controller: controller.otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await controller.verifyOtp();
              },
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

