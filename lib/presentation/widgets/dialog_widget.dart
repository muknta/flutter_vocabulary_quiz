import 'package:flutter/material.dart';


class DialogWidget {
  DialogWidget.show(
    this.context,
    this.text,
  ) {
    _showDialog();
  }
    
  final BuildContext context;
  final String text;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 5, left: 15, right: 15, bottom: 5),
              child: Column(
                children: <Widget>[
                  Text(
                    text,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.blue),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: 
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }
    );
  }
}