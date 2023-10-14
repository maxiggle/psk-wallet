import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pkswallet/app/screens/contacts.dart';
import 'package:pkswallet/app/screens/home_page.dart';
import 'package:pkswallet/app/screens/phone_otp.dart';
import 'package:pkswallet/app/screens/send_token_by_contact.dart';

import 'package:pkswallet/utils/transaction_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app/screens/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        GoRoute(
          path: 'transaction_details',
          builder: (BuildContext context, GoRouterState state) {
            return const TransactionDetails();
          },
        ),
        GoRoute(
          path: "contactScreen",
          name: 'contactScreen',
          builder: (BuildContext context, GoRouterState state) {
            final contacts = state.extra as List<Contact>;
            return ContactsScreen(contacts: contacts);
          },
        ),
        GoRoute(
          path: "send_token",
          name: 'sendToken',
          builder: (BuildContext context, GoRouterState state) {
            return const SendTokenByContact();
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
