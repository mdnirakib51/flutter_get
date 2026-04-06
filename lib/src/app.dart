
import 'package:flutter/material.dart';
import 'app/routes/app_route.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouteKeys.splash,
      onGenerateRoute: AppRouteGenerator.generateRoute,
    );
  }
}