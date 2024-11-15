import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:talebecetveli/ogrenci/ogrenci_ana_sayfa.dart';
import 'package:talebecetveli/internet_yok.dart';
import 'package:talebecetveli/login/profil_tamamla.dart';
import 'package:talebecetveli/myapp.dart';

class MailOnayla extends StatefulWidget {
  const MailOnayla({super.key});

  @override
  State<MailOnayla> createState() => _MailOnaylaState();
}

class _MailOnaylaState extends State<MailOnayla> {
  bool isload = true;
  User? user;
  Timer? timer;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    user?.sendEmailVerification();
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        mailOnayla(context);
      },
    );
    isload = false;
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  getBody() {
    return Stack(
      children: <Widget>[
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
        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage('assets/icon/icon.png'),
                radius: 70.0,
              ),
              SizedBox(height: 30.0),
              Text(
                'Mailinizi \n Onaylayın',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lobster',
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50.0),
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'Mailinize gelen linke tıklayarak hesabınızı onaylayın. \n Hesabınız onaylandıktan sonra otomatik olarak giriş yapılacaktır. \n Spam klasörünüzü kontrol edin.',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> mailOnayla(context) async {
    final result = await Connectivity().checkConnectivity();
    final hasInternet = result.first;

    if (hasInternet == ConnectivityResult.none) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const InternetYok(sayfaAdi: MailOnayla()),
          ),
          (route) => false);
      return;
    }
    user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user?.emailVerified ?? false) {
      timer?.cancel();

      await FirebaseFirestore.instance
          .collection("kullanicilar")
          .where('mail', isEqualTo: MyApp.mail.text)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          var doc = value.docs;
          MyApp.adSoyad.text = doc[0].data()['adsoyad'];
          MyApp.mail.text = doc[0].data()['mail'];
          MyApp.ogrenci = doc[0].data()['ogrenci'];
          MyApp.ogretmen = doc[0].data()['ogretmen'];
          MyApp.sifre.text = doc[0].data()['sifre'];
          MyApp.telefonNo.text = doc[0].data()['telno'];

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const OgrenciAnaSayfa(),
              ),
              (route) => false);
          return;
        }
      });

      // ignore: unrelated_type_equality_checks

      FirebaseFirestore.instance.collection('kullanicilar').add({
        'mail': MyApp.mail.text,
        'sifre': MyApp.sifre.text,
        'adsoyad': MyApp.adSoyad.text,
        'telno': MyApp.telefonNo.text,
        'ogrenci': MyApp.ogrenci,
        'ogretmen': MyApp.ogretmen,
        'dogumtarihi': MyApp.date.toIso8601String(),
      });

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfilTamamla(),
          ),
          (route) => false);
    }
  }
}
