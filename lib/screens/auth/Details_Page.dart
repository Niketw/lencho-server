import 'package:flutter/material.dart';
import '../../widgets/auth/detail_widgets.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Prevent resizing when the keyboard appears.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: const [
          BackgroundWidget(),
          BackButtonWidget(),
          BushWidget(),
          LogoTitleWidget(),
          AddressFormWidget(),
          FlowerWidget(),
        ],
      ),
    );
  }
}
