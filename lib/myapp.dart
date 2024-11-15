import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:talebecetveli/login/kullanici_olustur.dart';

class MyApp extends StatelessWidget {
  static DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static bool ogrenci = false;
  static bool ogretmen = false;
  static TextEditingController mail = TextEditingController();
  static TextEditingController sifre = TextEditingController();
  static TextEditingController adSoyad = TextEditingController();
  static TextEditingController telefonNo = TextEditingController();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      title: 'Talebe Cetveli',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
      ],
      locale: const Locale('tr'),
      debugShowCheckedModeBanner: false,
      home: const KullaniciOlustur(),
    );
  }
}
