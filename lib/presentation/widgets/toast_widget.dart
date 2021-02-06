import 'package:flutter/material.dart';
import 'package:toast/toast.dart';


class ToastWidget {
  ToastWidget.show(
    this.text,
    this.context,
    this.isPositive,
  ) {
    _showToast();
  }
    
  final String text;
  final bool isPositive;
  final BuildContext context;

  void _showToast() {
    Toast.show(
      text,
      context,
      duration: Toast.LENGTH_LONG,
      gravity:  Toast.TOP,
      backgroundColor: isPositive
          ? Colors.green
          : Colors.red,
    );
  }
}

