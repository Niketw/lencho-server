import 'package:flutter/material.dart';
import 'package:lencho/controllers/home/logout_controller.dart';
import 'package:lencho/widgets/BushCloudRotated.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(
          height: 60,
          width: double.infinity,
          child: BushCloudRotated(),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.location_on, color: Color(0xFF2D5A27)),
                Row(
                  children: [
                    Image.asset('assets/images/logo.png', height: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Lencho Inc.',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF2D5A27),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Logout button calls the logout method.
                IconButton(
                  icon: const Icon(Icons.logout, color: Color(0xFF2D5A27)),
                  onPressed: () {
                    LogoutController.instance.logout();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
