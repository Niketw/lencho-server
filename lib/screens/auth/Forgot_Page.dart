import 'package:flutter/material.dart';
import '../../widgets/auth/forgot_widgets.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You can set resizeToAvoidBottomInset as needed.
      body: Stack(
        children: const [
          ForgotBackgroundWidget(),
          ForgotBackButtonWidget(),
          ForgotBushWidget(),
          ForgotLogoWidget(),
          ForgotFormWidget(),
          ForgotFlowerWidget(),
        ],
      ),
    );
  }
}
