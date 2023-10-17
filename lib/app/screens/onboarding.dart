import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gradients/gradients.dart';
import 'package:pkswallet/app/theme/colors.dart';
import 'package:pkswallet/utils/globals.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final gradient = LinearGradientPainter(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      const Color(0xFFFFF500).withOpacity(0.5),
      const Color(0xFFE1FF01).withOpacity(0.0),
    ],
    colorSpace: ColorSpace.oklab,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradientPainter(
                colors: <Color>[
                  Color(0xffE1FF01),
                  Color(0xff000000),
                ],
                colorSpace: ColorSpace.cmyk,
                center: Alignment(1.0, -1.0),
                radius: 1.5,
              ),
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/rec.png',
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 58.0, horizontal: 38.0)
                      .r,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Image(
                        image: const AssetImage('assets/images/star.png'),
                        height: 100.76.h,
                        width: 100.w,
                      ),
                    ],
                  ),
                  SizedBox(height: 57.96.h),
                  Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/images/30.svg',
                      ),
                      Transform.translate(
                        offset: const Offset(-105, 200),
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                              sigmaY: 0.6,
                              sigmaX: 0.5,
                              tileMode: TileMode.decal),
                          child: Container(
                            height:
                                MediaQuery.of(context).size.height * 0.225.h,
                            width: MediaQuery.of(context).size.height * 0.225.w,
                            decoration: BoxDecoration(
                              gradient: gradient,
                              borderRadius: BorderRadius.circular(180).w,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 187.93.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Transaction',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 56.sp,
                            color: Colors.white),
                      ),
                      Text(
                        'Made Easy',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 56.sp,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Buy, Sell and Exchange',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24.sp,
                            color: Colors.white),
                      ),
                      Text(
                        'cryptocurrency',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24.sp,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 17.h,
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/phone-field');
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.only(
                                left: 12.r,
                                right: 12.r,
                                top: 17.r,
                                bottom: 17.r),
                            backgroundColor: lightGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(75.459))),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.69.sp,
                            color: black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Check if the user is authenticated
    if (Globals.firebaseUser?.uid != null) {
      // User is authenticated, navigate to the home screen
      // Replace '/home' with your actual home screen route.
      Future.microtask(() {
        context.go('/home');
      });
    }
  }
}
