import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_front_end/pages/home.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = 'register';
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  final bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _registerPressed() {
    // UI-only: navigate to home
    Navigator.of(context).pushReplacementNamed('/${HomePage.routeName}');
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Create Account', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        CustomTextField(controller: _name, hintText: 'Full name', prefixIcon: Icons.person_outline),
        const SizedBox(height: 12),
        CustomTextField(controller: _email, hintText: 'Email', keyboardType: TextInputType.emailAddress, prefixIcon: Icons.email_outlined),
        const SizedBox(height: 12),
        CustomTextField(controller: _pass, hintText: 'Password', obscureText: _obscure, prefixIcon: Icons.lock_outline),
        const SizedBox(height: 12),
        CustomTextField(controller: _confirm, hintText: 'Confirm password', obscureText: _obscure, prefixIcon: Icons.lock_outline),
        const SizedBox(height: 18),
        CustomButton(text: 'Register', onPressed: _registerPressed),
      ]),
    );

    return isIos
        ? CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(middle: Text('Register')),
            child: SafeArea(child: SingleChildScrollView(child: SizedBox(height: MediaQuery.of(context).size.height, child: body))),
          )
        : Scaffold(appBar: AppBar(title: const Text('Register')), body: SafeArea(child: SingleChildScrollView(child: SizedBox(height: MediaQuery.of(context).size.height, child: body))));
  }
}
