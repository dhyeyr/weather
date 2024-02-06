import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/view/home_screen.dart';
import 'package:weather/view/splash_screen.dart';

import 'controller/connectivity_provider.dart';
import 'controller/theme_provider.dart';
late SharedPreferences prefs;
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
          ThemeProvider()
            ..getTheme(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
        ),
      ],
      builder: (context, child) {
        return Consumer <ThemeProvider>(
            builder: (context,themeprovider, child) {
              return MaterialApp(

                debugShowCheckedModeBanner: false,
                routes: {
                  'HomePage': (context) => const Home_screen(),
                  '/': (context) => const SplashScreen(),
                },
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: themeprovider.thememode,
              );
            }
        );
      },

    );
  }
}

