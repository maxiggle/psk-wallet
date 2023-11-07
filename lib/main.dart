import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:variancewallet/app/providers/wallet_provider.dart';
import 'package:variancewallet/app/screens/contacts.dart';
import 'package:variancewallet/app/screens/home_page.dart';
import 'package:variancewallet/app/screens/onboarding.dart';
import 'package:variancewallet/app/screens/phone_field_screen.dart';
import 'package:variancewallet/app/screens/phone_otp.dart';
import 'package:variancewallet/app/screens/receive_token_sheet.dart';
import 'package:variancewallet/app/screens/send_token_sheet.dart';
import 'package:variancewallet/utils/crypto_details.dart';
import 'package:variancewallet/utils/tokenData.dart';
import 'package:variancewallet/utils/transactionData.dart';
import 'package:variancewallet/utils/transaction_details.dart';
import 'package:web3dart/web3dart.dart';
import 'app/providers/home_provider.dart';
import 'app/screens/create_account.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => WalletProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthStateWidget();
  }
}

class AuthStateWidget extends StatefulWidget {
  const AuthStateWidget({super.key});

  @override
  _AuthStateWidgetState createState() => _AuthStateWidgetState();
}

class _AuthStateWidgetState extends State<AuthStateWidget> {
  late Future<User?> _authState;

  @override
  void initState() {
    super.initState();
    _authState = FirebaseAuth.instance.authStateChanges().first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authState,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final user = snapshot.data;
          final GoRouter router = GoRouter(
            routes: <RouteBase>[
              GoRoute(
                path: '/',
                builder: (BuildContext context, GoRouterState state) {
                  return const OnBoarding();
                },
                redirect: (context, state) {
                  if (user != null) {
                    return '/home';
                  } else {
                    return null;
                  }
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
                path: '/CreateAccountScreen',
                builder: (BuildContext context, GoRouterState state) {
                  return const CreateAccount();
                },
              ),
              GoRoute(
                path: '/home',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePage(balance: EtherAmount.zero());
                },
              ),
              GoRoute(
                path: '/transaction_details',
                builder: (BuildContext context, GoRouterState state) {
                  return TransactionDetails(
                    transactionData: transactionData,
                  );
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
                path: "/crypto_details",
                name: 'crypto_details',
                builder: (BuildContext context, GoRouterState state) {
                  return CryptoDetails(tokenData: token);
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
                builder: (context, child) {
                  // pass providers down
                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (context) => HomeProvider(),
                      )
                    ],
                    child: child ?? const Text('Something went wrong'),
                  );
                },
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
