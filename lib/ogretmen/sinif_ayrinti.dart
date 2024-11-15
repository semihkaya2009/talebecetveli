import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

// import 'package:share_plus/share_plus.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:intl/intl.dart';
import 'package:talebecetveli/internet_yok.dart';
import 'package:talebecetveli/model/model_ogrenci.dart';
import 'package:talebecetveli/model/model_sinif.dart';
// import 'package:talebecetveli/model/model_takip.dart';
// import 'package:talebecetveli/ogretmen/odevleri_goruntule.dart';
import 'package:talebecetveli/ogretmen/ogrenci_ayrinti.dart';
import 'package:talebecetveli/ogretmen/ogretmen_ana_sayfa.dart';

class SinifAyrinti extends StatefulWidget {
  final ModelSinif sinif;

  const SinifAyrinti({super.key, required this.sinif});

  @override
  State<SinifAyrinti> createState() => _SinifAyrintiState();
}

class _SinifAyrintiState extends State<SinifAyrinti> {
  // final formKey = GlobalKey<FormState>();
  // TextEditingController ogrenciMail = TextEditingController();
  List<ModelOgrenci> ogrenciler = [];

  bool loading = true;
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => const OdevleriGoruntule()));
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Row(
        //         children: const [
        //           Text("Ödevleri Göster "),
        //           Icon(Icons.library_books_rounded)
        //         ],
        //       ),
        //     ),
        //   ),
        // ],
        title: Text(widget.sinif.sinifAdi,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
    );
  }

  // Future<void> ogrenciEkleDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Öğrenci Ekle'),
  //         content: Form(
  //           key: formKey,
  //           child: ListBody(
  //             children: <Widget>[
  //               const Text(
  //                   'Eklemek istediğiniz öğrencinin mail adresini giriniz.'),
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 8.0),
  //                 child: TextFormField(
  //                   keyboardType: TextInputType.number,
  //                   validator: (value) {
  //                     final bool gecerliMi =
  //                         EmailValidator.validate(value ?? "");
  //                     if (value == null || value.isEmpty) {
  //                       return "Mail Adresi Boş Olamaz";
  //                     } else if (!gecerliMi) {
  //                       "Mail Adresi Geçersiz";
  //                     }
  //                     return null;
  //                   },
  //                   controller: ogrenciMail,
  //                   decoration: InputDecoration(
  //                     labelText: 'Mail',
  //                     border: const OutlineInputBorder(),
  //                     fillColor: Colors.grey[300],
  //                     filled: true,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             style: ButtonStyle(
  //               backgroundColor: MaterialStateProperty.all(Colors.blue),
  //             ),
  //             child: const Text(
  //               'Katıl',
  //               style: TextStyle(
  //                 color: Colors.white,
  //               ),
  //             ),
  //             onPressed: () {
  //               katil();
  //             },
  //           ),
  //           TextButton(
  //             style: ButtonStyle(
  //               backgroundColor: MaterialStateProperty.all(Colors.blue),
  //             ),
  //             child: const Text(
  //               'İptal',
  //               style: TextStyle(
  //                 color: Colors.white,
  //               ),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

//LİNK PAYLAS
//TODO

  katil() {}

  getBody() {
    if (loading) {
      return const Center(
        child: Text("Veriler Getiriliyor..."),
      );
    }
    if (ogrenciler.isEmpty) {
      return const Center(
        child: Text("Öğrenciniz bulunmamaktadır.",
            style: TextStyle(fontSize: 25, color: Colors.white)),
      );
    }
    return ListView.builder(
      itemCount: ogrenciler.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            child: ListTile(
              trailing: IconButton(
                  onPressed: () {
                    ogrenciAyrinti(
                      ogrenciler[index],
                    );
                  },
                  icon: const Icon(Icons.info)),
              onTap: () {
                internetVarmi();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OgrenciAyrinti(
                              ogrenci: ogrenciler[index],
                            )));
              },
              title: Text(ogrenciler[index].ogrenciAdi),
              subtitle: Text(ogrenciler[index].ogrenciID),
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

  ogrenciAyrinti(ModelOgrenci ogrenci) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Öğrencinin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText('Adı: ${ogrenci.ogrenciAdi}'),
              SelectableText('Telefon Numarası: ${ogrenci.ogrenciTelNo}'),
              SelectableText('Maili: ${ogrenci.ogrenciID}'),
            ],
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              child: const Text(
                'Tamam',
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

  isload() {
    if (loading) {
      return const Stack(
        children: [
          Opacity(
              opacity: 0.7,
              child: ModalBarrier(dismissible: false, color: Colors.grey)),
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

  getData() {
    internetVarmi();

    FirebaseFirestore.instance
        .collection('sinifOgrenciler')
        .where('sinifKodu', isEqualTo: widget.sinif.sinifKodu)
        .get()
        .then((value) {
      try {
        for (var i = 0; i < value.docs.length; i++) {
          var data = value.docs[i].data();
          setState(() {
            ModelOgrenci o1 = ModelOgrenci();
            o1.ogrenciAdi = data['ogrenciAd'];
            o1.ogrenciID = data['ogrenciID'];
            o1.ogrenciTelNo = data['ogrenciTelNo'];

            ogrenciler.add(o1);
          });
        }
      } catch (e) {
        e.toString();
      }
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
}
