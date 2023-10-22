import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pkswallet/app/providers/wallet_provider.dart';
import 'package:pkswallet/app/screens/contacts.dart';
import 'package:pkswallet/app/screens/create_account.dart';
import 'package:pkswallet/app/screens/token_balance.dart';
import 'package:pkswallet/app/screens/transaction.dart';
import 'package:pkswallet/const.dart';
import 'package:pkswallet/utils/crypto_details.dart';
import 'package:pkswallet/app/screens/home_page.dart';
import 'package:pkswallet/app/screens/onboarding.dart';
import 'package:pkswallet/app/screens/phone_field_screen.dart';
import 'package:pkswallet/app/screens/phone_otp.dart';
import 'package:pkswallet/app/screens/receive_token_sheet.dart';
import 'package:pkswallet/app/screens/send_token_sheet.dart';

// import 'package:pkswallet/utils/tokenData.dart';
// import 'package:pkswallet/utils/transactionData.dart';

import 'package:pks_4337_sdk/src/modules/covalent_api/covalent_api.dart' as cov;

import 'package:pkswallet/utils/transaction_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web3dart/web3dart.dart';
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
    return FutureBuilder(
        future: Future.wait([
          rootBundle.loadString('assets/.env'),
          FirebaseAuth.instance.authStateChanges().first
        ]),
        builder: (context, snapshot) {
          final cKey = dotenv.get('CKEY');
          final walletAddress = context.read<WalletProvider>().wallet.address;
          final vitalik = EthereumAddress.fromHex(
              "0xd8da6bf26964af9d7eed9e03e53415d37aa96045");
          final withEns = EthereumAddress.fromHex(
              "0x104EDD9708fFeeCd0b6bAaA37387E155Bce7d060");
          const chain = "eth-mainnet";

          if (snapshot.connectionState == ConnectionState.done) {
            final user = snapshot.data;
            final GoRouter router = GoRouter(
              routes: <RouteBase>[
                GoRoute(
                  path: '/',
                  builder: (BuildContext context, GoRouterState state) {
                    if (user != null) {
                      return FutureBuilder(
                        future: context
                            .read<WalletProvider>()
                            .getBlockchainDataForAddress(walletAddress, cKey),
                        builder: (context, snapshot) {
                          List<cov.Token> tk = snapshot.data?[1];
                          List<cov.Transaction> tx = snapshot.data?[2];

                          List<TokenData> td = tk.map((e) {
                            return TokenData(
                              contractAddress: e.contractAddress,
                              quoteRate: e.quoteRate.toString(),
                              balance: e.balance?.getInEther.toString(),
                              tokenBalanceInUSD: e.quoteRate.toString(),
                              contractName: e.contractName,
                              contractTickerSymbol: e.contractTickerSymbol,
                              logoUrl: e.logoUrl,
                            );
                          }).toList();

                          List<TransactionData> txd = tx.map((e) {
                            return TransactionData(
                                coinImage: e.transfers?[0].logoUrl,
                                ensName: e.toAddressLabel,
                                txHash: e.txHash,
                                type: TransactionType.send,
                                status: e.successful!
                                    ? TransactionStatus.success
                                    : TransactionStatus.failed,
                                transactionTime: e.blockSignedAt,
                                amount: e.value);
                          }).toList();

                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return HomePage(
                              balance: snapshot.data?[0] as EtherAmount,
                              tokenData: td,
                              transactionData: txd,
                            );
                          }
                        },
                      );
                    } else {
                      return const OnBoarding();
                    }
                  },
                ),
                GoRoute(
                  path: '/home',
                  builder: (BuildContext context, GoRouterState state) {
                    return FutureBuilder(
                      future: context
                          .read<WalletProvider>()
                          .getBlockchainDataForAddress(walletAddress, cKey),
                      builder: (context, snapshot) {
                        List<cov.Token> tk = snapshot.data?[1];
                        List<cov.Transaction> tx = snapshot.data?[2];

                        List<TokenData> td = tk.map((e) {
                          return TokenData(
                            contractAddress: e.contractAddress,
                            quoteRate: e.quoteRate.toString(),
                            balance: e.balance?.getInEther.toString(),
                            tokenBalanceInUSD: e.quoteRate.toString(),
                            contractName: e.contractName,
                            contractTickerSymbol: e.contractTickerSymbol,
                            logoUrl: e.logoUrl,
                          );
                        }).toList();

                        List<TransactionData> txd = tx.map((e) {
                          return TransactionData(
                              coinImage: e.transfers?[0].logoUrl,
                              ensName: e.toAddressLabel,
                              txHash: e.txHash,
                              type: TransactionType.send,
                              status: e.successful!
                                  ? TransactionStatus.success
                                  : TransactionStatus.failed,
                              transactionTime: e.blockSignedAt,
                              amount: e.value);
                        }).toList();
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return HomePage(
                            balance: snapshot.data?[0] as EtherAmount,
                            tokenData: td,
                            transactionData: txd,
                          );
                        }
                      },
                    );
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
                    return FutureBuilder(
                      future: context
                          .read<WalletProvider>()
                          .getBlockchainDataForAddress(walletAddress, cKey),
                      builder: (context, snapshot) {
                        List<cov.Transaction> tx = snapshot.data?[2];
                        List<TransactionData> txd = tx.map((e) {
                          return TransactionData(
                              coinImage: e.transfers?[0].logoUrl,
                              ensName: e.toAddressLabel,
                              txHash: e.txHash,
                              type: TransactionType.send,
                              status: e.successful!
                                  ? TransactionStatus.success
                                  : TransactionStatus.failed,
                              transactionTime: e.blockSignedAt,
                              amount: e.value);
                        }).toList();
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return TransactionDetails(
                            transactionData: txd,
                          );
                        }
                      },
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
                  path: "/CreateAccountScreen",
                  name: 'CreateAccountScreen',
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateAccount();
                  },
                ),
                GoRoute(
                  path: "/crypto_details",
                  name: 'crypto_details',
                  builder: (BuildContext context, GoRouterState state) {
                    final response = context
                        .read<WalletProvider>()
                        .getTokensForAddress(cKey, walletAddress, chain);
                    return const CryptoDetails(tokenData: null);
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
