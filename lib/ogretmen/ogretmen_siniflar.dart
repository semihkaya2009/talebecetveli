import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

//
// import 'package:share_plus/share_plus.dart';
import 'package:talebecetveli/internet_yok.dart';
import 'package:talebecetveli/methods.dart';
import 'package:talebecetveli/model/model_sinif.dart';
import 'package:talebecetveli/ogretmen/ogretmen_ana_sayfa.dart';
import 'package:talebecetveli/ogretmen/sinif_ayrinti.dart';
import 'package:talebecetveli/myapp.dart';

class OgretmenSiniflar extends StatefulWidget {
  const OgretmenSiniflar({super.key});

  @override
  State<OgretmenSiniflar> createState() => _OgretmenSiniflarState();
}

class _OgretmenSiniflarState extends State<OgretmenSiniflar> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  bool loading = true;
  String sinifKodu = "";
  TextEditingController sinifAdi = TextEditingController();
  List<ModelSinif> siniflar = [];
  String sinifLink = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Gruplarım', style: TextStyle(color: Colors.white)),
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
          isload(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sinif();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  getBody() {
    if (siniflar.isEmpty) {
      return const Center(
        child: Text("Grubunuz bulunmamaktadır.",
            style: TextStyle(fontSize: 20, color: Colors.white)),
      );
    }
    return ListView.builder(
      itemCount: siniflar.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            child: ListTile(
              trailing: IconButton(
                  onPressed: () {
                    sinifAyrinti(siniflar[index]);
                  },
                  icon: const Icon(Icons.info)),
              onTap: () {
                internetVarmi();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SinifAyrinti(sinif: siniflar[index])));
              },
              title: Text(siniflar[index].sinifAdi),
              subtitle: Text('SINIF KODU: ${siniflar[index].sinifKodu}'),
            ),
          ),
        );
      },
    );
  }

  internetVarmi() async {
    final result = await Connectivity().checkConnectivity();
    final hasInternet = result.first;

    if (hasInternet == ConnectivityResult.none) {
      // ignore: use_build_context_synchronously
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const InternetYok(
              sayfaAdi: OgretmenAnaSayfa(),
            ),
          ),
          (route) => false);
    }
  }

  getData() {
    FirebaseFirestore.instance
        .collection('siniflar')
        .where('sinifOgretmeni', isEqualTo: MyApp.mail.text)
        .get()
        .then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        var data = value.docs[i].data();
        setState(() {
          siniflar.add(ModelSinif(
              sinifLink: data['sinifLink'],
              sinifAdi: data['sinifAdi'],
              sinifKodu: data['sinifKodu'],
              sinifOgretmeni: data['sinifOgretmeni']));
        });
      }
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  Future<void> sinifAyrinti(ModelSinif sinif) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sınıf Ayrıntı'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Sınıf Adı: ${sinif.sinifAdi}'),
                Row(
                  children: [
                    SelectableText('Sınıf Kodu: ${sinif.sinifKodu}'),
                    IconButton(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: sinif.sinifKodu));
                          mySnackBar("Kopyalandı!", Colors.green, context);
                        },
                        icon: const Icon(Icons.copy)),
                    IconButton(
                        onPressed: () {
                          Share.share(
                              "${sinif.sinifAdi} adlı sınıfıma katılmak için bu kodu kullan: ${sinif.sinifKodu}");
                        },
                        icon: const Icon(Icons.share)),
                  ],
                ),
                Text('Sınıf Öğretmeni: ${sinif.sinifOgretmeni}'),
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

  isload() {
    if (loading) {
      return const Stack(
        children: [
          Opacity(
            opacity: 0.7,
            child: ModalBarrier(
              dismissible: false,
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

  Future<void> sinif() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sınıf Oluştur'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: ListBody(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Sınıf Adı Boş Olamaz!';
                        }
                        return null;
                      },
                      controller: sinifAdi,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Sınıf Adı',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              child: const Text(
                'Oluştur',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  olustur();
                }
              },
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              child: const Text(
                'İptal',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  olustur() async {
    final result = await Connectivity().checkConnectivity();
    final hasInternet = result.first;

    if (hasInternet == ConnectivityResult.none) {
      // ignore: use_build_context_synchronously
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const InternetYok(
              sayfaAdi: OgretmenAnaSayfa(),
            ),
          ),
          (route) => false);
    }
    setState(() {
      loading = true;
    });
    final rng = Random();
    var sayi1 = rng.nextInt(100000);

    var sayi2 = rng.nextInt(100000);

    if ("$sayi1$sayi2".length < 10) {
      sinifKodu = "$sayi1$sayi2" "5";
    } else {
      sinifKodu = "$sayi1$sayi2";
    }

    //ignore: use_build_context_synchronously
    try {
      FirebaseFirestore.instance
          .collection('siniflar')
          .where('sinifKodu', isEqualTo: sinifKodu)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          olustur();
          return;
        }

        //LİNK
        //TODO

        FirebaseFirestore.instance.collection('siniflar').doc(sinifKodu).set({
          'sinifLink': sinifLink,
          'sinifAdi': sinifAdi.text,
          'sinifKodu': sinifKodu.toString(),
          'sinifOgretmeni': MyApp.mail.text,
        });
        siniflar.clear();

        getData();

        // sınıf kodunu sıfırla
        sinifKodu = '0';

        Navigator.pop(context);
        setState(() {
          sinifAdi.text = '';
        });
      }).whenComplete(() {
        setState(() {
          loading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SinifAyrinti(
              sinif: ModelSinif(
                  sinifAdi: sinifAdi.text,
                  sinifLink: sinifLink,
                  sinifKodu: sinifKodu.toString(),
                  sinifOgretmeni: MyApp.mail.text),
            ),
          ),
        );
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      return e.toString();
    }
  }
}

/*
StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('siniflar')
            .where('sinifOgretmeni', isEqualTo: MyApp.mail.text)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Sınıfınız bulunmamaktadır.'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data?.docs[index]['sinifAdi']),
                subtitle: Text(snapshot.data?.docs[index]['sinifKodu']),
              );
            },
          );
        },
      ),*/
