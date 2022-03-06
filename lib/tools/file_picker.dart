// ignore_for_file: prefer_final_fields, unused_field

import 'dart:async';
import 'dart:typed_data';

import 'package:cowin_smart_card/pages/homepage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart' as animBtn;
import 'package:system_theme/system_theme.dart';

bool picked = false;
String? filePath;
Uint8List? byteData;

class PickFile extends StatefulWidget {
  final Function refreshUI;
  const PickFile({
    Key? key,
    required this.refreshUI,
  }) : super(key: key);
  @override
  _PickFileState createState() => _PickFileState();
}

class _PickFileState extends State<PickFile> {
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        onFileLoading: (FilePickerStatus status) => print(status),
        lockParentWindow: true,
        withData: true,
        dialogTitle: 'Select a file',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      filePath = _paths != null
          ? _paths!.map((e) => {e.path, byteData = e.bytes}).toString()
          : '...';
      if (_paths != null) {
        picked = true;
        showPicked = true;
        widget.refreshUI();
      }
      if (_paths == null) {
        _btnController.reset();
      }
      _userAborted = _paths == null;
    });
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _btnController.reset();
      picked = false;
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _userAborted = false;
    });
  }

  final animBtn.RoundedLoadingButtonController _btnController =
      animBtn.RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          boxShadow: picked
              ? null
              : converted
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        blurRadius: 7.0,
                        spreadRadius: 0,
                        offset: Offset(
                          -5.0,
                          -5.0,
                        ),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        blurRadius: 7.0,
                        spreadRadius: 0,
                        offset: Offset(
                          5.0,
                          5.0,
                        ),
                      ),
                    ]),
      child: animBtn.RoundedLoadingButton(
        color: SystemTheme.accentInstance.accent,
        elevation: 2,
        width: 100,
        child: Text(
          'Pick File',
        ),
        controller: _btnController,
        onPressed: picked
            ? null
            : converted
                ? null
                : () async {
                    Timer(Duration(seconds: 1), () {
                      _pickFiles();
                      _btnController.success();
                    });
                  },
      ),
    );
  }
}
