import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talebecetveli/internet_yok.dart';
import 'package:talebecetveli/login/mail_onayla.dart';
import 'package:talebecetveli/login/profil_tamamla.dart';
import 'package:talebecetveli/methods.dart';
import 'package:talebecetveli/myapp.dart';
import 'package:talebecetveli/ogrenci/ogrenci_ana_sayfa.dart';
import 'package:talebecetveli/ogretmen/ogretmen_ana_sayfa.dart';

class KullaniciOlustur extends StatefulWidget {
  const KullaniciOlustur({super.key});

  @override
  State<KullaniciOlustur> createState() => _KullaniciOlusturState();
}

class _KullaniciOlusturState extends State<KullaniciOlustur> {
  bool rememberMe = false;
  bool passwordGizliMi = true;
  bool loading = false;
  final auth = FirebaseAuth.instance;
  bool isloading = true;
  bool isActive = true;
  User? user;

  @override
  void initState() {
    super.initState();
    getData(context);
  }

  Widget kullaniciAdiKutusu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Mail Adresi',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: MyApp.mail,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.mail,
                color: Colors.white,
              ),
              hintText: 'Mail Adresi',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget sifreKutusu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Şifre',
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
                  controller: MyApp.sifre,
                  obscureText: passwordGizliMi,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    hintText: 'Şifre',
                    hintStyle: kHintTextStyle,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    passwordGizliMi = !passwordGizliMi;
                  });
                },
                icon: Icon(
                  passwordGizliMi ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        const Text(
          "En az 8 karakterli büyük, küçük harf ve rakam içeren bir şifre belirleyiniz.",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget girisButon() {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: CircularProgressIndicator(),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 35.0),
        width: MediaQuery.of(context).size.width * 0.5,
        child: ElevatedButton(
          onPressed: () {
            kullaniciOlustur(context);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.all(20.0),
          ),
          child: const Text(
            'Başla',
            style: TextStyle(
              color: Color(0xFF527DAA),
              letterSpacing: 1.5,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lobster',
            ),
          ),
        ),
      );
    }
  }

  getData(context) async {
    final result = await Connectivity().checkConnectivity();
    final hasInternet = result.first;

    if (hasInternet == ConnectivityResult.none) {
      // ignore: use_build_context_synchronously
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const InternetYok(
              sayfaAdi: KullaniciOlustur(),
            ),
          ),
          (route) => false);
    }

    SharedPreferences shared = await SharedPreferences.getInstance();
    var m = shared.getString("mail");

    var s = shared.getString("sifre");

    if (m == null && s == null) {
      setState(() {
        isloading = false;
      });
      return;
    }

    if (FirebaseAuth.instance.currentUser?.uid == null) {
      setState(() {
        isloading = false;
      });
      return;
    }

    MyApp.mail.text = m!;
    MyApp.sifre.text = s!;

    if (FirebaseAuth.instance.currentUser?.emailVerified == false) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MailOnayla()),
          (route) => false);
      setState(() {
        isloading = false;
      });
      return;
    }

    FirebaseFirestore.instance
        .collection('kullanicilar')
        .where('mail', isEqualTo: MyApp.mail.text)
        .where('sifre', isEqualTo: MyApp.sifre.text)
        .get()
        .then((value) {
      if (value.docs[0].data()['adsoyad'] != "" &&
          value.docs[0].data()['telno'] != "") {
        MyApp.adSoyad.text = value.docs[0].data()['adsoyad'];
        MyApp.telefonNo.text = value.docs[0].data()['telno'];
        MyApp.ogrenci = value.docs[0].data()['ogrenci'];
        MyApp.ogretmen = value.docs[0].data()['ogretmen'];
        MyApp.date =
            DateFormat("yyyy-MM-dd").parse(value.docs[0].data()['dogumtarihi']);

        if (MyApp.ogrenci == true && MyApp.ogretmen == false) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const OgrenciAnaSayfa(),
              ),
              (route) => false);
          setState(() {
            isloading = false;
          });
          return;
        }

        if (MyApp.ogrenci == false && MyApp.ogretmen == true) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const OgretmenAnaSayfa(),
              ),
              (route) => false);
          setState(() {
            isloading = false;
          });
          return;
        }
        return;
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfilTamamla(),
          ),
          (route) => false);
      setState(() {
        isloading = false;
      });
      return;
    }).whenComplete(() {
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  getBody() {
    if (isloading) {
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
                  'Talebe \n Cetveli',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lobster',
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.0),
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Yükleniyor...',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
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
                  vertical: 100.0,
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
                    const SizedBox(height: 30.0),
                    kullaniciAdiKutusu(),
                    const SizedBox(
                      height: 30.0,
                    ),
                    sifreKutusu(),
                    girisButon(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void kullaniciOlustur(context) async {
    setState(() {
      isloading = true;
    });
    final result = await Connectivity().checkConnectivity();
    final hasInternet = result.first;
    if (hasInternet == ConnectivityResult.none) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const InternetYok(
              sayfaAdi: KullaniciOlustur(),
            ),
          ),
          (route) => false);

      setState(() {
        isloading = false;
      });
      return;
    }

    if (MyApp.mail.text.isEmpty || MyApp.sifre.text.isEmpty) {
      setState(() {
        isloading = false;
      });
      return mySnackBar("Boş alanları doldurunuz!", Colors.red, context);
    }

    MyApp.mail.text = MyApp.mail.text.replaceAll(" ", "");
    final bool gecerliMi = EmailValidator.validate(MyApp.mail.text);
    if (!gecerliMi) {
      setState(() {
        isloading = false;
      });
      return mySnackBar("Mail Adresi Geçersiz", Colors.red, context);
    }

    if (MyApp.sifre.text.length < 8) {
      setState(() {
        isloading = false;
      });
      mySnackBar(
          "Şifrenizin en az 8 karakterli olması gerekir.", Colors.red, context);
      return;
    }

    if (!MyApp.sifre.text.contains("0") &&
        !MyApp.sifre.text.contains("1") &&
        !MyApp.sifre.text.contains("2") &&
        !MyApp.sifre.text.contains("3") &&
        !MyApp.sifre.text.contains("4") &&
        !MyApp.sifre.text.contains("5") &&
        !MyApp.sifre.text.contains("7") &&
        !MyApp.sifre.text.contains("8") &&
        !MyApp.sifre.text.contains("9")) {
      setState(() {
        isloading = false;
      });
      mySnackBar(
          "Şifrenizde en az bir rakam bulunması gerekir.", Colors.red, context);
      return;
    }

    if (!MyApp.sifre.text.contains("q") &&
        !MyApp.sifre.text.contains("w") &&
        !MyApp.sifre.text.contains("e") &&
        !MyApp.sifre.text.contains("r") &&
        !MyApp.sifre.text.contains("t") &&
        !MyApp.sifre.text.contains("y") &&
        !MyApp.sifre.text.contains("u") &&
        !MyApp.sifre.text.contains("ı") &&
        !MyApp.sifre.text.contains("o") &&
        !MyApp.sifre.text.contains("p") &&
        !MyApp.sifre.text.contains("ğ") &&
        !MyApp.sifre.text.contains("ü") &&
        !MyApp.sifre.text.contains("a") &&
        !MyApp.sifre.text.contains("s") &&
        !MyApp.sifre.text.contains("d") &&
        !MyApp.sifre.text.contains("f") &&
        !MyApp.sifre.text.contains("g") &&
        !MyApp.sifre.text.contains("h") &&
        !MyApp.sifre.text.contains("j") &&
        !MyApp.sifre.text.contains("k") &&
        !MyApp.sifre.text.contains("l") &&
        !MyApp.sifre.text.contains("ş") &&
        !MyApp.sifre.text.contains("i") &&
        !MyApp.sifre.text.contains("z") &&
        !MyApp.sifre.text.contains("x") &&
        !MyApp.sifre.text.contains("c") &&
        !MyApp.sifre.text.contains("v") &&
        !MyApp.sifre.text.contains("b") &&
        !MyApp.sifre.text.contains("n") &&
        !MyApp.sifre.text.contains("m") &&
        !MyApp.sifre.text.contains("ö") &&
        !MyApp.sifre.text.contains("ç")) {
      setState(() {
        isloading = false;
      });
      mySnackBar("Şifrenizde en az bir küçük harf bulunması gerekir.",
          Colors.red, context);
      return;
    }

    if (!MyApp.sifre.text.contains("Q") &&
        !MyApp.sifre.text.contains("W") &&
        !MyApp.sifre.text.contains("E") &&
        !MyApp.sifre.text.contains("R") &&
        !MyApp.sifre.text.contains("T") &&
        !MyApp.sifre.text.contains("Y") &&
        !MyApp.sifre.text.contains("U") &&
        !MyApp.sifre.text.contains("I") &&
        !MyApp.sifre.text.contains("O") &&
        !MyApp.sifre.text.contains("P") &&
        !MyApp.sifre.text.contains("Ğ") &&
        !MyApp.sifre.text.contains("Ü") &&
        !MyApp.sifre.text.contains("A") &&
        !MyApp.sifre.text.contains("S") &&
        !MyApp.sifre.text.contains("D") &&
        !MyApp.sifre.text.contains("F") &&
        !MyApp.sifre.text.contains("G") &&
        !MyApp.sifre.text.contains("H") &&
        !MyApp.sifre.text.contains("J") &&
        !MyApp.sifre.text.contains("K") &&
        !MyApp.sifre.text.contains("L") &&
        !MyApp.sifre.text.contains("Ş") &&
        !MyApp.sifre.text.contains("İ") &&
        !MyApp.sifre.text.contains("Z") &&
        !MyApp.sifre.text.contains("X") &&
        !MyApp.sifre.text.contains("C") &&
        !MyApp.sifre.text.contains("V") &&
        !MyApp.sifre.text.contains("B") &&
        !MyApp.sifre.text.contains("N") &&
        !MyApp.sifre.text.contains("M") &&
        !MyApp.sifre.text.contains("Ö") &&
        !MyApp.sifre.text.contains("Ç")) {
      setState(() {
        isloading = false;
      });
      mySnackBar("Şifrenizde en az bir büyük harf bulunması gerekir.",
          Colors.red, context);
      return;
    }

    var mesaj = "";
    try {
      await auth.signInWithEmailAndPassword(
          email: MyApp.mail.text, password: MyApp.sifre.text);

      SharedPreferences ref = await SharedPreferences.getInstance();
      ref.setString("mail", MyApp.mail.text);

      ref.setString("sifre", MyApp.sifre.text);

      FirebaseFirestore.instance
          .collection('kullanicilar')
          .where('mail', isEqualTo: MyApp.mail.text)
          .where('sifre', isEqualTo: MyApp.sifre.text)
          .get()
          .then((value) async {
        for (var element in value.docs) {
          if (element.data()['adsoyad'] == null &&
              element.data()['telno'] == null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ProfilTamamla()),
                (route) => false);
            setState(() {
              isloading = false;
            });
            return;
          }
          MyApp.ogrenci = element.data()['ogrenci'];
          MyApp.ogretmen = element.data()['ogretmen'];
          MyApp.adSoyad.text = element.data()['adsoyad'];
          MyApp.telefonNo.text = element.data()['telno'];
          DateTime dogumtarihi =
              DateFormat("yyyy-MM-dd").parse(element.data()['dogumtarihi']);
          MyApp.date = dogumtarihi;

          if (MyApp.ogrenci == true && MyApp.ogretmen == false) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const OgrenciAnaSayfa()),
                (route) => false);
            setState(() {
              isloading = false;
            });
            return;
          }
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const OgretmenAnaSayfa()),
              (route) => false);

          setState(() {
            isloading = false;
          });
        }
      });
    } catch (e) {
      mesaj = e.toString();

      if (mesaj.startsWith("[firebase_auth/user-not-found]")) {
        await auth.createUserWithEmailAndPassword(
            email: MyApp.mail.text, password: MyApp.sifre.text);

        SharedPreferences ref = await SharedPreferences.getInstance();
        ref.setString("mail", MyApp.mail.text);

        ref.setString("sifre", MyApp.sifre.text);

        //MailOnayla sayfasına git
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MailOnayla()),
            (route) => false);

        setState(() {
          isloading = false;
        });
        return;
      }

      if (mesaj.startsWith("[firebase_auth/wrong-password]")) {
        setState(() {
          isloading = false;
        });
        MyApp.sifre.clear();
        mySnackBar("Bu mail zaten kullanılıyor ya da şifreniz Yanlış!",
            Colors.red, context);
        return;
      }
    }

    SharedPreferences ref = await SharedPreferences.getInstance();
    ref.setString("mail", MyApp.mail.text);

    ref.setString("sifre", MyApp.sifre.text);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
        (route) => false);
    setState(() {
      isloading = false;
    });
  }

  isload() {
    if (isloading) {
      return const Stack(
        children: [
          Opacity(
            opacity: 0.7,
            child: ModalBarrier(
              color: Colors.grey,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Text("Yükleniyor..."),
              ],
            ),
          ),
        ],
      );
    }
    return Container();
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
