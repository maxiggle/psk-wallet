import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradients/gradients.dart';
import 'dart:math';

class OnBoarding extends StatelessWidget {
  OnBoarding({super.key});

  final gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      const Color(0xFFFFF500),
      const Color(0xFFE1FF01).withOpacity(0.0),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
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
            fit: BoxFit.fitHeight),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 58.0, horizontal: 38.0),
          child: Column(
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0XFFFFF500),
          Color(0xFFE1FF01),
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    Path path1 = Path()
      ..addOval(Rect.fromCenter(
          center: center, width: size.width, height: size.height));

    Path path2 = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(
            center.dx - 10,
            center.dy - 10,
          ),
          width: size.width - 100,
          height: size.height - 100,
        ),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, path1, path2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
// 