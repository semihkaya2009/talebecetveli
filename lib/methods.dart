import 'package:flutter/material.dart';

Future<void> onaylandi(BuildContext context, String text) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              const Image(
                image: AssetImage('assets/images/check.png'),
                height: 150,
                width: 150,
              ),
              Text(text),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Tamam'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void mySnackBar(String text, Color c, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 500),
      backgroundColor: c,
      content: Text(text.toString()),
    ),
  );
}

  background() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/images/desen.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.blue.withOpacity(0.2),
            BlendMode.dstATop,
          ),
        ),
      ),
    );
  }