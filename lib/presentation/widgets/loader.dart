import 'package:flutter/material.dart';


class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: new AlwaysStoppedAnimation<Color>(
              Colors.blue),
        ),
      ),
    );
  }
}
