import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pkswallet/app/screens/contact_helpers.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({this.contacts, super.key});
  final List<Contact>? contacts;
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Choose Contacts'),
        ),
        body: ListView.builder(
            itemCount: widget.contacts!.length,
            itemBuilder: (context, index) {
              final contact = widget.contacts![index];
              return ListTile(
                leading: avatar(contact, 18.0),
                title: Text(contact.displayName),
                onTap: () => Navigator.of(context).pushNamed(
                  '/contact',
                  arguments: contact,
                ),
              );
            }));
  }
}
