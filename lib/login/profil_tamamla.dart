import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:talebecetveli/ogrenci/ogrenci_ana_sayfa.dart';
import 'package:talebecetveli/internet_yok.dart';
import 'package:talebecetveli/ogretmen/ogretmen_ana_sayfa.dart';
import 'package:talebecetveli/myapp.dart';

class ProfilTamamla extends StatefulWidget {
  const ProfilTamamla({super.key});

  @override
  State<ProfilTamamla> createState() => _ProfilTamamlaState();
}

class _ProfilTamamlaState extends State<ProfilTamamla> {
  @override
  void initState() {
    hasInternet(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
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
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/icon/icon.png'),
                        radius: 70.0,
                      ),
                      const SizedBox(height: 30.0),
                      const Text(
                        'Talebe \n Cetveli',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lobster',
                          fontSize: 60.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      adSoyadKutusu(),
                      const SizedBox(
                        height: 20,
                      ),
                      telNoKutusu(),
                      const SizedBox(
                        height: 25,
                      ),
                      dogumTarihiKutusu(),
                      const SizedBox(
                        height: 16,
                      ),
                      kullaniciTuruSecimiKutusu(),
                      kaydetButonu(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget telNoKutusu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Telefon No',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: MyApp.telefonNo,
            keyboardType: TextInputType.phone,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.white,
              ),
              hintText: 'Telefon No',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget adSoyadKutusu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Ad - Soyad',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: MyApp.adSoyad,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    hintText: 'Ad - Soyad',
                    hintStyle: kHintTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  hasInternet(context) async {
    final result = await Connectivity().checkConnectivity();
    final hasInternet = result.first;

    if (hasInternet == ConnectivityResult.none) {
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const InternetYok(
              sayfaAdi: ProfilTamamla(),
            ),
          ),
          (route) => false);
    }
  }

  Widget dogumTarihiKutusu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Doğum Tarihi Seçiniz',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Doğum Tarihi: ",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                ),
                onPressed: () {
                  showDatePicker(
                    locale: const Locale('tr'),
                    context: context,
                    initialDate: MyApp.date,
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        MyApp.date = value;
                      });
                    }
                  });
                },
                child: Text(
                  "${MyApp.date.day} / ${MyApp.date.month} / ${MyApp.date.year}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  kullaniciTuruSecimiKutusu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Radio(
                activeColor: Colors.white,
                value: true,
                groupValue: MyApp.ogrenci,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      if (MyApp.ogretmen == true) {
                        MyApp.ogretmen = false;
                      }
                      MyApp.ogrenci = value ?? false;
                      return;
                    }
                    MyApp.ogrenci = value ?? false;
                  });
                }),
            Text(
              "Öğrenci",
              style: TextStyle(
                  color: MyApp.ogrenci == true ? Colors.white : Colors.black),
            ),
          ],
        ),
        Row(
          children: [
            Radio(
                activeColor: Colors.white,
                value: true,
                groupValue: MyApp.ogretmen,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      if (MyApp.ogrenci == true) {
                        MyApp.ogrenci = false;
                      }
                      MyApp.ogretmen = value ?? false;
                      return;
                    }
                    MyApp.ogretmen = value ?? false;
                  });
                }),
            Text(
              "Öğretmen",
              style: TextStyle(
                color: MyApp.ogretmen == true ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  kaydetButonu(context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await Connectivity().checkConnectivity();
        final hasInternet = result.first;

        if (hasInternet == ConnectivityResult.none) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const InternetYok(
                  sayfaAdi: ProfilTamamla(),
                ),
              ),
              (route) => false);
          return;
        }

        if (MyApp.adSoyad.text == "") {
          mySnackBar("Ad boş olamaz!", Colors.red);
          return;
        }
        if (MyApp.telefonNo.text == "") {
          mySnackBar("Telefon boş olamaz!", Colors.red);
          return;
        }
        if (MyApp.ogrenci == false && MyApp.ogretmen == false) {
          mySnackBar("Kullanıcı türü seçmelisiniz!", Colors.red);
          return;
        }

        DateTime date = DateTime.parse(MyApp.date.toString());
        var date2 = DateFormat('yyyy-MM-dd').format(date);

        // firebasefirestorede mail varsa o sütuna ad soad, telefon no, dogum tarihi, kullanici turu ekle
        FirebaseFirestore.instance
            .collection("kullanicilar")
            .where("mail", isEqualTo: MyApp.mail.text)
            .get()
            .then((value) {
          for (var element in value.docs) {
            FirebaseFirestore.instance
                .doc("kullanicilar/${element.id}")
                .update({
              "adsoyad": MyApp.adSoyad.text,
              "telno": MyApp.telefonNo.text,
              "MyApp.date": date2,
              "ogrenci": MyApp.ogrenci,
              "ogretmen": MyApp.ogretmen,
            });
          }
        });

        // kullanıcının seçtiği türe göre öğretmen sayfasına yada öğrenci sayfasına yönlendirir.
        if (MyApp.ogretmen == true && MyApp.ogrenci == false) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const OgretmenAnaSayfa(),
              ),
              (route) => false);
          return;
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const OgrenciAnaSayfa(),
            ),
            (route) => false);
      },
      child: const Text("BİTTİ"),
    );
  }

  void mySnackBar(String text, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 500),
        backgroundColor: c,
        content: Text(text.toString()),
      ),
    );
  }
}

const kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

const kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
