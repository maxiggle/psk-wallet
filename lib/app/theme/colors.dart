import 'package:flutter/material.dart';
import 'package:gradients/gradients.dart';

const lightGreen = Color(0xffE1FF01);
const white = Color(0xffffffff);
const black = Color(0xff000000);
const ash = Color(0xffF2F2F2);
const darkGreen = Color(0xff147E03);
const blue2 = Color(0xff084CCA);

final gradient = RadialGradientPainter(
  colors: <Color>[
    Color(0xffE1FF01),
    Color(0xff000000),
  ],
  colorSpace: ColorSpace.cmyk,
  center: Alignment(1.0, -1.0),
  radius: 1.5,
);
