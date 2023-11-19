import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:variancewallet/app/providers/wallet_provider.dart';
import 'package:variancewallet/main.dart';
import 'package:variancewallet/utils/globals.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({
    super.key,
  });

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

final TextEditingController controller = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _CreateAccountState extends State<CreateAccount> {
  void showSnackbar(String message) {
    var currentScaffoldMessenger = globalScaffoldMessengerKey.currentState;
    currentScaffoldMessenger?.hideCurrentSnackBar();
    currentScaffoldMessenger?.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (context, value, child) {
          return Scaffold(
              body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 51,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25)),
                      child: TextFormField(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a username';
                          }
                          if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                            return 'Username must contain only alphabets with no spaces';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            controller.text = value;
                          });
                        },
                        controller: controller,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            hintText: 'Choose a username',
                            hintStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true),
                      ),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 45,
                      child: TextButton(
                        onPressed: () async {
                          try {
                            await context.read<WalletProvider>().register(
                                controller.text.trim(),
                                requiresUserVerification: true,
                                '${Globals.firebaseUser?.phoneNumber}');

                            // ignore: use_build_context_synchronously
                            GoRouter.of(context).go('/home');
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            showSnackbar(e.toString());
                          }
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: const Color(0xffE1FF01),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ));
        },
      ),
    );
  }
}
