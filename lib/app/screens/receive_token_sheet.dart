import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pkswallet/app/theme/colors.dart';
import 'package:pkswallet/const.dart';
import 'package:qr_flutter/qr_flutter.dart';

const String message =
    '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

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
Future<ui.Image> _loadOverlayImage() async {
  final Completer<ui.Image> completer = Completer<ui.Image>();
  final ByteData byteData = await rootBundle.load('assets/images/qr_eth.png');
  ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
  return completer.future;
}

class ReceiveTokenSheet extends StatefulWidget {
  const ReceiveTokenSheet({Key? key}) : super(key: key);

  @override
  State<ReceiveTokenSheet> createState() => _ReceiveTokenSheetState();
}

class _ReceiveTokenSheetState extends State<ReceiveTokenSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: BackButton(
            color: black,
            onPressed: () => GoRouter.of(context).pop('/home'),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0).r,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.89.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 25.h,
                    ),
                    Center(
                      child: Text(
                        'Fund your',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: font51,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: Text(
                        'PKS Wallet',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Expanded(
                      child: Center(
                        child: SizedBox(width: 280.w, child: qrFutureBuilder),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextButton(
                      onPressed: () async {
                        await Clipboard.setData(
                                const ClipboardData(text: message))
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Copied to clipboard',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontSize: font14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ));
                        });
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: lightGreen,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(radius),
                          )),
                      child: Text(
                        'Copy to clipboard',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Inter',
                          fontSize: font14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
