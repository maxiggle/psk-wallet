import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pkswallet/app/theme/colors.dart';
import 'package:pkswallet/const.dart';
import 'package:after_layout/after_layout.dart';

class QuickSend extends StatefulWidget {
  
  @override
  State<QuickSend> createState() => _QuickSendState();
}

class _QuickSendState extends State<QuickSend> with AfterLayoutMixin<QuickSend> {

   List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission()) {
      setState(() {
        _contacts = null;
        _permissionDenied = true;
      });
      return;
    }

    await _refetchContacts();

    // Listen to DB changes
    FlutterContacts.addListener(() async {
      print('Contacts DB changed, refecthing contacts');
      await _refetchContacts();
    });
  }

  Future _refetchContacts() async {
    // First load all contacts without photo
    await _loadContacts(false);

    // Next with photo
    await _loadContacts(true);
  }

  Future _loadContacts(bool withPhotos) async {
    final contacts = withPhotos
        ? (await FlutterContacts.getContacts(withThumbnail: true)).toList()
        : (await FlutterContacts.getContacts()).toList();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48).r),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.74, vertical: 26).r,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 36.512,
                  width: 36.512,
                  decoration: BoxDecoration(
                      color: ash, borderRadius: BorderRadius.circular(100).w),
                  child: Icon(
                    Icons.arrow_outward,
                    size: 25.sp,
                  ),
                ),
                SizedBox(
                  width: 13.48.w,
                ),
                Column(
                  children: [
                    Text(
                      'Quick Send',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: font19,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Recently added',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: font12,
                          fontWeight: FontWeight.w400,
                          color: opAshText),
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () {

                  },
                  child: Container(
                      height: 36.512,
                      width: 36.512,
                      decoration: BoxDecoration(
                          color: ash,
                          borderRadius: BorderRadius.circular(100).w),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20.sp,
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 28.h,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          backgroundColor: ash,
                          padding: const EdgeInsets.fromLTRB(45, 45, 45, 45).r),
                      child: SvgPicture.asset('assets/images/add.svg')),
                  SizedBox(
                    width: 9.74.w,
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Image(
                      image: AssetImage('assets/images/user1.png'),
                    ),
                  ),
                  SizedBox(
                    width: 9.74.w,
                  ),
                  TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        // backgroundColor: lightGreen,
                      ),
                      child: const Image(
                        image: AssetImage('assets/images/user3-colored.png'),
                      )),
                  SizedBox(
                    width: 9.74.w,
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Image(
                      image: AssetImage('assets/images/user3.png'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
}
