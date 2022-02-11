import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_switch/flutter_switch.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart' as animBtn;
import 'package:system_theme/system_theme.dart';

import 'package:cowin_smart_card/pages/homepage.dart';
import 'package:cowin_smart_card/tools/convert_card.dart';
import 'package:cowin_smart_card/tools/file_picker.dart';
import 'package:cowin_smart_card/tools/pdf_viewer.dart';
import 'package:cowin_smart_card/tools/print.dart';

class OfflinePage extends StatefulWidget {
  final ThemeData theme;

  const OfflinePage({
    Key? key,
    required this.theme,
  }) : super(key: key);

  @override
  _OfflinePageState createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  final animBtn.RoundedLoadingButtonController _btnController =
      animBtn.RoundedLoadingButtonController();
  Future<Uint8List> getConvertedPdf() async {
    return Future.delayed(const Duration(seconds: 2), () async {
      return convertedPdf!.buffer.asUint8List();
    });
  }

  Future<Uint8List> getOldPdf() async {
    final doc = await PdfDocument.openData(byteData!);
    final page = await doc.getPage(1);
    final finalPage = await page.render(
      width: page.width,
      height: page.height,
    );
    return Future.delayed(const Duration(seconds: 1), () async {
      await doc.close();
      return finalPage!.bytes;
    });
  }

  void _convertMethord() async {
    Convert().convert();
    Timer(const Duration(seconds: 5), () {
      setState(() {
        converted = true;
        picked = false;
        showPdf = true;
      });
      _btnController.success();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('Offline'),
      color: widget.theme.micaBackgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: ui.Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 300,
                  width: 600,
                  decoration: BoxDecoration(
                    color: SystemTheme.accentInstance.accent,
                    // border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        blurRadius: 5.0,
                        spreadRadius: 0,
                        offset: const Offset(
                          10.0,
                          5.0,
                        ),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        blurRadius: 5.0,
                        spreadRadius: 0,
                        offset: const Offset(
                          -10.0,
                          -5.0,
                        ),
                      )
                    ],
                  ),
                  child: showPicked
                      ? FutureBuilder<Uint8List>(
                          future: showPdf ? getConvertedPdf() : getOldPdf(),
                          builder:
                              (context, AsyncSnapshot<Uint8List> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                return showPdf
                                    ? PdfPreviewer(data: snapshot.data!)
                                    : Center(
                                        child: Image(
                                            image:
                                                MemoryImage(snapshot.data!)));
                              }
                            }
                            return const Center(
                                child: material.CircularProgressIndicator());
                          },
                        )
                      : const Center(
                          child: Text('No File Chosen',
                              style: TextStyle(fontFamily: 'Risque')),
                        ),
                ),
                Positioned(
                  left: 150,
                  bottom: 20,
                  child: Visibility(
                      visible: !showPicked && !showPdf,
                      child: FlutterSwitch(
                        width: 90,
                        padding: 1,
                        toggleSize: 20,
                        valueFontSize: 10,
                        activeColor: SystemTheme.accentInstance.darkest,
                        inactiveColor: Colors.grey,
                        toggleBorder: Border.all(color: Colors.black, width: 1),
                        switchBorder: Border.all(
                            color: const ui.Color.fromARGB(255, 75, 75, 75),
                            width: 1),
                        activeIcon:
                            const material.Icon(CupertinoIcons.creditcard),
                        inactiveIcon:
                            const material.Icon(CupertinoIcons.creditcard_fill),
                        showOnOff: true,
                        activeText: 'Smart Card',
                        activeTextFontWeight: FontWeight.w900,
                        inactiveText: 'Paper Card',
                        inactiveTextFontWeight: FontWeight.w900,
                        value: isSmartCard,
                        onToggle: (value) {
                          setState(() {
                            isSmartCard = value;
                          });
                        },
                      )),
                ),
                Positioned(
                  right: 150,
                  bottom: 20,
                  child: Visibility(
                    visible: !showPdf && !showPicked,
                    child: FlutterSwitch(
                      width: 90,
                      padding: 1,
                      toggleSize: 20,
                      valueFontSize: 9,
                      activeColor: SystemTheme.accentInstance.darkest,
                      inactiveColor: Colors.grey,
                      toggleBorder: Border.all(color: Colors.black, width: 1),
                      switchBorder: Border.all(
                          color: const ui.Color.fromARGB(255, 75, 75, 75),
                          width: 1),
                      activeIcon:
                          const material.Icon(CupertinoIcons.creditcard),
                      inactiveIcon:
                          const material.Icon(CupertinoIcons.creditcard_fill),
                      showOnOff: true,
                      activeText: 'Preview Print',
                      activeTextFontWeight: FontWeight.w900,
                      inactiveText: 'Direct Print',
                      inactiveTextFontWeight: FontWeight.w900,
                      value: isSmartPrint,
                      onToggle: (value) {
                        setState(() {
                          isSmartPrint = value;
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  //TODO make this button reset agter donw working
                  child: Visibility(
                    visible: false,
                    child: material.ElevatedButton(
                      child: const Text("Start Over"),
                      onPressed: () {
                        setState(() {
                          showPicked = false;
                          showPdf = false;
                          isSmartCard = false;
                          isSmartPrint = true;
                          picked = false;
                          converted = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PickFile(
                  refreshUI: () => setState(() {}),
                ),
                const Divider(
                  direction: Axis.horizontal,
                  size: 100,
                  style: DividerThemeData(
                      decoration: BoxDecoration(
                    color: Colors.white,
                  )),
                ),
                Container(
                  decoration: showPicked
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
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
                    width: 100,
                    color: SystemTheme.accentInstance.accent,
                    elevation: 2,
                    controller: _btnController,
                    child: const Text('Convert'),
                    onPressed: picked ? _convertMethord : null,
                  ),
                ),
                const Divider(
                  direction: Axis.horizontal,
                  size: 100,
                  style: DividerThemeData(
                      decoration: BoxDecoration(color: Colors.white)),
                ),
                PrintService(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
