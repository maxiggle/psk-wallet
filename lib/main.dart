import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pkswallet/app/screens/home_page.dart';
import 'package:pkswallet/app/screens/phone_otp.dart';

import 'app/screens/onboarding.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return OnBoarding();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: 'phone-otp',
          builder: (BuildContext context, GoRouterState state) {
            return const PinCodeVerificationScreen();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428.413, 1025),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'pks wallet',
        theme: ThemeData.light().copyWith(),
        routerConfig: _router,
      ),
    );
  }
}
