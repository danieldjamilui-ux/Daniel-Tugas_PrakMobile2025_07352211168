import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/splash_screen.dart';
void main() {
  runApp(const HMTINewsApp());
}

class HMTINewsApp extends StatelessWidget {
  const HMTINewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HMTI News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
   
   
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
