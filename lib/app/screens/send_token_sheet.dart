import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pkswallet/app/screens/home_page.dart';
import 'package:pkswallet/app/theme/colors.dart';
import 'package:pkswallet/const.dart';

class SendTokenSheet extends StatefulWidget {
  const SendTokenSheet(
      {super.key, this.hintText, this.addressController, this.emailError});
  final TextEditingController? addressController;
  final String? hintText;
  final String? emailError;

  @override
  State<SendTokenSheet> createState() => _SendTokenSheetState();
}

class _SendTokenSheetState extends State<SendTokenSheet> {
  final FocusNode _amountFocus = FocusNode();
  final TextEditingController _amountController = TextEditingController();
  String errorMessage = "Sending amount must be greater than zero";
  final _errors = {
    "balance": "Insufficient Balance",
    "zero": "Sending amount must be greater than zero",
  };
  BigInt actualAmount = BigInt.zero;
  BigInt? amount;
  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      _validateAmountInput(_amountController.text, setActualAmount: false);
    });
  }

  void _validateAmountInput(String input, {bool setActualAmount = true}) {
    if (input.isEmpty || input == ".") {
      input = "0";
    }
    amount = Decimal.parse(input).toBigInt();
    if (amount == null) {
      if (errorMessage != _errors["zero"]) {
        setState(() {
          errorMessage = _errors["zero"]!;
        });
      }
    }
    if (setActualAmount) {}
    if (actualAmount == BigInt.zero) {
      if (errorMessage != _errors["zero"]) {
        setState(() {
          errorMessage = _errors["zero"]!;
        });
      }
    } else {
      if (errorMessage != _errors["balance"]) {
        setState(() {
          errorMessage = _errors["balance"]!;
        });
      }
    }
  }

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
                'Send',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: font19,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  height: 100.h,
                ),
                Text('To',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: font19,
                        fontWeight: FontWeight.w600))
              ],
            ),
            AddressBar(
                textEditingController: widget.addressController!,
                hintText: widget.hintText!),
            SizedBox(
              height: 24.h,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: TextFormField(
                controller: _amountController,
                focusNode: _amountFocus,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\.?\d*(?<!\.)\.?\d*'))
                ],
                style: const TextStyle(fontFamily: 'Inter', fontSize: 25),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(),
                onChanged: (val) {
                  _validateAmountInput(val);
                },
              ),
            ),
            Expanded(child: Container()),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
                elevation: 0,
                backgroundColor: lightGreen,
              ),
              child: Text(
                'Next',
                style: TextStyle(
                    color: black,
                    fontFamily: 'Inter',
                    fontSize: font19,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
