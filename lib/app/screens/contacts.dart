import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pkswallet/app/screens/contact_helpers.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen>
    with AfterLayoutMixin<ContactsScreen> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Contacts'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => print(value),
            itemBuilder: (_) => [
              'Groups',
              'Insert external',
              'Insert external (prepopulated)',
            ].map(_menuItemBuilder).toList(),
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (!_permissionDenied) {
      return const Text('No contacts');
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, index) {
          final contact = _contacts![index];
          return ListTile(
            leading: avatar(contact, 18.0),
            title: Text(contact.displayName),
            onTap: () => Navigator.of(context).pushNamed(
              '/contact',
              arguments: contact,
            ),
          );
        });
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
    throw UnimplementedError();
  }

  static PopupMenuItem<String> _menuItemBuilder(String choice) {
    return PopupMenuItem<String>(
      value: choice,
      child: Text(choice),
    );
  }
}
