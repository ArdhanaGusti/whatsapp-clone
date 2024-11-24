import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  _handleSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await account.authentication;

        // final response = await http.get(
        //   Uri.parse('http://10.0.2.2:8080/getUserInfo'),
        //   headers: {'Authorization': '${googleSignInAuthentication.accessToken}'},
        // );

        // print('Response: ${response.body}');
        print('Access token: ${googleSignInAuthentication.accessToken}');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In Demo'),
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Sign in with Google'),
              onPressed: _handleSignIn,
            ),
            ElevatedButton(
              child: Text('Sign Out'),
              onPressed: () {
                _googleSignIn.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
