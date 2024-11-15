// ignore_for_file: deprecated_member_use

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InternetYok extends StatefulWidget {
  final Widget sayfaAdi;
  const InternetYok({super.key, required this.sayfaAdi});

  @override
  State<InternetYok> createState() => _InternetYokState();
}

class _InternetYokState extends State<InternetYok> {
  DateTime timeBackPressed = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWaiting = difference >= const Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if (isExitWaiting) {
          const message = "Çıkmak için tekrar basın";
          Fluttertoast.showToast(
            msg: message,
            backgroundColor: Colors.grey,
          );

          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title:
              const Text("İnternet Yok", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: getBody(),
      ),
    );
  }

  getBody() {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF73AEF5),
                Color(0xFF61A4F1),
                Color(0xFF478DE0),
                Color(0xFF398AE5),
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),
        ),
        child(),
      ],
    );
  }

  child() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Icon(
          Icons.wifi_off,
          color: Colors.white,
          size: 150,
        ),
        Center(
          child: SizedBox(
            width: 200,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12),
              ),
              onPressed: () async {
                final result = await Connectivity().checkConnectivity();
                final res = result.first;
                showConnectivityBar(res);
              },
              child: const Text("Tekrar Deneyin"),
            ),
          ),
        ),
      ],
    );
  }

  void showConnectivityBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    if (hasInternet) {
      //Önceki sayfaya geri git
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.sayfaAdi),
          (route) => false);

      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 500),
        backgroundColor: Colors.red,
        content: Text("İNTERNET YOK!"),
      ),
    );
  }
}
