import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:talebecetveli/gorus_oneri_bildir.dart';
import 'package:talebecetveli/internet_yok.dart';
import 'package:talebecetveli/login/profil_tamamla.dart';
import 'package:talebecetveli/methods.dart';
import 'package:talebecetveli/ogrenci/ogrenci_katildigim_siniflar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talebecetveli/ogrenci/ogrenci_sonuclari.dart';
import 'package:talebecetveli/myapp.dart';

class OgrenciAnaSayfa extends StatefulWidget {
  const OgrenciAnaSayfa({super.key});

  @override
  State<OgrenciAnaSayfa> createState() => _OgrenciAnaSayfaState();
}

class _OgrenciAnaSayfaState extends State<OgrenciAnaSayfa> {
  bool sabahNamazi = false;
  bool ogleNamazi = false;
  bool ikindiNamazi = false;
  bool aksamNamazi = false;
  bool yatsiNamazi = false;
  bool sabahNamaziTesbihat = false;
  bool ogleNamaziTesbihat = false;
  bool ikindiNamaziTesbihat = false;
  bool aksamNamaziTesbihat = false;
  bool yatsiNamaziTesbihat = false;
  TextEditingController kuranokuma = TextEditingController();
  TextEditingController kuranezber = TextEditingController();
  TextEditingController risaleokuma = TextEditingController();
  TextEditingController risaleezber = TextEditingController();
  TextEditingController osmanlicayazi = TextEditingController();
  TextEditingController cevsenokuma = TextEditingController();
  TextEditingController kitapokuma = TextEditingController();
  bool kuranokumaetkin = true;
  bool kuranezberetkin = true;
  bool risaleokumaetkin = true;
  bool risaleezberetkin = true;
  bool osmanlicayazietkin = true;
  bool cevsenokumaetkin = true;
  bool kitapokumaetkin = true;
  bool tesbihatlar = true;
  bool isloading = true;
  DateTime timeBackPressed = DateTime.now();

  DateTime tarih = DateTime.now();

  @override
  void initState() {
    getData(context);
    super.initState();
  }

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
            backgroundColor: Colors.black,
          );

          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          drawer: myDrawer(context),
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            backgroundColor: Colors.blue,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text("Talebe Cetveli",
                style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                  onPressed: () {
                    arsivDialog();
                  },
                  icon: const Icon(Icons.archive)),
              IconButton(
                onPressed: () async {
                  final result = await Connectivity().checkConnectivity();
                  final hasInternet = result.first;

                  if (hasInternet == ConnectivityResult.none) {
                    // ignore: use_build_context_synchronously
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InternetYok(
                              sayfaAdi: OgrenciAnaSayfa(),
                            ),
                          ),
                          (route) => false);
                    }
                    return;
                  }

                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OgrenciSonuclari(),
                    ),
                  );
                },
                icon: const Icon(Icons.filter_list_rounded),
              ),
            ],
          ),
          body: Stack(
            children: [
              getBody(),
            ],
          ),
        ),
      ),
    );
  }

  geriBtn() {
    setState(() {
      tarih = tarih.add(const Duration(days: -1));
      getData(context);
    });
  }

  ileriBtn() {
    setState(() {
      tarih = tarih.add(const Duration(days: 1));
      getData(context);
    });
  }

  toDate() {
    return "${tarih.day}/${tarih.month}/${tarih.year}";
  }

  arsivDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gizlediğiniz öğeler'),
          content: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text(
                      'Buradan kullanmadığnız öğeleri gizleyebilirsiniz. Gizlediğiniz öğeler arşivde saklanır. Herhangi bir sınıfa girdiğinizde gizlediğiniz öğeler öğretmene gösterilmez.'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Kuran-ı Kerim okuma'),
                      Checkbox(
                          value: kuranokumaetkin,
                          onChanged: (value) {
                            setState(() {
                              kuranokumaetkin = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Kuran-ı Kerim ezber'),
                      Checkbox(
                          value: kuranezberetkin,
                          onChanged: (value) {
                            setState(() {
                              kuranezberetkin = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Risale-i Nur okuma'),
                      Checkbox(
                          value: risaleokumaetkin,
                          onChanged: (value) {
                            setState(() {
                              risaleokumaetkin = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Vecize ezber'),
                      Checkbox(
                          value: risaleezberetkin,
                          onChanged: (value) {
                            setState(() {
                              risaleezberetkin = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Osmanlıca yazı'),
                      Checkbox(
                          value: osmanlicayazietkin,
                          onChanged: (value) {
                            setState(() {
                              osmanlicayazietkin = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Cevşen okuma'),
                      Checkbox(
                          value: cevsenokumaetkin,
                          onChanged: (value) {
                            setState(() {
                              cevsenokumaetkin = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Kitap okuma'),
                      Checkbox(
                          value: kitapokumaetkin,
                          onChanged: (value) {
                            setState(() {
                              kitapokumaetkin = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Namaz Tesbihatları'),
                      Checkbox(
                          value: tesbihatlar,
                          onChanged: (value) {
                            setState(() {
                              tesbihatlar = value!;
                            });
                          }),
                    ],
                  ),
                ],
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('arsiv')
                    .doc(MyApp.mail.text)
                    .set({
                  'kuranokuma': kuranokumaetkin,
                  'kuranezber': kuranezberetkin,
                  'risaleokuma': risaleokumaetkin,
                  'risaleezber': risaleezberetkin,
                  'osmanlicayazi': osmanlicayazietkin,
                  'cevsenokuma': cevsenokumaetkin,
                  'kitapokuma': kitapokumaetkin,
                  'tesbihatlar': tesbihatlar,
                  'mail': MyApp.mail.text,
                }).then((value) {
                  setState(() {});
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  tarihKutusu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: buton2(Icons.arrow_back_ios, Colors.blue, geriBtn),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 5,
              right: 5,
            ),
            child: buton(toDate(), Colors.blue, () async {
              showDatePicker(
                locale: const Locale('tr'),
                context: context,
                initialDate: tarih,
                firstDate: DateTime(tarih.year - 1),
                lastDate: DateTime(tarih.year + 1),
              ).then((date) {
                setState(() {
                  tarih = date ?? tarih;
                  getData(context);
                });
              });
            }),
          ),
        ),
        Expanded(
          flex: 1,
          child: buton2(Icons.arrow_forward_ios, Colors.blue, ileriBtn),
        ),
      ],
    );
  }

  Widget buton(String text, Color color, onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color),
        ),
        child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 2, right: 2),
            child: Text(
              text,
              style: TextStyle(color: color),
              textAlign: TextAlign.center,
            )),
      ),
    );
  }

  Widget buton2(icon, Color color, onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white),
        ),
        child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 2, right: 2),
            child: Icon(icon, color: Colors.white)),
      ),
    );
  }

  sabahnamazKutusu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: sabahNamazi,
              onChanged: (value) {
                if (sabahNamaziTesbihat) {
                  setState(() {
                    sabahNamazi = !sabahNamazi;
                    sabahNamaziTesbihat = false;
                  });
                } else {
                  setState(() {
                    sabahNamazi = !sabahNamazi;
                  });
                }
              },
            ),
            const Text("Sabah Namazı"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (tesbihatlar)
              Checkbox(
                value: sabahNamaziTesbihat,
                onChanged: (value) {
                  //namaz true değilse tesbihatı seçemez
                  if (sabahNamaziTesbihat) {
                    setState(() {
                      sabahNamaziTesbihat = false;
                    });
                  } else if (sabahNamazi) {
                    setState(() {
                      sabahNamaziTesbihat = value!;
                    });
                  } else {
                    mySnackBar("Namaz kılmadan tesbihat seçemezsiniz",
                        Colors.red, context);
                  }
                },
              ),
            if (tesbihatlar) const Text("Sabah Namazı Tesbihat"),
          ],
        )
      ],
    );
  }

  ogleNamazKutusu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: ogleNamazi,
              onChanged: (value) {
                if (ogleNamaziTesbihat) {
                  setState(() {
                    ogleNamazi = !ogleNamazi;
                    ogleNamaziTesbihat = false;
                  });
                } else {
                  setState(() {
                    ogleNamazi = !ogleNamazi;
                  });
                }
              },
            ),
            const Text("Öğle Namazı"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (tesbihatlar)
              Checkbox(
                value: ogleNamaziTesbihat,
                onChanged: (value) {
                  //namaz true değilse tesbihatı seçemez
                  if (ogleNamaziTesbihat) {
                    setState(() {
                      ogleNamaziTesbihat = !ogleNamaziTesbihat;
                    });
                  } else if (ogleNamazi) {
                    setState(() {
                      ogleNamaziTesbihat = value!;
                    });
                  } else {
                    mySnackBar("Namaz kılmadan tesbihat seçemezsiniz",
                        Colors.red, context);
                  }
                },
              ),
            if (tesbihatlar) const Text("Öğle Namazı Tesbihat"),
          ],
        )
      ],
    );
  }

  ikindiNamazKutusu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: ikindiNamazi,
              onChanged: (value) {
                if (ikindiNamaziTesbihat) {
                  setState(() {
                    ikindiNamazi = !ikindiNamazi;
                    ikindiNamaziTesbihat = false;
                  });
                } else {
                  setState(() {
                    ikindiNamazi = !ikindiNamazi;
                  });
                }
              },
            ),
            const Text("İkindi Namazı"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (tesbihatlar)
              Checkbox(
                value: ikindiNamaziTesbihat,
                onChanged: (value) {
                  if (ikindiNamaziTesbihat) {
                    setState(() {
                      ikindiNamaziTesbihat = !ikindiNamaziTesbihat;
                    });
                  } else if (ikindiNamazi) {
                    setState(() {
                      ikindiNamaziTesbihat = value!;
                    });
                  } else {
                    mySnackBar("Namaz kılmadan tesbihat seçemezsiniz",
                        Colors.red, context);
                  }
                },
              ),
            if (tesbihatlar) const Text("İkindi Namazı Tesbihat"),
          ],
        )
      ],
    );
  }

  aksamNamazKutusu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: aksamNamazi,
              onChanged: (value) {
                if (aksamNamaziTesbihat) {
                  setState(() {
                    aksamNamazi = !aksamNamazi;
                    aksamNamaziTesbihat = false;
                  });
                } else {
                  setState(() {
                    aksamNamazi = !aksamNamazi;
                  });
                }
              },
            ),
            const Text("Akşam Namazı"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (tesbihatlar)
              Checkbox(
                value: aksamNamaziTesbihat,
                onChanged: (value) {
                  if (aksamNamaziTesbihat) {
                    setState(() {
                      aksamNamaziTesbihat = !aksamNamaziTesbihat;
                    });
                  } else if (aksamNamazi) {
                    setState(() {
                      aksamNamaziTesbihat = value!;
                    });
                  } else {
                    mySnackBar("Namaz kılmadan tesbihat seçemezsiniz",
                        Colors.red, context);
                  }
                },
              ),
            if (tesbihatlar) const Text("Akşam Namazı Tesbihat"),
          ],
        )
      ],
    );
  }

  yatsiNamazKutusu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: yatsiNamazi,
              onChanged: (value) {
                if (yatsiNamaziTesbihat) {
                  setState(() {
                    yatsiNamazi = !yatsiNamazi;
                    yatsiNamaziTesbihat = false;
                  });
                } else {
                  setState(() {
                    yatsiNamazi = !yatsiNamazi;
                  });
                }
              },
            ),
            const Text("Yatsı Namazı"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (tesbihatlar)
              Checkbox(
                value: yatsiNamaziTesbihat,
                onChanged: (value) {
                  if (yatsiNamaziTesbihat) {
                    setState(() {
                      yatsiNamaziTesbihat = !yatsiNamaziTesbihat;
                    });
                  } else if (yatsiNamazi) {
                    setState(() {
                      yatsiNamaziTesbihat = value!;
                    });
                  } else {
                    mySnackBar("Namaz kılmadan tesbihat seçemezsiniz",
                        Colors.red, context);
                  }
                },
              ),
            if (tesbihatlar) const Text("Yatsı Namazı Tesbihat"),
          ],
        )
      ],
    );
  }

  isload() {
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

  getBody() {
    return isloading
        ? isload()
        : LayoutBuilder(
            builder: ((context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        tarihKutusu(),
                        kuranOkuma(),
                        kuranEzber(),
                        risaleOkuma(),
                        risaleEzber(),
                        osmanlicaYazi(),
                        cevsenOkuma(),
                        kitapOkuma(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              sabahnamazKutusu(),
                              ogleNamazKutusu(),
                              ikindiNamazKutusu(),
                              aksamNamazKutusu(),
                              yatsiNamazKutusu(),
                            ],
                          ),
                        ),
                        kaydetButonu(),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GorusVeOneriBildir()),
                            );
                          },
                          child: const Text(
                            "Uygulamamızı geliştirebilmemiz için görüş ve önerilerinizi bizimle paylaşabilirsiniz.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
  }

  getData(context) async {
    //internetin olup olmadığına bak

    final result = await Connectivity().checkConnectivity();
    final hasInternet = result.first;

    if (hasInternet == ConnectivityResult.none) {
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const InternetYok(
              sayfaAdi: OgrenciAnaSayfa(),
            ),
          ),
          (route) => false);
    }

    DateTime date = DateTime.parse(tarih.toString());
    var date2 = DateFormat('yyyy-MM-dd').format(date);

    try {
      await FirebaseFirestore.instance
          .collection('takip')
          .where('mail', isEqualTo: MyApp.mail.text)
          .where('tarih', isEqualTo: date2)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                if (querySnapshot.docs.isNotEmpty)
                  {
                    querySnapshot.docs
                        // ignore: avoid_function_literals_in_foreach_calls
                        .forEach((documentSnapshot) {
                      risaleokuma.text = documentSnapshot['risaleOkuma'];
                      risaleezber.text = documentSnapshot['risaleEzber'];
                      kuranokuma.text = documentSnapshot['kuranOkuma'];
                      kuranezber.text = documentSnapshot['kuranEzber'];
                      cevsenokuma.text = documentSnapshot['cevsenOkuma'];
                      kitapokuma.text = documentSnapshot['kitapOkuma'];
                      osmanlicayazi.text = documentSnapshot['osmanlicaYazi'];
                      sabahNamazi = documentSnapshot['sabahNamazi'];
                      sabahNamaziTesbihat =
                          documentSnapshot['sabahNamaziTesbihat'];
                      ogleNamazi = documentSnapshot['ogleNamazi'];
                      ogleNamaziTesbihat =
                          documentSnapshot['ogleNamaziTesbihat'];
                      ikindiNamazi = documentSnapshot['ikindiNamazi'];
                      ikindiNamaziTesbihat =
                          documentSnapshot['ikindiNamaziTesbihat'];
                      aksamNamazi = documentSnapshot['aksamNamazi'];
                      aksamNamaziTesbihat =
                          documentSnapshot['aksamNamaziTesbihat'];
                      yatsiNamazi = documentSnapshot['yatsiNamazi'];
                      yatsiNamaziTesbihat =
                          documentSnapshot['yatsiNamaziTesbihat'];
                    })
                  }
                else
                  {
                    setState(() {
                      kuranokuma.text = "";
                      kuranezber.text = "";
                      risaleokuma.text = "";
                      risaleezber.text = "";
                      cevsenokuma.text = "";
                      kitapokuma.text = "";
                      osmanlicayazi.text = "";
                      sabahNamazi = false;
                      sabahNamaziTesbihat = false;
                      ogleNamazi = false;
                      ogleNamaziTesbihat = false;
                      ikindiNamazi = false;
                      ikindiNamaziTesbihat = false;
                      aksamNamazi = false;
                      aksamNamaziTesbihat = false;
                      yatsiNamazi = false;
                      yatsiNamaziTesbihat = false;
                    })
                  }
              })
          .then((value) {
        // frebasedeki arsiv collectionuna git maili kontrol et
        FirebaseFirestore.instance
            .collection('arsiv')
            .where('mail', isEqualTo: MyApp.mail.text)
            .get()
            .then((value) {
          if (value.docs.isEmpty) {
            return;
          }
          kuranokumaetkin = value.docs[0]['kuranokuma'];
          kuranezberetkin = value.docs[0]['kuranezber'];
          risaleokumaetkin = value.docs[0]['risaleokuma'];
          risaleezberetkin = value.docs[0]['risaleezber'];
          cevsenokumaetkin = value.docs[0]['cevsenokuma'];
          kitapokumaetkin = value.docs[0]['kitapokuma'];
          osmanlicayazietkin = value.docs[0]['osmanlicayazi'];
          tesbihatlar = value.docs[0]['tesbihatlar'];
        }).then((value) {
          setState(() {
            isloading = false;
          });
        });
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    setState(() {
      isloading = false;
    });
  }

  kaydetButonu() {
    return buton("Kaydet         ", Colors.green, () async {
      setState(() {
        isloading = true;
      });

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

      if (kuranokuma.text.isEmpty) {
        kuranokuma.text = "0";
      }
      if (kuranezber.text.isEmpty) {
        kuranezber.text = "0";
      }
      if (risaleokuma.text.isEmpty) {
        risaleokuma.text = "0";
      }
      if (risaleezber.text.isEmpty) {
        risaleezber.text = "0";
      }
      if (cevsenokuma.text.isEmpty) {
        cevsenokuma.text = "0";
      }
      if (kitapokuma.text.isEmpty) {
        kitapokuma.text = "0";
      }
      if (osmanlicayazi.text.isEmpty) {
        osmanlicayazi.text = "0";
      }
      //firebasede veri varsa güncellesin
      //yoksa eklesin

      DateTime date = DateTime.parse(tarih.toString());
      var date2 = DateFormat('yyyy-MM-dd').format(date);

      FirebaseFirestore.instance
          .collection('takip')
          .where('mail', isEqualTo: MyApp.mail.text)
          .where('tarih', isEqualTo: date2)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          FirebaseFirestore.instance
              .collection('takip')
              .doc(value.docs[0].id)
              .update({
            'risaleOkuma': risaleokuma.text,
            'risaleEzber': risaleezber.text,
            'osmanlicaYazi': osmanlicayazi.text,
            'cevsenOkuma': cevsenokuma.text,
            'kitapOkuma': kitapokuma.text,
            'kuranOkuma': kuranokuma.text,
            'kuranEzber': kuranezber.text,
            'sabahNamazi': sabahNamazi,
            'sabahNamaziTesbihat': sabahNamaziTesbihat,
            'ogleNamazi': ogleNamazi,
            'ogleNamaziTesbihat': ogleNamaziTesbihat,
            'ikindiNamazi': ikindiNamazi,
            'ikindiNamaziTesbihat': ikindiNamaziTesbihat,
            'aksamNamazi': aksamNamazi,
            'aksamNamaziTesbihat': aksamNamaziTesbihat,
            'yatsiNamazi': yatsiNamazi,
            'yatsiNamaziTesbihat': yatsiNamaziTesbihat,
          });
        } else {
          FirebaseFirestore.instance.collection('takip').add({
            'mail': MyApp.mail.text,
            'tarih': date2,
            'kuranOkuma': kuranokuma.text,
            'kuranEzber': kuranezber.text,
            'risaleOkuma': risaleokuma.text,
            'risaleEzber': risaleezber.text,
            'osmanlicaYazi': osmanlicayazi.text,
            'cevsenOkuma': cevsenokuma.text,
            'kitapOkuma': kitapokuma.text,
            'sabahNamazi': sabahNamazi,
            'sabahNamaziTesbihat': sabahNamaziTesbihat,
            'ogleNamazi': ogleNamazi,
            'ogleNamaziTesbihat': ogleNamaziTesbihat,
            'ikindiNamazi': ikindiNamazi,
            'ikindiNamaziTesbihat': ikindiNamaziTesbihat,
            'aksamNamazi': aksamNamazi,
            'aksamNamaziTesbihat': aksamNamaziTesbihat,
            'yatsiNamazi': yatsiNamazi,
            'yatsiNamaziTesbihat': yatsiNamaziTesbihat,
          });
        }
      });

      setState(() {
        isloading = false;
      });

      // ignore: use_build_context_synchronously
      mySnackBar("Başarıyla Kaydedildi", Colors.green, context);
    });
  }

  myDrawer(BuildContext context) {
    return Drawer(
      child: Stack(
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
          Column(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Center(
                    child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage("assets/icon/icon.png"),
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: ListTile(
                    iconColor: Colors.blue,
                    leading: const Icon(Icons.home),
                    title: const Text('Ana Sayfa'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: ListTile(
                    iconColor: Colors.blue,
                    leading: const Icon(Icons.group),
                    title: const Text('Katıldığım Gruplar'),
                    onTap: () async {
                      final result = await Connectivity().checkConnectivity();
                      // ignore: unrelated_type_equality_checks
                      final hasInternet = result != ConnectivityResult.none;
                      if (hasInternet == false) {
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
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const OgrenciKatildigimSiniflar(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: ListTile(
                    iconColor: Colors.blue,
                    leading: const Icon(Icons.person),
                    title: const Text('Profil Düzenle'),
                    onTap: () async {
                      final result = await Connectivity().checkConnectivity();
                      // ignore: unrelated_type_equality_checks
                      final hasInternet = result != ConnectivityResult.none;
                      if (hasInternet == false) {
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
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ProfilTamamla();
                      }));
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  kuranOkuma() {
    if (kuranokumaetkin) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            labelText: "Bugün kaç sayfa Kur'an-ı Kerim okudunuz?",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          controller: kuranokuma,
        ),
      );
    }
    return const SizedBox();
  }

  kuranEzber() {
    if (kuranezberetkin) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            labelText: "Bugün kaç âyet Kur'an-ı Kerim ezberlediniz?",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          controller: kuranezber,
        ),
      );
    }
    return const SizedBox();
  }

  risaleOkuma() {
    if (risaleokumaetkin) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            labelText: "Bugün kaç sayfa Risale-i Nur okudunuz?",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          controller: risaleokuma,
        ),
      );
    }
    return const SizedBox();
  }

  risaleEzber() {
    if (risaleezberetkin) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            labelText: "Bugün kaç adet vecize ezberlediniz?",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          controller: risaleezber,
        ),
      );
    }
    return const SizedBox();
  }

  osmanlicaYazi() {
    if (osmanlicayazietkin) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            labelText: "Bugün kaç satır Osmanlıca yazı yazdınız?",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          controller: osmanlicayazi,
        ),
      );
    }
    return const SizedBox();
  }

  cevsenOkuma() {
    if (cevsenokumaetkin) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            labelText: "Bugün kaç bab Cevşen-ül Kebir okudunuz?",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          controller: cevsenokuma,
        ),
      );
    }
    return const SizedBox();
  }

  kitapOkuma() {
    if (kitapokumaetkin) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            labelText: "Bugün kaç sayfa kitap okudunuz?",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          controller: kitapokuma,
        ),
      );
    }
    return const SizedBox();
  }
}
