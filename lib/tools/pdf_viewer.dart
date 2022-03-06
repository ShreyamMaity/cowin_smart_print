import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PdfPreviewer extends StatefulWidget {
  final Uint8List data;
  const PdfPreviewer({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<PdfPreviewer> createState() => _PdfPreviewerState();
}

class _PdfPreviewerState extends State<PdfPreviewer> {
  PdfController? _pdfController;
  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openData(widget.data),
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: PdfView(
        scrollDirection: Axis.vertical,
        controller: _pdfController!,
        backgroundDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
