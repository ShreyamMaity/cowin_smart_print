import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);
  static Color windowButtonAlphaColor(
      ThemeData style, Set<ButtonStates> states) {
    if (style.brightness == Brightness.light) {
      if (states.isPressing) return Colors.black.withOpacity(0.075);
      if (states.isHovering) return Colors.black.withOpacity(0.11);
      return Colors.transparent;
    } else {
      if (states.isPressing) return Colors.white.withOpacity(0.03);
      if (states.isHovering) return Colors.white.withOpacity(0.06);
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    assert(debugCheckHasFluentLocalizations(context));
    final ThemeData theme = FluentTheme.of(context);

    final buttonColors = WindowButtonColors(
      iconNormal: theme.inactiveColor,
      iconMouseDown: theme.inactiveColor,
      iconMouseOver: theme.inactiveColor,
      //Fixed button colors
      mouseOver:
          ButtonThemeData.buttonColor(theme.brightness, {ButtonStates.hovering})
              .lerpWith(Colors.black, 0.12),
      mouseDown:
          ButtonThemeData.buttonColor(theme.brightness, {ButtonStates.pressing})
              .lerpWith(theme.shadowColor, 0.12)
              .withAlpha(150),
    );
    final closeButtonColors = WindowButtonColors(
      mouseOver: Colors.red,
      mouseDown: Colors.red.dark,
      iconNormal: theme.inactiveColor,
      iconMouseOver: Colors.red.basedOnLuminance(),
      iconMouseDown: Colors.red.dark.basedOnLuminance(),
    );
    return Row(children: [
      Tooltip(
        message: FluentLocalizations.of(context).minimizeWindowTooltip,
        child: MinimizeWindowButton(colors: buttonColors),
      ),
      Tooltip(
        message: FluentLocalizations.of(context).closeWindowTooltip,
        child: CloseWindowButton(colors: closeButtonColors),
      ),
    ]);
  }
}
