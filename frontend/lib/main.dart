import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/glass/glass_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'providers/delivery_provider.dart';
import 'screens/shared/splash_screen.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'GAZLINK',
            debugShowCheckedModeBanner: false,
            theme: GlassTheme.light,
            darkTheme: GlassTheme.dark,
            themeMode: themeProvider.themeMode,
            home: _buildHome(),
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }

  Widget _buildHome() {
    // Always show splash screen on app start
    return const SplashScreen();
  }
}
