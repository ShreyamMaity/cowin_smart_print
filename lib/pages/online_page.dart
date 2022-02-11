import 'package:fluent_ui/fluent_ui.dart';

class OnlinePage extends StatefulWidget {
  final ThemeData theme;
  const OnlinePage({
    Key? key,
    required this.theme,
  }) : super(key: key);

  @override
  _OnlinePageState createState() => _OnlinePageState();
}

class _OnlinePageState extends State<OnlinePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('Online'),
      color: widget.theme.micaBackgroundColor,
      child: Center(
        child: Text('Coming Soon', style: widget.theme.typography.bodyLarge),
      ),
    );
  }
}
