import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cowin_smart_card/pages/homepage.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  await SystemTheme.accentInstance.load();
  if (Platform.isWindows) {
    await Window.hideWindowControls();
    doWhenWindowReady(() {
      appWindow
        ..minSize = const Size(740, 540)
        ..maxSize = const Size(740, 540)
        ..size = const Size(740, 540)
        ..alignment = Alignment.center
        ..show();
    });
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();

    //  Window.setEffect(
    //   effect: WindowEffect.acrylic,
    //   color: SystemTheme.accentInstance.accent,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = true;

    return FluentApp(
      title: 'Cowin Smart Print',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: SystemTheme.accentInstance.accent.toAccentColor(),
        micaBackgroundColor: SystemTheme.accentInstance.accent.toAccentColor(),
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen() ? 2.0 : 0.0,
        ),
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      home: const HomePage(
        version: '1.0.0',
      ),
    );
  }
}
