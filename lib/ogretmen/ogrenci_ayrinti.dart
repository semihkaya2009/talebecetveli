import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:talebecetveli/internet_yok.dart';
import 'package:talebecetveli/model/model_aylar.dart';
import 'package:talebecetveli/model/model_ogrenci.dart';
import 'package:talebecetveli/model/model_takip.dart';
import 'package:talebecetveli/ogretmen/ogretmen_ana_sayfa.dart';

class OgrenciAyrinti extends StatefulWidget {
  final ModelOgrenci ogrenci;
  const OgrenciAyrinti({
    super.key,
    required this.ogrenci,
  });

  @override
  State<OgrenciAyrinti> createState() => _OgrenciAyrintiState();
}

class _OgrenciAyrintiState extends State<OgrenciAyrinti> {
  List<ModelTakip> gelenBilgiler = [];
  bool haftalik = true;
  bool aylik = false;
  bool yillik = false;
  List<ModelTakip> bilgiler = [];
  List<ModelAylar> aylar = [];
  DateTime bitis = DateFormat('yyyy-MM-dd')
      .parse(DateTime.now().subtract(const Duration(days: 7)).toString());
  DateTime baslangic =
      DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
  String secim = "Haftalık";
  var kuranToplam = 0;
  var kuranEzber = 0;
  var risaleOkuma = 0;
  var risaleEzber = 0;
  var osmanlicaYazi = 0;
  var cevsenOkuma = 0;
  var kitapOkuma = 0;
  var sabahNamaz = 0;
  var sabahNamazTesbihat = 0;
  var ogleNamaz = 0;
  var ogleNamazTesbihat = 0;
  var ikindiNamaz = 0;
  var ikindiNamazTesbihat = 0;
  var aksamNamaz = 0;
  var aksamNamazTesbihat = 0;
  var yatsiNamaz = 0;
  var yatsiNamazTesbihat = 0;
  bool kuranokumaetkin = true;
  bool kuranezberetkin = true;
  bool risaleokumaetkin = true;
  bool risaleezberetkin = true;
  bool osmanlicayazietkin = true;
  bool cevsenokumaetkin = true;
  bool kitapokumaetkin = true;
  bool tesbihatlar = true;
  List<DataColumn> toplamColumn = [
    const DataColumn(label: RotatedBox(quarterTurns: 1, child: Text("")))
  ];
  List<DataColumn> column = [
    const DataColumn(label: Text("Tarih")),
  ];
  List<DataCell> toplamRow = [const DataCell(Text("Toplam"))];
  List<DataRow> rows = [];
  bool isloading = true;

  @override
  void initState() {
    getData();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue,
        title: Text(widget.ogrenci.ogrenciAdi,
            style: const TextStyle(color: Colors.white)),
      ),
      body: getBody(),
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

  ortalamaSecim() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buton("Bir haftalık     ", Colors.blue, () {
          isloading = true;
          setState(() {});
          internetVarmi();
          isloading = true;
          baslangic = DateFormat('yyyy-MM-dd').parse(
              DateTime.now().subtract(const Duration(days: 7)).toString());

          bitis = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());

          haftalik = true;
          aylik = false;
          yillik = false;
          secim = "Haftalık";
          kuranToplam = 0;
          kuranEzber = 0;
          risaleOkuma = 0;
          risaleEzber = 0;
          osmanlicaYazi = 0;
          cevsenOkuma = 0;
          kitapOkuma = 0;
          sabahNamaz = 0;
          sabahNamazTesbihat = 0;
          ogleNamaz = 0;
          ogleNamazTesbihat = 0;
          ikindiNamaz = 0;
          ikindiNamazTesbihat = 0;
          aksamNamaz = 0;
          aksamNamazTesbihat = 0;
          yatsiNamaz = 0;
          yatsiNamazTesbihat = 0;
          bilgiler = [];
          gelenBilgiler = [];
          column = [
            const DataColumn(label: Text("Tarih")),
          ];
          toplamColumn = [
            const DataColumn(
                label: RotatedBox(quarterTurns: 1, child: Text("")))
          ];
          rows = [];
          toplamRow = [const DataCell(Text("Toplam"))];
          getData();
          setState(() {});
        }),
        const Text("     "),
        buton("Bir aylık     ", Colors.blue, () {
          isloading = true;
          setState(() {});
          internetVarmi();
          isloading = true;
          baslangic = DateFormat('yyyy-MM-dd').parse(
              DateTime.now().subtract(const Duration(days: 30)).toString());

          bitis = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());

          haftalik = false;
          aylik = true;
          yillik = false;
          secim = "Aylık";
          bilgiler = [];
          kuranToplam = 0;
          kuranEzber = 0;
          risaleOkuma = 0;
          risaleEzber = 0;
          osmanlicaYazi = 0;
          cevsenOkuma = 0;
          kitapOkuma = 0;
          sabahNamaz = 0;
          sabahNamazTesbihat = 0;
          ogleNamaz = 0;
          ogleNamazTesbihat = 0;
          ikindiNamaz = 0;
          ikindiNamazTesbihat = 0;
          aksamNamaz = 0;
          aksamNamazTesbihat = 0;
          yatsiNamaz = 0;
          yatsiNamazTesbihat = 0;
          gelenBilgiler = [];
          column = [
            const DataColumn(label: Text("Tarih")),
          ];
          toplamColumn = [
            const DataColumn(
                label: RotatedBox(quarterTurns: 1, child: Text("")))
          ];
          rows = [];
          toplamRow = [const DataCell(Text("Toplam"))];
          getData();
          setState(() {});
        }),
        const Text("     "),
        buton("Bir yıllık     ", Colors.blue, () {
          isloading = true;
          setState(() {});
          internetVarmi();
          isloading = true;
          baslangic = DateFormat('yyyy-MM-dd').parse(
              DateTime.now().subtract(const Duration(days: 365)).toString());

          bitis = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
          haftalik = false;
          aylik = false;
          yillik = true;
          secim = "Yıllık";
          bilgiler = [];
          kuranToplam = 0;
          kuranEzber = 0;
          risaleOkuma = 0;
          risaleEzber = 0;
          osmanlicaYazi = 0;
          cevsenOkuma = 0;
          kitapOkuma = 0;
          sabahNamaz = 0;
          sabahNamazTesbihat = 0;
          ogleNamaz = 0;
          ogleNamazTesbihat = 0;
          ikindiNamaz = 0;
          ikindiNamazTesbihat = 0;
          aksamNamaz = 0;
          aksamNamazTesbihat = 0;
          yatsiNamaz = 0;
          yatsiNamazTesbihat = 0;
          gelenBilgiler = [];
          column = [
            const DataColumn(label: Text("Tarih")),
          ];
          toplamColumn = [
            const DataColumn(
                label: RotatedBox(quarterTurns: 1, child: Text("")))
          ];
          rows = [];
          toplamRow = [const DataCell(Text("Toplam"))];
          getData();
          setState(() {});
        }),
      ],
    );
  }

  getBody() {
    return isloading
        ? isload()
        : SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ortalamaSecim(),
                  ],
                ),
                toplamDataTable(),
                // Çizgi
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  height: 1,
                  width: MediaQuery.of(context).size.width * 0.9,
                  color: Colors.black,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DataTable(
                          columnSpacing:
                              MediaQuery.of(context).size.width * 0.08,
                          headingRowHeight: 140,
                          columns: column,
                          rows: rows,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  toplamDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: MediaQuery.of(context).size.width * 0.08,
        headingRowHeight: 140,
        columns: toplamColumn,
        rows: [
          DataRow(
            cells: toplamRow,
          ),
        ],
      ),
    );
  }

  columnVeRowLariOlusturToplam() {
    setState(() {
      isloading = true;
    });
    FirebaseFirestore.instance
        .collection('arsiv')
        .where('mail', isEqualTo: widget.ogrenci.ogrenciID)
        .get()
        .then((valuee) {
      if (valuee.docs.isEmpty) {
        toplamColumn.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Kuran Okuma"))));
        toplamRow.add(DataCell(Text(kuranToplam.toString())));
        toplamColumn.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Kuran Ezber"))));
        toplamRow.add(DataCell(Text(kuranEzber.toString())));
        toplamColumn.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Risale Okuma"))));
        toplamRow.add(DataCell(Text(risaleOkuma.toString())));
        toplamColumn.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Vecize Ezber"))));
        toplamRow.add(DataCell(Text(risaleEzber.toString())));
        toplamColumn.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Cevşen Okuma"))));
        toplamRow.add(DataCell(Text(cevsenOkuma.toString())));

        toplamColumn.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Osmanlıca Yazı"))));
        toplamRow.add(DataCell(Text(osmanlicaYazi.toString())));
        toplamColumn.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Kitap Okuma"))));
        toplamRow.add(DataCell(Text(kitapOkuma.toString())));
        setState(() {});
        return;
      }
      kuranokumaetkin = valuee.docs[0]['kuranokuma'];
      kuranezberetkin = valuee.docs[0]['kuranezber'];
      risaleokumaetkin = valuee.docs[0]['risaleokuma'];
      risaleezberetkin = valuee.docs[0]['risaleezber'];
      cevsenokumaetkin = valuee.docs[0]['cevsenokuma'];
      kitapokumaetkin = valuee.docs[0]['kitapokuma'];
      osmanlicayazietkin = valuee.docs[0]['osmanlicayazi'];
      tesbihatlar = valuee.docs[0]['tesbihatlar'];
      setState(() {});
      olusturToplam();
    });
  }

  olusturToplam() {
    if (kuranokumaetkin) {
      toplamColumn.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Kuran Okuma"))));
      toplamRow.add(DataCell(Text(kuranToplam.toString())));
    }
    if (kuranezberetkin) {
      toplamColumn.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Kuran Ezber"))));
      toplamRow.add(DataCell(Text(kuranEzber.toString())));
    }
    if (risaleokumaetkin) {
      toplamColumn.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Risale Okuma"))));
      toplamRow.add(DataCell(Text(risaleOkuma.toString())));
    }
    if (risaleezberetkin) {
      toplamColumn.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Vecize Ezber"))));
      toplamRow.add(DataCell(Text(risaleEzber.toString())));
    }
    if (osmanlicayazietkin) {
      toplamColumn.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Osmanlıca Yazı"))));
      toplamRow.add(DataCell(Text(osmanlicaYazi.toString())));
    }
    if (cevsenokumaetkin) {
      toplamColumn.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Cevşen Okuma"))));
      toplamRow.add(DataCell(Text(cevsenOkuma.toString())));
    }
    if (kitapokumaetkin) {
      toplamColumn.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Kitap Okuma"))));
      toplamRow.add(DataCell(Text(kitapOkuma.toString())));
    }
    if (tesbihatlar) {
      toplamColumn.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Sabah Namazı"))));
      toplamRow.add(DataCell(Text(sabahNamaz.toString())));
      toplamColumn.add(const DataColumn(
          label:
              RotatedBox(quarterTurns: 1, child: Text("Sabah N. Tesbihatı"))));
      toplamRow.add(DataCell(Text(sabahNamazTesbihat.toString())));
      toplamColumn.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Öğle Namazı"))));
      toplamRow.add(DataCell(Text(ogleNamaz.toString())));
      toplamColumn.add(const DataColumn(
          label:
              RotatedBox(quarterTurns: 1, child: Text("Öğle N. Tesbihatı"))));
      toplamRow.add(DataCell(Text(ogleNamazTesbihat.toString())));

      toplamColumn.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("İkindi Namazı"))));
      toplamRow.add(DataCell(Text(ikindiNamaz.toString())));
      toplamColumn.add(const DataColumn(
          label:
              RotatedBox(quarterTurns: 1, child: Text("İkindi N. Tesbihatı"))));
      toplamRow.add(DataCell(Text(ikindiNamazTesbihat.toString())));

      toplamColumn.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Akşam Namazı"))));
      toplamRow.add(DataCell(Text(aksamNamaz.toString())));
      toplamColumn.add(const DataColumn(
          label:
              RotatedBox(quarterTurns: 1, child: Text("Akşam N. Tesbihatı"))));
      toplamRow.add(DataCell(Text(aksamNamazTesbihat.toString())));

      toplamColumn.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Yatsı Namazı"))));
      toplamRow.add(DataCell(Text(yatsiNamaz.toString())));
      toplamColumn.add(const DataColumn(
          label:
              RotatedBox(quarterTurns: 1, child: Text("Yatsı N. Tesbihatı"))));
      toplamRow.add(DataCell(Text(yatsiNamazTesbihat.toString())));
      setState(() {});
      return;
    }
    toplamColumn.add(const DataColumn(
        label: RotatedBox(quarterTurns: 1, child: Text("Sabah Namazı"))));
    toplamRow.add(DataCell(Text(sabahNamaz.toString())));
    toplamColumn.add(const DataColumn(
        label: RotatedBox(quarterTurns: 1, child: Text("Öğle Namazı"))));
    toplamRow.add(DataCell(Text(ogleNamaz.toString())));
    toplamColumn.add(const DataColumn(
        label: RotatedBox(quarterTurns: 1, child: Text("İkindi Namazı"))));
    toplamRow.add(DataCell(Text(ikindiNamaz.toString())));
    toplamColumn.add(const DataColumn(
        label: RotatedBox(quarterTurns: 1, child: Text("Akşam Namazı"))));
    toplamRow.add(DataCell(Text(aksamNamaz.toString())));
    toplamColumn.add(const DataColumn(
        label: RotatedBox(quarterTurns: 1, child: Text("Yatsı Namazı"))));
    toplamRow.add(DataCell(Text(yatsiNamaz.toString())));
  }

  columnVeRowlariOlustur() {
    setState(() {
      isloading = true;
    });
    FirebaseFirestore.instance
        .collection('arsiv')
        .where('mail', isEqualTo: widget.ogrenci.ogrenciID)
        .get()
        .then((valuee) {
      if (valuee.docs.isEmpty) {
        column.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Kuran Okuma"))));
        column.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Kuran Ezber"))));
        column.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Risale Okuma"))));
        column.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Vecize Ezber"))));
        column.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Osmanlıca Yazı"))));
        column.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Cevşen Okuma"))));
        column.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Kitap Okuma"))));
        column.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Sabah Namazı"))));
        column.add(const DataColumn(
            label: RotatedBox(
                quarterTurns: 1, child: Text("Sabah N. Tesbihatı"))));
        column.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Öğle Namazı"))));
        column.add(const DataColumn(
            label:
                RotatedBox(quarterTurns: 1, child: Text("Öğle N. Tesbihatı"))));
        column.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("İkindi Namazı"))));
        column.add(const DataColumn(
            label: RotatedBox(
                quarterTurns: 1, child: Text("İkindi N. Tesbihatı"))));
        column.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Akşam Namazı"))));
        column.add(const DataColumn(
            label: RotatedBox(
                quarterTurns: 1, child: Text("Akşam N. Tesbihatı"))));
        column.add(const DataColumn(
            label: RotatedBox(quarterTurns: 1, child: Text("Yatsı Namazı"))));
        column.add(const DataColumn(
            label: RotatedBox(
                quarterTurns: 1, child: Text("Yatsı N. Tesbihatı"))));
        for (var i = 0; i < gunBelirle(); i++) {
          rows.add(DataRow(cells: [
            DataCell(Text("${getTarihAyGun(bilgiler[i].tarih)}")),
            DataCell(Text(bilgiler[i].kuranOkuma.toString())),
            DataCell(Text(bilgiler[i].kuranEzber.toString())),
            DataCell(Text(bilgiler[i].risaleOkuma.toString())),
            DataCell(Text(bilgiler[i].risaleEzber.toString())),
            DataCell(Text(bilgiler[i].osmanlicaYazi.toString())),
            DataCell(Text(bilgiler[i].cevsenOkuma.toString())),
            DataCell(Text(bilgiler[i].kitapOkuma.toString())),
            DataCell(
              Icon(
                bilgiler[i].sabahNamazi ? Icons.check : Icons.close,
                size: 20,
                color: bilgiler[i].sabahNamazi ? Colors.green : Colors.red,
              ),
            ),
            DataCell(
              Icon(
                bilgiler[i].sabahNamaziTesbihat ? Icons.check : Icons.close,
                size: 20,
                color:
                    bilgiler[i].sabahNamaziTesbihat ? Colors.green : Colors.red,
              ),
            ),
            DataCell(
              Icon(
                bilgiler[i].ogleNamazi ? Icons.check : Icons.close,
                size: 20,
                color: bilgiler[i].ogleNamazi ? Colors.green : Colors.red,
              ),
            ),
            DataCell(
              Icon(
                bilgiler[i].ogleNamaziTesbihat ? Icons.check : Icons.close,
                size: 20,
                color:
                    bilgiler[i].ogleNamaziTesbihat ? Colors.green : Colors.red,
              ),
            ),
            DataCell(
              Icon(
                bilgiler[i].ikindiNamazi ? Icons.check : Icons.close,
                size: 20,
                color: bilgiler[i].ikindiNamazi ? Colors.green : Colors.red,
              ),
            ),
            DataCell(
              Icon(
                bilgiler[i].ikindiNamaziTesbihat ? Icons.check : Icons.close,
                size: 20,
                color: bilgiler[i].ikindiNamaziTesbihat
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            DataCell(
              Icon(
                bilgiler[i].aksamNamazi ? Icons.check : Icons.close,
                size: 20,
                color: bilgiler[i].aksamNamazi ? Colors.green : Colors.red,
              ),
            ),
            DataCell(
              Icon(
                bilgiler[i].aksamNamaziTesbihat ? Icons.check : Icons.close,
                size: 20,
                color:
                    bilgiler[i].aksamNamaziTesbihat ? Colors.green : Colors.red,
              ),
            ),
            DataCell(
              Icon(
                bilgiler[i].yatsiNamazi ? Icons.check : Icons.close,
                size: 20,
                color: bilgiler[i].yatsiNamazi ? Colors.green : Colors.red,
              ),
            ),
            DataCell(
              Icon(
                bilgiler[i].yatsiNamaziTesbihat ? Icons.check : Icons.close,
                size: 20,
                color:
                    bilgiler[i].yatsiNamaziTesbihat ? Colors.green : Colors.red,
              ),
            ),
          ]));
        }
        return;
      }
      kuranokumaetkin = valuee.docs[0]['kuranokuma'];
      kuranezberetkin = valuee.docs[0]['kuranezber'];
      risaleokumaetkin = valuee.docs[0]['risaleokuma'];
      risaleezberetkin = valuee.docs[0]['risaleezber'];
      cevsenokumaetkin = valuee.docs[0]['cevsenokuma'];
      kitapokumaetkin = valuee.docs[0]['kitapokuma'];
      osmanlicayazietkin = valuee.docs[0]['osmanlicayazi'];
      tesbihatlar = valuee.docs[0]['tesbihatlar'];
      setState(() {});
      olusturr();
    });
  }

  olusturr() {
    if (kuranokumaetkin) {
      column.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Kuran Okuma"))));
    }
    if (kuranezberetkin) {
      column.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Kuran Ezber"))));
    }
    if (risaleokumaetkin) {
      column.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Risale Okuma"))));
    }
    if (risaleezberetkin) {
      column.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Vecize Ezber"))));
    }
    if (osmanlicayazietkin) {
      column.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Osmanlıca Yazı"))));
    }
    if (cevsenokumaetkin) {
      column.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Cevşen Okuma"))));
    }
    if (kitapokumaetkin) {
      column.add(const DataColumn(
          label: RotatedBox(quarterTurns: 1, child: Text("Kitap Okuma"))));
    }
    column.add(const DataColumn(
        label: RotatedBox(quarterTurns: 1, child: Text("Sabah Namazı"))));
    if (tesbihatlar) {
      column.add(const DataColumn(
          label:
              RotatedBox(quarterTurns: 1, child: Text("Sabah N. Tesbihatı"))));
    }
    column.add(const DataColumn(
        label: RotatedBox(quarterTurns: 1, child: Text("Öğle Namazı"))));
    if (tesbihatlar) {
      column.add(const DataColumn(
          label:
              RotatedBox(quarterTurns: 1, child: Text("Öğle N. Tesbihatı"))));
    }
    column.add(const DataColumn(
        label: RotatedBox(quarterTurns: 1, child: Text("İkindi Namazı"))));
    if (tesbihatlar) {
      column.add(const DataColumn(
          label:
              RotatedBox(quarterTurns: 1, child: Text("İkindi N. Tesbihatı"))));
    }
    column.add(const DataColumn(
        label: RotatedBox(quarterTurns: 1, child: Text("Akşam Namazı"))));
    if (tesbihatlar) {
      column.add(const DataColumn(
          label:
              RotatedBox(quarterTurns: 1, child: Text("Akşam N. Tesbihatı"))));
    }
    column.add(const DataColumn(
        label: RotatedBox(quarterTurns: 1, child: Text("Yatsı Namazı"))));
    if (tesbihatlar) {
      column.add(const DataColumn(
          label:
              RotatedBox(quarterTurns: 1, child: Text("Yatsı N. Tesbihatı"))));
    }
    setState(() {});
    for (var i = 0; i < gunBelirle(); i++) {
      rows.add(DataRow(cells: [
        DataCell(Text("${getTarihAyGun(bilgiler[i].tarih)}")),
        if (kuranokumaetkin) DataCell(Text(bilgiler[i].kuranOkuma.toString())),
        if (kuranezberetkin) DataCell(Text(bilgiler[i].kuranEzber.toString())),
        if (risaleokumaetkin)
          DataCell(Text(bilgiler[i].risaleOkuma.toString())),
        if (risaleezberetkin)
          DataCell(Text(bilgiler[i].risaleEzber.toString())),
        if (osmanlicayazietkin)
          DataCell(Text(bilgiler[i].osmanlicaYazi.toString())),
        if (cevsenokumaetkin)
          DataCell(Text(bilgiler[i].cevsenOkuma.toString())),
        if (kitapokumaetkin) DataCell(Text(bilgiler[i].kitapOkuma.toString())),
        DataCell(
          Icon(
            bilgiler[i].sabahNamazi ? Icons.check : Icons.close,
            size: 20,
            color: bilgiler[i].sabahNamazi ? Colors.green : Colors.red,
          ),
        ),
        if (tesbihatlar)
          DataCell(
            Icon(
              bilgiler[i].sabahNamaziTesbihat ? Icons.check : Icons.close,
              size: 20,
              color:
                  bilgiler[i].sabahNamaziTesbihat ? Colors.green : Colors.red,
            ),
          ),
        DataCell(
          Icon(
            bilgiler[i].ogleNamazi ? Icons.check : Icons.close,
            size: 20,
            color: bilgiler[i].ogleNamazi ? Colors.green : Colors.red,
          ),
        ),
        if (tesbihatlar)
          DataCell(
            Icon(
              bilgiler[i].ogleNamaziTesbihat ? Icons.check : Icons.close,
              size: 20,
              color: bilgiler[i].ogleNamaziTesbihat ? Colors.green : Colors.red,
            ),
          ),
        DataCell(
          Icon(
            bilgiler[i].ikindiNamazi ? Icons.check : Icons.close,
            size: 20,
            color: bilgiler[i].ikindiNamazi ? Colors.green : Colors.red,
          ),
        ),
        if (tesbihatlar)
          DataCell(
            Icon(
              bilgiler[i].ikindiNamaziTesbihat ? Icons.check : Icons.close,
              size: 20,
              color:
                  bilgiler[i].ikindiNamaziTesbihat ? Colors.green : Colors.red,
            ),
          ),
        DataCell(
          Icon(
            bilgiler[i].aksamNamazi ? Icons.check : Icons.close,
            size: 20,
            color: bilgiler[i].aksamNamazi ? Colors.green : Colors.red,
          ),
        ),
        if (tesbihatlar)
          DataCell(
            Icon(
              bilgiler[i].aksamNamaziTesbihat ? Icons.check : Icons.close,
              size: 20,
              color:
                  bilgiler[i].aksamNamaziTesbihat ? Colors.green : Colors.red,
            ),
          ),
        DataCell(
          Icon(
            bilgiler[i].yatsiNamazi ? Icons.check : Icons.close,
            size: 20,
            color: bilgiler[i].yatsiNamazi ? Colors.green : Colors.red,
          ),
        ),
        if (tesbihatlar)
          DataCell(
            Icon(
              bilgiler[i].yatsiNamaziTesbihat ? Icons.check : Icons.close,
              size: 20,
              color:
                  bilgiler[i].yatsiNamaziTesbihat ? Colors.green : Colors.red,
            ),
          ),
      ]));
    }
  }

  getTarihAyGun(String tarih) {
    // var tarih1 = "${tarih.substring(8, 10)}.${tarih.substring(5, 7)}";
    // ignore: prefer_interpolation_to_compose_strings
    return "${tarih.substring(8, 10)} " + getAyString(tarih.substring(5, 7));
  }

  getTarihYilAyGun(int i) {
    var trh = DateTime.now().subtract(Duration(days: i));
    var tarih1 = "${trh.year}-${trh.month}-${trh.day}";
    if (tarih1.length == 8) {
      tarih1 = "${trh.year}-0${trh.month}-0${trh.day}";
    }
    if (tarih1.substring(5, 7) == "1-" ||
        tarih1.substring(5, 7) == "2-" ||
        tarih1.substring(5, 7) == "3-" ||
        tarih1.substring(5, 7) == "4-" ||
        tarih1.substring(5, 7) == "5-" ||
        tarih1.substring(5, 7) == "6-" ||
        tarih1.substring(5, 7) == "7-" ||
        tarih1.substring(5, 7) == "8-" ||
        tarih1.substring(5, 7) == "9-") {
      tarih1 = "${trh.year}-0${trh.month}-${trh.day}";
    }
    if (tarih1.length == 9) {
      tarih1 = "${trh.year}-${trh.month}-0${trh.day}";
    }
    // ignore: prefer_interpolation_to_compose_strings
    return tarih1;
  }

  getAyString(String ay) {
    switch (ay) {
      case "01":
        return "Ocak";
      case "02":
        return "Şubat";
      case "03":
        return "Mart";
      case "04":
        return "Nisan";
      case "05":
        return "Mayıs";
      case "06":
        return "Haziran";
      case "07":
        return "Temmuz";
      case "08":
        return "Ağustos";
      case "09":
        return "Eylül";
      case "10":
        return "Ekim";
      case "11":
        return "Kasım";
      case "12":
        return "Aralık";
      default:
        return "";
    }
  }

  getData() {
    if (secim == "Haftalık") {
      baslangic = DateFormat('yyyy-MM-dd')
          .parse(DateTime.now().subtract(const Duration(days: 7)).toString());
      bitis = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
    } else if (secim == "Aylık") {
      baslangic = DateFormat('yyyy-MM-dd')
          .parse(DateTime.now().subtract(const Duration(days: 30)).toString());
      bitis = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
    } else if (secim == "Yıllık") {
      baslangic = DateFormat('yyyy-MM-dd')
          .parse(DateTime.now().subtract(const Duration(days: 365)).toString());
      bitis = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
    }
    var baslangicTarihi = DateFormat('yyyy-MM-dd').format(baslangic);
    var bitisTarihi = DateFormat('yyyy-MM-dd').format(bitis);

    FirebaseFirestore.instance
        .collection('takip')
        .where('mail', isEqualTo: widget.ogrenci.ogrenciID)
        .where(
          'tarih',
          isGreaterThanOrEqualTo: baslangicTarihi,
        )
        .where('tarih', isLessThanOrEqualTo: bitisTarihi)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        for (var i = 0; i <= gunBelirle(); i++) {
          bilgiler.add(ModelTakip(
            tarih: getTarihYilAyGun(i),
            mail: widget.ogrenci.ogrenciID,
            sabahNamazi: false,
            sabahNamaziTesbihat: false,
            ogleNamazi: false,
            ogleNamaziTesbihat: false,
            ikindiNamazi: false,
            ikindiNamaziTesbihat: false,
            aksamNamazi: false,
            aksamNamaziTesbihat: false,
            yatsiNamazi: false,
            yatsiNamaziTesbihat: false,
            cevsenOkuma: "0",
            risaleOkuma: "0",
            risaleEzber: "0",
            kitapOkuma: "0",
            osmanlicaYazi: "0",
            kuranOkuma: "0",
            kuranEzber: "0",
          ));
        }
        toplamAl();
        setState(() {});
        columnVeRowLariOlusturToplam();
        columnVeRowlariOlustur();
        setState(() {});
        return;
      }

      for (var i = 0; i < value.docs.length; i++) {
        gelenBilgiler.add(ModelTakip(
          tarih: value.docs[i]['tarih'],
          mail: value.docs[i]['mail'],
          risaleOkuma: value.docs[i]['risaleOkuma'],
          risaleEzber: value.docs[i]['risaleEzber'],
          cevsenOkuma: value.docs[i]['cevsenOkuma'],
          kitapOkuma: value.docs[i]['kitapOkuma'],
          osmanlicaYazi: value.docs[i]['osmanlicaYazi'],
          sabahNamazi: value.docs[i]['sabahNamazi'],
          sabahNamaziTesbihat: value.docs[i]['sabahNamaziTesbihat'],
          ogleNamazi: value.docs[i]['ogleNamazi'],
          ogleNamaziTesbihat: value.docs[i]['ogleNamaziTesbihat'],
          ikindiNamazi: value.docs[i]['ikindiNamazi'],
          ikindiNamaziTesbihat: value.docs[i]['ikindiNamaziTesbihat'],
          aksamNamazi: value.docs[i]['aksamNamazi'],
          aksamNamaziTesbihat: value.docs[i]['aksamNamaziTesbihat'],
          yatsiNamazi: value.docs[i]['yatsiNamazi'],
          yatsiNamaziTesbihat: value.docs[i]['yatsiNamaziTesbihat'],
          kuranOkuma: value.docs[i]['kuranOkuma'],
          kuranEzber: value.docs[i]['kuranEzber'],
        ));
      }
      for (var i = 0; i <= gunBelirle(); i++) {
        bilgiler.add(ModelTakip(
          tarih: getTarihYilAyGun(i),
          mail: widget.ogrenci.ogrenciID,
          sabahNamazi: false,
          sabahNamaziTesbihat: false,
          ogleNamazi: false,
          ogleNamaziTesbihat: false,
          ikindiNamazi: false,
          ikindiNamaziTesbihat: false,
          aksamNamazi: false,
          aksamNamaziTesbihat: false,
          yatsiNamazi: false,
          yatsiNamaziTesbihat: false,
          cevsenOkuma: "0",
          risaleOkuma: "0",
          risaleEzber: "0",
          kitapOkuma: "0",
          osmanlicaYazi: "0",
          kuranOkuma: "0",
          kuranEzber: "0",
        ));
      }
      bilgileriBirlestir();
      toplamAl();
      columnVeRowLariOlusturToplam();
      columnVeRowlariOlustur();
      setState(() {});
    }).whenComplete(() {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isloading = false;
        });
      });
    });
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

  gunBelirle() {
    if (secim == "Haftalık") {
      return 7;
    }
    if (secim == "Aylık") {
      return 30;
    }
    if (secim == "Yıllık") {
      return 365;
    }
  }

  bilgileriBirlestir() {
    // bilgilerdeki tarihlerin gelenBilgilerdeki tarihlerle eşleşmesi
    for (var i = 0; i < bilgiler.length; i++) {
      for (var j = 0; j < gelenBilgiler.length; j++) {
        if (bilgiler[i].tarih == gelenBilgiler[j].tarih) {
          if (gelenBilgiler[j].kuranOkuma == "") {
            gelenBilgiler[j].kuranOkuma = "0";
          }
          if (gelenBilgiler[j].kuranEzber == "") {
            gelenBilgiler[j].kuranEzber = "0";
          }
          if (gelenBilgiler[j].risaleOkuma == "") {
            gelenBilgiler[j].risaleOkuma = "0";
          }
          if (gelenBilgiler[j].risaleEzber == "") {
            gelenBilgiler[j].risaleEzber = "0";
          }
          if (gelenBilgiler[j].cevsenOkuma == "") {
            gelenBilgiler[j].cevsenOkuma = "0";
          }
          if (gelenBilgiler[j].kitapOkuma == "") {
            gelenBilgiler[j].kitapOkuma = "0";
          }
          if (gelenBilgiler[j].osmanlicaYazi == "") {
            gelenBilgiler[j].osmanlicaYazi = "0";
          }
          bilgiler[i].sabahNamazi = gelenBilgiler[j].sabahNamazi;
          bilgiler[i].mail = gelenBilgiler[j].mail;
          bilgiler[i].tarih = gelenBilgiler[j].tarih;
          bilgiler[i].sabahNamaziTesbihat =
              gelenBilgiler[j].sabahNamaziTesbihat;
          bilgiler[i].ogleNamazi = gelenBilgiler[j].ogleNamazi;
          bilgiler[i].ogleNamaziTesbihat = gelenBilgiler[j].ogleNamaziTesbihat;
          bilgiler[i].ikindiNamazi = gelenBilgiler[j].ikindiNamazi;
          bilgiler[i].ikindiNamaziTesbihat =
              gelenBilgiler[j].ikindiNamaziTesbihat;
          bilgiler[i].aksamNamazi = gelenBilgiler[j].aksamNamazi;
          bilgiler[i].aksamNamaziTesbihat =
              gelenBilgiler[j].aksamNamaziTesbihat;
          bilgiler[i].yatsiNamazi = gelenBilgiler[j].yatsiNamazi;
          bilgiler[i].yatsiNamaziTesbihat =
              gelenBilgiler[j].yatsiNamaziTesbihat;
          bilgiler[i].kuranOkuma = gelenBilgiler[j].kuranOkuma;
          bilgiler[i].kuranEzber = gelenBilgiler[j].kuranEzber;
          bilgiler[i].risaleOkuma = gelenBilgiler[j].risaleOkuma;
          bilgiler[i].risaleEzber = gelenBilgiler[j].risaleEzber;
          bilgiler[i].cevsenOkuma = gelenBilgiler[j].cevsenOkuma;
          bilgiler[i].kitapOkuma = gelenBilgiler[j].kitapOkuma;
          bilgiler[i].osmanlicaYazi = gelenBilgiler[j].osmanlicaYazi;
        }
      }
    }
  }

  toplamAl() {
    for (var i = 0; i < bilgiler.length; i++) {
      var k = int.parse(bilgiler[i].kuranOkuma);
      var kEz = int.parse(bilgiler[i].kuranEzber);
      var r = int.parse(bilgiler[i].risaleOkuma);
      var rEz = int.parse(bilgiler[i].risaleEzber);
      var c = int.parse(bilgiler[i].cevsenOkuma);
      var kO = int.parse(bilgiler[i].kitapOkuma);
      var o = int.parse(bilgiler[i].osmanlicaYazi);
      if (bilgiler[i].sabahNamazi == true) {
        sabahNamaz++;
      }
      if (bilgiler[i].ogleNamazi == true) {
        ogleNamaz++;
      }
      if (bilgiler[i].ikindiNamazi == true) {
        ikindiNamaz++;
      }
      if (bilgiler[i].aksamNamazi == true) {
        aksamNamaz++;
      }
      if (bilgiler[i].yatsiNamazi == true) {
        yatsiNamaz++;
      }
      if (bilgiler[i].sabahNamaziTesbihat == true) {
        sabahNamazTesbihat++;
      }
      if (bilgiler[i].ogleNamaziTesbihat == true) {
        ogleNamazTesbihat++;
      }
      if (bilgiler[i].ikindiNamaziTesbihat == true) {
        ikindiNamazTesbihat++;
      }
      if (bilgiler[i].aksamNamaziTesbihat == true) {
        aksamNamazTesbihat++;
      }
      if (bilgiler[i].yatsiNamaziTesbihat == true) {
        yatsiNamazTesbihat++;
      }
      kuranToplam += k;
      kuranEzber += kEz;
      risaleOkuma += r;
      risaleEzber += rEz;
      cevsenOkuma += c;
      kitapOkuma += kO;
      osmanlicaYazi += o;
    }
  }
}