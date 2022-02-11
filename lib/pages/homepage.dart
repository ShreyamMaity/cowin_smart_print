// ignore_for_file: prefer_const_constructors

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cowin_smart_card/pages/offline_page.dart';
import 'package:cowin_smart_card/pages/online_page.dart';
import 'package:cowin_smart_card/utils/modified_paneitem.dart';
import 'package:cowin_smart_card/utils/window_buttons.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;

bool converted = false;
bool showPicked = false;
bool showPdf = false;
bool isSmartCard = false;
bool isSmartPrint = true;

class HomePage extends StatefulWidget {
  final String version;
  const HomePage({
    Key? key,
    required this.version,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool value = false;

  int index = 0;

  final colorsController = ScrollController();
  final settingsController = ScrollController();

  @override
  void dispose() {
    colorsController.dispose();
    settingsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // Window.setEffect(effect: WindowEffect.acrylic,);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return NavigationView(
      contentShape: RoundedRectangleBorder(
        side: BorderSide(
            width: 0.3,
            color: theme.micaBackgroundColor.lerpWith(Colors.black, 0.25)),
        borderRadius: const BorderRadius.only(),
      ),
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        actions: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: MoveWindow(
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 9, left: 13, right: 13),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cowin Smart Card Maker',
                                  style: theme.typography.caption),
                              const SizedBox(width: 10),
                              Text('v${widget.version}',
                                  style: theme.typography.caption?.copyWith(
                                      color: theme.inactiveColor.withAlpha(
                                          theme.brightness.isLight
                                              ? 0x3F
                                              : 0x1B))),
                            ])))),
            const WindowButtons()
          ],
        ),
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (i) => setState(() => index = i),
        header: Container(
          height: kOneLineTileHeight,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: material.Row(children: [
            AnimatedContainer(
              width: 28,
              height: 28,
              duration: const Duration(milliseconds: 750),
              curve: Curves.fastOutSlowIn,
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/logo.png"))),
            ),
            const SizedBox(width: 10),
            const Text("Cowin Smart Print",
                style: TextStyle(fontSize: 20, fontFamily: 'Risque')),
            const SizedBox(width: 10)
          ]),
        ),
        displayMode: PaneDisplayMode.top,
        items: [
          ThemablePaneItem(
              icon: const material.Icon(CupertinoIcons.macwindow),
              title: const Text('Offline'),
              translucent: true,
              forceDisplayMode: PaneDisplayMode.top),
          PaneItemSeparator(),
          ThemablePaneItem(
              icon: const material.Icon(CupertinoIcons.globe),
              title: const Text('Online'),
              translucent: true,
              forceDisplayMode: PaneDisplayMode.top),
        ],
      ),
      content: NavigationBody(
        index: index,
        transitionBuilder: (child, animation) => SlideTransition(
            position: animation.drive(Tween<Offset>(
                begin: const Offset(0, 0), end: const Offset(0, 0))),
            child: child),
        children: [
          OfflinePage(theme: theme),
          OnlinePage(theme: theme),
        ],
      ),
    );
  }
}
