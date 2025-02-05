import 'package:flutter/material.dart';
import '../../widgets/auth/otp_widgets.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Optionally set resizeToAvoidBottomInset as needed.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: const [
          OtpBackgroundWidget(),
          OtpBackButtonWidget(),
          OtpBushWidget(),
          OtpLogoTitleWidget(),
          OtpFormWidget(),
          OtpFlowerWidget(),
        ],
      ),
    );
  }
}
