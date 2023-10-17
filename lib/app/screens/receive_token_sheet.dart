import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pkswallet/const.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveTokenSheet extends StatefulWidget {
  const ReceiveTokenSheet({Key? key}) : super(key: key);

  @override
  State<ReceiveTokenSheet> createState() => _ReceiveTokenSheetState();
}

const String message =
    '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
Future<ui.Image> _loadOverlayImage() async {
  final Completer<ui.Image> completer = Completer<ui.Image>();
  final ByteData byteData = await rootBundle.load('assets/images/qr_eth.png');
  ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
  return completer.future;
}

final FutureBuilder<ui.Image> qrFutureBuilder = FutureBuilder<ui.Image>(
  future: _loadOverlayImage(),
  builder: (BuildContext ctx, AsyncSnapshot<ui.Image> snapshot) {
    const double size = 280.0;
    if (!snapshot.hasData) {
      return const SizedBox(width: size, height: size);
    }
    return CustomPaint(
      size: const Size.square(size),
      painter: QrPainter(
        data: message,
        version: QrVersions.auto,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Color(0xff000000),
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.circle,
          color: Color(0xff000000),
        ),
        // size: 320.0,
        embeddedImage: snapshot.data,
        embeddedImageStyle: const QrEmbeddedImageStyle(
          size: Size.square(60),
        ),
      ),
    );
  },
);

class _ReceiveTokenSheetState extends State<ReceiveTokenSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0).r,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.89.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Center(
              child: Text(
                'Fund your',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: font19,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Center(
              child: Text(
                'PKS Wallet',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: font19,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child:
                  Center(child: SizedBox(width: 280.w, child: qrFutureBuilder)),
            )
          ],
        ),
      ),
    );
  }
}
