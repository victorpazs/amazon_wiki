import 'package:amazon_wiki_app/core/routes/app_routes.dart';
import 'package:amazon_wiki_app/utils/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazon Wiki',
      themeMode: ThemeMode.light,
      theme: GlobalThemData.lightThemeData,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
