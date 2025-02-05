import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/controllers/details_controller.dart';
import 'package:lencho/widgets/BushCloudPainter.dart';

/// The background widget paints the top and bottom background colors.
class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen height
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        // Top background container
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenHeight * 0.7,
          child: Container(color: const Color(0xFFFFF4BE)),
        ),
        // Bottom background container
        Positioned(
          top: screenHeight * 0.7,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(color: const Color(0xFFACE268)),
        ),
      ],
    );
  }
}

/// The back button widget (top left).
class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtain screen dimensions
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

/// The bush widget using your custom painter.
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
          painter: BushCloudPainter(heightShift: 1.25),
        ),
      ),
    );
  }
}

/// The logo and title widget.
class LogoTitleWidget extends StatelessWidget {
  const LogoTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double logoSize = screenWidth * 0.25;
    final double verticalSpace = screenHeight * 0.02;

    return Positioned(
      top: screenHeight * 0.05,
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

/// A reusable text field widget for address details.
class AddressTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  const AddressTextField({
    Key? key,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Compute dimensions internally
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double width = screenWidth * 0.85;
    final double height = screenHeight * 0.06;

    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
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

/// The address form widget contains the address text fields and buttons.
class AddressFormWidget extends StatelessWidget {
  const AddressFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Instantiate the DetailsController via GetX.
    final DetailsController detailsController = Get.put(DetailsController());

    // Get dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double verticalSpace = screenHeight * 0.02;
    final double textFieldWidth = screenWidth * 0.85;
    final double buttonHeight = screenHeight * 0.06;

    return Positioned(
      top: screenHeight * 0.3,
      left: screenWidth * 0.05,
      right: screenWidth * 0.05,
      child: Container(
        padding: EdgeInsets.all(verticalSpace),
        color: Colors.transparent,
        child: Column(
          children: [
            AddressTextField(
              hint: 'Street Address',
              controller: detailsController.streetAddressController,
            ),
            SizedBox(height: verticalSpace),
            AddressTextField(
              hint: 'City',
              controller: detailsController.cityController,
            ),
            SizedBox(height: verticalSpace),
            AddressTextField(
              hint: 'State',
              controller: detailsController.stateController,
            ),
            SizedBox(height: verticalSpace),
            AddressTextField(
              hint: 'Postal Zip',
              controller: detailsController.postalZipController,
            ),
            SizedBox(height: verticalSpace * 1.2),
            // Submit button
            SizedBox(
              width: textFieldWidth,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  detailsController.submitDetails();
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
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: verticalSpace * 0.6),
            // "Do this later" button
            SizedBox(
              width: textFieldWidth,
              height: buttonHeight,
              child: OutlinedButton(
                onPressed: () {
                  // Add your "do this later" action here.
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: Color(0xFF0D522C)),
                ),
                child: const Text(
                  'Do this later',
                  style: TextStyle(
                    color: Color(0xFF0D522C),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The flower widget pinned at the bottom.
class FlowerWidget extends StatelessWidget {
  const FlowerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Image.asset(
          'assets/images/flower.png',
          fit: BoxFit.contain,
          height: screenHeight * 0.000001, // Adjust height if needed
        ),
      ),
    );
  }
}
