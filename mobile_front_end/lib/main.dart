import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_front_end/styles/style.dart';
import 'pages/splash.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/home.dart';
import 'pages/chat_room.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

bool get isIOS => !kIsWeb && Platform.isIOS;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return isIOS ? _buildCupertinoApp() : _buildMaterialApp();
  }

  Widget _buildMaterialApp() {
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      scaffoldBackgroundColor: AppColors.lightBackground,
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
      ),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.dark),
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
      useMaterial3: true,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
      ),
    );

    return MaterialApp(
      restorationScopeId: null,
      title: 'Chat UI',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: "/",
      onGenerateRoute: (settings) => _platformAwareRoute(settings),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _buildCupertinoApp() {
    final cupertinoLight = CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: CupertinoTextThemeData(
        textStyle: GoogleFonts.poppins(),
        actionTextStyle: GoogleFonts.poppins(),
      ),
    );

    final cupertinoDark = CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: CupertinoTextThemeData(
        textStyle: GoogleFonts.poppins(),
        actionTextStyle: GoogleFonts.poppins(),
      ),
    );

    return CupertinoApp(
      restorationScopeId: null,
      title: 'Chat UI',
      theme: cupertinoLight,
      initialRoute: "/",
      onGenerateRoute: (settings) => _platformAwareRoute(settings),
      debugShowCheckedModeBanner: false,
    );
  }

  Route<dynamic>? _platformAwareRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case '/':
        page = const SplashPage();
        break;
      case LoginPage.routeName:
        page = const LoginPage();
        break;
      case RegisterPage.routeName:
        page = const RegisterPage();
        break;
      case HomePage.routeName:
        page = const HomePage();
        break;
      case ChatRoomPage.routeName:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        page = ChatRoomPage(roomId: args['roomId'] ?? 'room', title: args['title'] ?? 'Chat');
        break;
      default:
        page = const SplashPage();
    }
    if (isIOS) {
      return CupertinoPageRoute(builder: (_) => page, settings: settings);
    } else {
      return MaterialPageRoute(builder: (_) => page, settings: settings);
    }
  }
}
