import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart' as animBtn;
import 'package:system_theme/system_theme.dart';

import 'package:cowin_smart_card/pages/homepage.dart';
import 'package:cowin_smart_card/tools/convert_card.dart';

class PrintService extends StatefulWidget {
  const PrintService({
    Key? key,
  }) : super(key: key);

  @override
  State<PrintService> createState() => _PrintServiceState();
}

class _PrintServiceState extends State<PrintService> {
  final animBtn.RoundedLoadingButtonController _btnController =
      animBtn.RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: showPdf
          ? BoxDecoration(borderRadius: BorderRadius.circular(35), boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 7.0,
                spreadRadius: 0,
                offset: const Offset(
                  -5.0,
                  -5.0,
                ),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 7.0,
                spreadRadius: 0,
                offset: const Offset(
                  5.0,
                  5.0,
                ),
              ),
            ])
          : null,
      child: animBtn.RoundedLoadingButton(
        color: SystemTheme.accentInstance.accent,
        elevation: 2,
        width: 100,
        child: const Text('Print'),
        controller: _btnController,
        onPressed: converted
            ? () {
                Timer(const Duration(seconds: 1), () async {
                  isSmartPrint
                      ? await Printing.sharePdf(bytes: convertedPdf!)
                      : await Printing.layoutPdf(
                          onLayout: (PdfPageFormat format) async => pdf.save(),
                          usePrinterSettings: false);
                  setState(() {
                    converted = false;
                  });
                  _btnController.success();
                });
              }
            : null,
      ),
    );
  }
}
