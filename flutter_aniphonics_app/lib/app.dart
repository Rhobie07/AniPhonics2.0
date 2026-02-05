import 'package:flutter/material.dart';

import 'core/navigation/app_routes.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

class AniPhonicsApp extends StatelessWidget {
  const AniPhonicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AniPhonics',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.loading,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
