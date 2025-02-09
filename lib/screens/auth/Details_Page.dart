import 'package:flutter/material.dart';
import 'package:lencho/widgets/auth/detail_widgets.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Optionally set resizeToAvoidBottomInset if needed.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const BackgroundWidget(),
          const BushWidget(),
          const LogoTitleWidget(),
          AddressFormWidget(),
          const FlowerWidget(),
        ],
      ),
    );
  }
}
