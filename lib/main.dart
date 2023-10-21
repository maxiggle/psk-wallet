import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pkswallet/app/providers/passkeys_provider.dart';
import 'package:pkswallet/app/screens/contacts.dart';
import 'package:pkswallet/app/screens/create_account.dart';
import 'package:pkswallet/app/screens/home_page.dart';
import 'package:pkswallet/app/screens/onboarding.dart';
import 'package:pkswallet/app/screens/phone_field_screen.dart';
import 'package:pkswallet/app/screens/phone_otp.dart';
import 'package:pkswallet/app/screens/receive_token_sheet.dart';
import 'package:pkswallet/app/screens/send_token_sheet.dart';

import 'package:pkswallet/utils/transaction_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => PasskeysProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final user = snapshot.data;
            final GoRouter router = GoRouter(
              routes: <RouteBase>[
                GoRoute(
                  path: '/',
                  builder: (BuildContext context, GoRouterState state) {
                    if (user != null) {
                      return const HomePage();
                    } else {
                      return const OnBoarding();
                    }
                  },
                ),
                GoRoute(
                  path: '/home',
                  builder: (BuildContext context, GoRouterState state) {
                    return const HomePage();
                  },
                ),
                GoRoute(
                  path: '/phone-field',
                  builder: (BuildContext context, GoRouterState state) {
                    return const PhoneFieldScreen();
                  },
                ),
                GoRoute(
                  path: '/phone-otp',
                  builder: (BuildContext context, GoRouterState state) {
                    final phone = state.extra as String;
                    return PinCodeVerificationScreen(phoneNumber: phone);
                  },
                ),
                GoRoute(
                  path: '/transaction_details',
                  builder: (BuildContext context, GoRouterState state) {
                    return const TransactionDetails();
                  },
                ),
                GoRoute(
                  path: "/contactScreen",
                  name: 'contactScreen',
                  builder: (BuildContext context, GoRouterState state) {
                    final contacts = state.extra as List<Contact>;

                    return ContactsScreen(contacts: contacts);
                  },
                ),
                GoRoute(
                  path: "/send_token",
                  name: 'sendToken',
                  builder: (BuildContext context, GoRouterState state) {
                    return SendTokenSheet(
                      contactName: state.extra as String,
                    );
                  },
                ),
                GoRoute(
                  path: "/receive_token",
                  name: 'receiveToken',
                  builder: (BuildContext context, GoRouterState state) {
                    return const ReceiveTokenSheet();
                  },
                ),
                GoRoute(
                  path: "/CreateAccountScreen",
                  name: 'CreateAccountScreen',
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateAccount();
                  },
                ),
              ],
            );
            return ScreenUtilInit(
              designSize: const Size(428.413, 1025),
              child: FirebasePhoneAuthProvider(
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'pks wallet',
                  routerConfig: router,
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
