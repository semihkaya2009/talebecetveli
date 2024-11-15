import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:talebecetveli/internet_yok.dart';
import 'package:talebecetveli/login/kullanici_olustur.dart';
import 'package:talebecetveli/methods.dart';
import 'package:talebecetveli/myapp.dart';

class GorusVeOneriBildir extends StatefulWidget {
  const GorusVeOneriBildir({super.key});

  @override
  State<GorusVeOneriBildir> createState() => _GorusVeOneriBildirState();
}

class _GorusVeOneriBildirState extends State<GorusVeOneriBildir> {
  String yazi =
      "Görüş ve Önerilerinizi önemsiyoruz. Uygulamamızı geliştirmek için görüş ve önerilerinizi aşağıya yazarak bizimle paylaşabilirsiniz.";
  TextEditingController gorusOneri = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Görüş ve Öneri Bildir',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Stack(
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
          getBody(),
        ],
      ),
    );
  }

  getBody() {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    yazi,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    child: TextField(
                      controller: gorusOneri,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Görüş ve önerinizi buraya yazınız...',
                        border: const OutlineInputBorder(),
                        fillColor: Colors.grey[300],
                        filled: true,
                      ),
                    ),
                  ),
                  kaydetButon(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  kaydetButon() {
    return ElevatedButton(
      child: const Text('Gönder'),
      onPressed: () async {
        final result = await Connectivity().checkConnectivity();
        final hasInternet = result.first;

        if (hasInternet == ConnectivityResult.none) {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const InternetYok(
                    sayfaAdi: KullaniciOlustur(),
                  ),
                ),
                (route) => false);
            return;
          }
        }
        if (gorusOneri.text.isEmpty) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(
                milliseconds: 500,
              ),
              content: Text(
                'Henüz gönderiecek bir şey yazmadınız :)',
              ),
            ),
          );
          return;
        }

        FirebaseFirestore.instance.collection('gorusOneriler').add({
          'mesaj': gorusOneri.text,
          'tarih': DateTime.now(),
          'gonderenAd': MyApp.adSoyad.text,
          'gonderenMail': MyApp.mail.text,
        }).then((value) {
          gorusOneri.clear();
          if (mounted) {
            onaylandi(context, 'Görüş ve öneriniz başarıyla gönderildi :)');
          }
        });
      },
    );
  }
}
