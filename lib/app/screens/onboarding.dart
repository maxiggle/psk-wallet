import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradients/gradients.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pkswallet/app/theme/colors.dart';

class OnBoarding extends StatelessWidget {
  OnBoarding({super.key});

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
                  'assets/rec.png',
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 58.0, horizontal: 38.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Image(
                        image: AssetImage('assets/star.png'),
                        height: 100.76,
                        width: 100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 57.96),
                  Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/30.svg',
                        height: 200.h,
                      ),
                      Transform.translate(
                        offset: const Offset(-100, 200),
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
                              borderRadius: BorderRadius.circular(150).w,
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
                        onPressed: () {},
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
                              color: black),
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
}
