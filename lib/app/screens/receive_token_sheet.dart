import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gradients/gradients.dart';
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
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(10.0).r,
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10)),
                        child: qrFutureBuilder,
                      ),
                    ),
                    SizedBox(height: 50.h),
                    Container(
                      width: 280.w,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      margin: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Ethereum address',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: const Color(0xff32353E)
                                        .withOpacity(0.5),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 280.w,
                                    child: const Text(
                                      message,
                                      style: TextStyle(
                                          color: Color(0xff32353E),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Clipboard.setData(
                                  const ClipboardData(text: message));
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: const Color(0xff32353E),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(radius))),
                            child: const Text(
                              'copy',
                              style:
                                  TextStyle(color: white, fontFamily: 'Inter'),
                            ),
                          ),
                        ],
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


  //  const Spacer(),
  //                             TextButton(
  //                               onPressed: () {},
  //                               style: TextButton.styleFrom(
  //                                   backgroundColor: const Color(0xff32353E),
  //                                   shape: RoundedRectangleBorder(
  //                                       borderRadius:
  //                                           BorderRadius.circular(radius))),
  //                               child: const Text(
  //                                 'copy',
  //                                 style: TextStyle(
  //                                     color: white, fontFamily: 'Inter'),
  //                               ),
  //                             ),