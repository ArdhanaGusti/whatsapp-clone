import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_front_end/pages/login.dart';
import 'package:mobile_front_end/styles/style.dart';
import '../main.dart';
import '../widgets/custom_button.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      _navigateToLogin();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isIos = isIOS;
    final body = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Simple logo circle
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Center(
              child: Text(
                'Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('Modern Chat', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Clean • Rounded • Fast', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 18),
          // small continue/skip for preview
          CustomButton(
            text: 'Continue',
            onPressed: _navigateToLogin,
            filled: false,
            minWidth: 140,
          )
        ],
      ),
    );

    return isIos
        ? CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(middle: Text('')),
            child: SafeArea(child: body),
          )
        : Scaffold(body: SafeArea(child: body));
  }
}
