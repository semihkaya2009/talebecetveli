import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:talebecetveli/internet_yok.dart';
import 'package:talebecetveli/model/model_sinif.dart';
import 'package:talebecetveli/ogrenci/ogrenci_ana_sayfa.dart';
import 'package:talebecetveli/myapp.dart';

class OgrenciKatildigimSiniflar extends StatefulWidget {
  const OgrenciKatildigimSiniflar({super.key});

  @override
  State<OgrenciKatildigimSiniflar> createState() =>
      _OgrenciKatildigimSiniflarState();
}

class _OgrenciKatildigimSiniflarState extends State<OgrenciKatildigimSiniflar> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  bool bosMu = true;
  bool loading = true;
  List<ModelSinif> siniflar = [];
  TextEditingController kod = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          'Katıldığım Gruplar',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
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

  getBody() {
    if (siniflar.isEmpty) {
      return const Center(
        child: Text(
          'Katıldığınız grup bulunmamaktadır.',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
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
                    sinifdanCik(siniflar[index]);
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  )),
              title: Text(siniflar[index].sinifAdi),
              subtitle: Text(siniflar[index].sinifOgretmeni),
            ),
          ),
        );
      },
    );
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection('sinifOgrenciler')
        .where('ogrenciID', isEqualTo: MyApp.mail.text)
        .get()
        .then((value) {
      //gelen id'nin içindeki verileri alıyoruz
      for (var i = 0; i < value.docs.length; i++) {
        var sinifKodu = value.docs[i]['sinifKodu'];

        FirebaseFirestore.instance
            .collection('siniflar')
            .where('sinifKodu', isEqualTo: sinifKodu.toString())
            .get()
            .then((value2) {
          for (var a = 0; a < value2.docs.length; a++) {
            var data = value2.docs[a].data();
            setState(() {
              siniflar.add(ModelSinif(
                  sinifLink: data['sinifLink'],
                  sinifAdi: data['sinifAdi'],
                  sinifKodu: data['sinifKodu'],
                  sinifOgretmeni: data['sinifOgretmeni']));
            });
          }
        });
      }
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sınıfa Katıl'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: ListBody(
                children: <Widget>[
                  const Text(
                      'Katılmak istediğiniz sınıfın 10 haneli kodunu buraya yazarak katılabilirsiniz.'),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 10) {
                          return 'Sınıf kodu 10 haneli olmalıdır!';
                        }
                        return null;
                      },
                      controller: kod,
                      decoration: InputDecoration(
                        labelText: 'Sınıf Kodu',
                        border: const OutlineInputBorder(),
                        fillColor: Colors.grey[300],
                        filled: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              child: const Text(
                'Katıl',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                final result = await Connectivity().checkConnectivity();
                final hasInternet = result.first;

                if (hasInternet == ConnectivityResult.none) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InternetYok(
                          sayfaAdi: OgrenciAnaSayfa(),
                        ),
                      ),
                      (route) => false);
                  return;
                }
                katil();
              },
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              child: const Text(
                'İptal',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  katil() {
    setState(() {
      loading = true;
    });
    if (formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection('siniflar')
          .doc(kod.text)
          .get()
          .then((DocumentSnapshot value) {
        if (value.exists) {
          FirebaseFirestore.instance
              .collection('sinifOgrenciler')
              .where('ogrenciID', isEqualTo: MyApp.mail.text)
              .where('sinifKodu', isEqualTo: kod.text)
              .get()
              .then((QuerySnapshot val) {
            if (val.docs.isEmpty) {
              FirebaseFirestore.instance.collection('sinifOgrenciler').add({
                'ogrenciID': MyApp.mail.text,
                'sinifKodu': kod.text,
                'ogrenciAd': MyApp.adSoyad.text,
                'ogrenciTelNo': MyApp.telefonNo.text,
              });
              siniflar.clear();
              getData();
              kod.clear();
              sinifaKatil(value);
              setState(() {
                loading = false;
              });
              return;
            }
            sinifaKayitli(value);
            kod.clear();
            setState(() {
              loading = false;
            });
            return;
          });
        }
        if (!value.exists) {
          hataliSinif();
          kod.clear();
        }
      });
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> sinifaKatil(value) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sınıfa Katıldı'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text("Sınıf Bilgileri"),
                const Text(""),
                Text(
                  'Sınıf adı: ${value.data()?['sinifAdi'] ?? ""}',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Sınıf kodu: ${value.data()?['sinifKodu'] ?? ""}',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Öğretmen maili: ${value.data()?['sinifOgretmeni'] ?? ""}',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              child: const Text(
                'Tamam',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> hataliSinif() {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sınıfa Katılırken Hata Oluştu'),
          content: const Text(
            'Sınıf kodunuz hatalı veya böyle bir kod bulunamadı.',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              child: const Text(
                'Tamam',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> sinifaKayitli(value) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sınıfa Zaten Kayıtlısınız'),
          content: Text(
            '${value?['sinifAdi']} adlı sınıfa zaten kayıtlısınız.',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              child: const Text(
                'Tamam',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  sinifdanCik(ModelSinif sinif) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sınıfdan Çık'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: ListBody(
                children: <Widget>[
                  Text(
                    "${sinif.sinifAdi} adlı sınıfdan çıkılacak. Emin misiniz? Bu işlemi geri alamazsınız.",
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
              ),
              child: const Text(
                'Çıkış Yap',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                final result = await Connectivity().checkConnectivity();
                final hasInternet = result.first;

                if (hasInternet == ConnectivityResult.none) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InternetYok(
                          sayfaAdi: OgrenciAnaSayfa(),
                        ),
                      ),
                      (route) => false);
                  return;
                }
                cikis(sinif);
              },
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              child: const Text(
                'İptal',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  cikis(ModelSinif sinif) {
    FirebaseFirestore.instance
        .collection('sinifOgrenciler')
        .where('ogrenciID', isEqualTo: MyApp.mail.text)
        .where('sinifKodu', isEqualTo: sinif.sinifKodu)
        .get()
        .then((value) {
      for (var element in value.docs) {
        FirebaseFirestore.instance
            .collection('sinifOgrenciler')
            .doc(element.id)
            .delete();
      }
    });
    setState(() {
      siniflar.remove(sinif);
    });

    Navigator.pop(context);
  }
}
