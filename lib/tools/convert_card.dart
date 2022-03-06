import 'dart:io';
import 'dart:typed_data';
import 'package:cowin_smart_card/pages/homepage.dart';
import 'package:cowin_smart_card/tools/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pdfpkg;
import 'package:pdf/widgets.dart' as pw;
import 'package:native_pdf_renderer/native_pdf_renderer.dart';

final pdf = pw.Document();
Uint8List? convertedPdf;

class CardPreset {
  static const smartcardHeight = (5.3975 * 72 / 2.54);
  static const smartcardWidth = (8.5725 * 72 / 2.54);
  static const normalCardHeight = (6.1 * 72 / 2.54);
  static const normalCardWidth = (9.3 * 72 / 2.54);
}

class Convert {
  Future<void> convert() async {
    final doc = await PdfDocument.openData(byteData!);
    final page = await doc.getPage(1);
    final backPage = await page.render(
      width: page.width * 8,
      height: page.height * 8,
      cropRect: Rect.fromLTWH(
          // 26, 15, page.width.toDouble() - 110, page.height.toDouble() - 307),
          // 50, 30, page.width.toDouble() *2 - 200, page.height.toDouble() *2 - 630),
          0,
          4550,
          page.width.toDouble() * 8,
          page.height.toDouble() * 8 - 4550),
      quality: 3000,
      format: PdfPageFormat.PNG,
    );
    final frontPage = await page.render(
      width: page.width * 8,
      height: page.height * 8,
      cropRect: Rect.fromLTWH(
          // 26, 570, page.width.toDouble() - 30, page.height.toDouble() - 570),
          // 0, 1140, page.width.toDouble() *2, page.height.toDouble() *2 - 1150),
          0,
          170,
          page.width.toDouble() * 8,
          page.height.toDouble() * 8 - 2550),
      quality: 3000,
      format: PdfPageFormat.PNG,
    );

    final backPageImage = pw.MemoryImage(frontPage!.bytes);
    final frontPageImage = pw.MemoryImage(backPage!.bytes);
    await page.close();
    pdf.addPage(pw.Page(
        pageFormat: pdfpkg.PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Container(
                child: pw.Image(
                  frontPageImage,
                  height: isSmartCard
                      ? CardPreset.smartcardHeight
                      : CardPreset.normalCardHeight,
                  width: isSmartCard
                      ? CardPreset.smartcardWidth
                      : CardPreset.normalCardWidth,
                  fit: pw.BoxFit.fill,
                  dpi: 3000,
                ),
                decoration: pw.BoxDecoration(
                  boxShadow: const [
                    pw.BoxShadow(
                      color: pdfpkg.PdfColors.black,
                      blurRadius: 25.0,
                      spreadRadius: 1.0,
                    )
                  ],
                  borderRadius: pw.BorderRadius.circular(20),
                  color: pdfpkg.PdfColors.black,
                ),
              ),
              pw.SizedBox(
                width: 10,
              ),
              pw.Container(
                child: pw.Image(
                  backPageImage,
                  height: isSmartCard
                      ? CardPreset.smartcardHeight
                      : CardPreset.normalCardHeight,
                  width: isSmartCard
                      ? CardPreset.smartcardWidth
                      : CardPreset.normalCardWidth,
                  fit: pw.BoxFit.fill,
                  dpi: 3000,
                ),
                decoration: pw.BoxDecoration(
                  boxShadow: const [
                    pw.BoxShadow(
                      color: pdfpkg.PdfColors.black,
                      blurRadius: 25.0,
                      spreadRadius: 1.0,
                    )
                  ],
                  borderRadius: pw.BorderRadius.circular(20),
                  color: pdfpkg.PdfColors.black,
                ),
              ),
            ],
          );
        }));
    convertedPdf = await pdf.save();
  }

  Future<void> saveFile() async {
    String? path = await FilePicker.platform.saveFile(
      dialogTitle: 'Save PDF',
      allowedExtensions: ['pdf'],
      type: FileType.custom,
      fileName: 'cowin smart card.pdf',
      lockParentWindow: true,
    );
    if (path != null) {
      final file = File(path);
      await file.writeAsBytes(await pdf.save());
      path = null;
    } else {
      const AlertDialog(
        content: Text('Not Saved'),
      );
    }
  }
}
