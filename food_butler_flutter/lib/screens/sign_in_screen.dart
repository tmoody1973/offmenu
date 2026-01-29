import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../main.dart';

class SignInScreen extends StatefulWidget {
  final Widget child;
  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_updateSignedInState);
    _isSignedIn = client.auth.isAuthenticated;
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_updateSignedInState);
    super.dispose();
  }

  void _updateSignedInState() {
    setState(() {
      _isSignedIn = client.auth.isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Off Menu',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF5F0E6),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your personal food concierge',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFB0A99F),
                ),
              ),
              const SizedBox(height: 48),
              Material(
                color: Colors.transparent,
                child: SignInWidget(
                  client: client,
                  onAuthenticated: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
