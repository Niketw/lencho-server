import 'package:flutter/material.dart';
import 'package:lencho/widgets/auth/login_widgets.dart'; // Import the separated login widgets

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showLogin = false;

  void _onGetStarted() {
    setState(() {
      _showLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Prevent the layout from resizing when the keyboard appears.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const BackgroundWidget(),
          const TopDotsWidget(),
          BushAnimationWidget(showLogin: _showLogin),
          const LogoCompanyWidget(),
          if (!_showLogin) 
            GetStartedButtonWidget(
              onPressed: _onGetStarted
            ),
          if (_showLogin) 
            PositionedLoginForm(),
          const FlowerWidget(),
        ],
      ),
    );
  }
}
