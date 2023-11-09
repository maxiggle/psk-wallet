import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:variancewallet/app/screens/contact_helpers.dart';
import 'package:variancewallet/app/theme/colors.dart';
import 'package:variancewallet/const.dart';



class ContactsScreen extends StatefulWidget {
  final List<Contact>? contacts;
  const ContactsScreen({this.contacts, super.key});
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ash,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: ash,
            leading: BackButton(
              color: black,
              onPressed: () => GoRouter.of(context).pop('/home'),
            )),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
          ).r,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10).r,
              child: Text(
                'Select recipient',
                style: TextStyle(
                    fontSize: font19,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter'),
              ),
            ),
            SizedBox(height: 50.h),
            Expanded(
                child: ListView.builder(
                    itemCount: widget.contacts!.length,
                    itemBuilder: (context, index) {
                      final contact = widget.contacts![index];
                      final name = contact.displayName;
                      return ListTile(
                          leading: avatar(contact, 18.0),
                          title: Text(name),
                          onTap: () {
                            context.push('/send_token', extra: name);
                          });
                    }))
          ]),
        ),
      ),
    );
  }
}
