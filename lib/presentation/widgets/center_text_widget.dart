import 'package:flutter/material.dart';


class CenterTextWidget extends StatelessWidget {
  const CenterTextWidget({
    String message,
  }) : this._message = message;

  final String _message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(_message),
    );
  }
}
