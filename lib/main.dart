import 'package:encro/authentication/api_auth.dart';
import 'package:encro/theme.dart';
import 'package:encro/views/LoginSignupPage.dart';
import 'package:encro/tests/test4.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme().light,
      darkTheme: AppTheme().dark,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      title: 'Encro',
      home: const AuthenticationWrapper(), // Use the AuthenticationWrapper here
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.authToken == null) {
      // User not logged in
      return LoginSignupPage();
    } else {
      // User is logged in
      return HomePage();
    }
  }
}
