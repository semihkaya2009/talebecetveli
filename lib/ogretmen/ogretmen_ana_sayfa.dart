import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:talebecetveli/gorus_oneri_bildir.dart';
import 'package:talebecetveli/internet_yok.dart';
import 'package:talebecetveli/login/profil_tamamla.dart';
import 'package:talebecetveli/ogretmen/ogretmen_siniflar.dart';

class OgretmenAnaSayfa extends StatefulWidget {
  const OgretmenAnaSayfa({super.key});

  @override
  State<OgretmenAnaSayfa> createState() => _OgretmenAnaSayfaState();
}

class _OgretmenAnaSayfaState extends State<OgretmenAnaSayfa> {
  @override
  void initState() {
    super.initState();
  }

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
            backgroundColor: Colors.black,
          );

          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            myBody(),
          ],
        ),
        drawer: myDrawer(context),
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          backgroundColor: Colors.blue,
          title: const Text("Talebe Cetveli",
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  myBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
              child: Card(
                color: Colors.blue,
                elevation: 10,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    ListTile(
                      title: const Text('Gruplarımı Görüntüle',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      leading: const Icon(
                        Icons.event,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        final result = await Connectivity().checkConnectivity();
                        final hasInternet = result.first;

                        if (hasInternet == ConnectivityResult.none) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InternetYok(
                                  sayfaAdi: OgretmenAnaSayfa(),
                                ),
                              ),
                              (route) => false);
                          return;
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OgretmenSiniflar(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
              child: Card(
                color: Colors.blue,
                elevation: 10,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    ListTile(
                      title: const Text('Profil Düzenle',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      leading: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        final result = await Connectivity().checkConnectivity();
                        final hasInternet = result.first;

                        if (hasInternet == ConnectivityResult.none) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InternetYok(
                                  sayfaAdi: OgretmenAnaSayfa(),
                                ),
                              ),
                              (route) => false);
                          return;
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilTamamla(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 20.0,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GorusVeOneriBildir()),
              );
            },
            child: const Text(
              "Uygulamamızı geliştirebilmemiz için görüş ve önerilerinizi bizimle paylaşabilirsiniz.",
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        )
      ],
    );
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
                    title: const Text('Gruplarım'),
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
                                  sayfaAdi: OgretmenAnaSayfa()),
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
                            builder: (context) => const OgretmenSiniflar()),
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
                                sayfaAdi: OgretmenAnaSayfa(),
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
}
