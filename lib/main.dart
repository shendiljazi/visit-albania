import 'package:flutter/material.dart';
import 'package:visit_albania/providers/favorites_provider.dart';
import 'package:visit_albania/providers/auth_provider.dart';
import 'package:visit_albania/screens/navigation_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp(
          title: 'Visit Albania',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            useMaterial3: true,
          ),
          home: _getHome(authProvider),
        );
      },
    );
  }

  Widget _getHome(AuthProvider authProvider) {
    if (authProvider.isLoggedIn || authProvider.isGuest) {
      return NavigationScreen();
    } else {
      return WelcomeScreen();
    }
  }
}
