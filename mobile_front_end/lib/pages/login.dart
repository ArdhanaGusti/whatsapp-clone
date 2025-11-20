import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_front_end/pages/home.dart';
import 'package:mobile_front_end/pages/register.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'login';
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _goToRegister() {
    Navigator.of(context).pushNamed(RegisterPage.routeName);
  }

  void _loginPressed() {
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final scaffoldBody = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Welcome Back', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('Login to continue', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 28),
        CustomTextField(
          controller: _email,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _password,
          hintText: 'Password',
          obscureText: _obscure,
          prefixIcon: Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
        const SizedBox(height: 18),
        CustomButton(text: 'Login', onPressed: _loginPressed),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Don't have an account?"),
          TextButton(onPressed: _goToRegister, child: const Text('Register'))
        ]),
      ]),
    );

    return isIos
        ? CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(middle: Text('Login')),
            child: SafeArea(child: SingleChildScrollView(child: SizedBox(height: MediaQuery.of(context).size.height, child: scaffoldBody))),
          )
        : Scaffold(
            appBar: AppBar(title: const Text('Login')),
            body: SafeArea(child: SingleChildScrollView(child: SizedBox(height: MediaQuery.of(context).size.height, child: scaffoldBody))),
          );
  }
}
