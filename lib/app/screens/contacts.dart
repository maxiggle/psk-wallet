import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pkswallet/app/screens/contact_helpers.dart';
import 'package:pkswallet/app/theme/colors.dart';
import 'package:pkswallet/const.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({this.contacts, super.key});
  final List<Contact>? contacts;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      return ListTile(
                          leading: avatar(contact, 18.0),
                          title: Text(contact.displayName),
                          onTap: () {
                            Scaffold.of(context).showBottomSheet(
                                enableDrag: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(radius / 2).r),
                                (context) => LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                                  horizontal: 25)
                                              .r,
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.1,
                                                ),
                                                const Text(
                                                  'Send Token',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 24,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.05,
                                                ),
                                                const Text('To:'),
                                                
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ));
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
