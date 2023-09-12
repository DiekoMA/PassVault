import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HiddenTextTile extends StatefulWidget {
  final String hiddenText;

  HiddenTextTile({required this.hiddenText});

  @override
  _HiddenTextTileState createState() => _HiddenTextTileState();
}

class _HiddenTextTileState extends State<HiddenTextTile> {
  bool isTextVisible = false;

  void toggleVisibility() {
    setState(() {
      isTextVisible = !isTextVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Password'),
      subtitle: GestureDetector(
        onTap: toggleVisibility,
        child: isTextVisible ? Text(widget.hiddenText) : Text('Tap to reveal'),
      ),
      trailing: Icon(Icons.copy),
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: widget.hiddenText));
      },
    );
  }
}
