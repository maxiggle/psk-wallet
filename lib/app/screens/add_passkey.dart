import 'package:flutter/material.dart';

class AddPassKey extends StatefulWidget {
  const AddPassKey({super.key});

  @override
  State<AddPassKey> createState() => _AddPassKeyState();
}

class _AddPassKeyState extends State<AddPassKey> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Set a passkey to sign your wallet transactions'),
        ],
      ),
    );
  }
}
