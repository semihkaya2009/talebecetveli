class ModelTakip {
  String tarih;
  String mail;
  String kuranOkuma;
  String risaleOkuma;
  String risaleEzber;
  String osmanlicaYazi;
  String cevsenOkuma;
  String kitapOkuma;
  String kuranEzber;
  bool sabahNamazi;
  bool sabahNamaziTesbihat;
  bool ogleNamazi;
  bool ogleNamaziTesbihat;
  bool ikindiNamazi;
  bool ikindiNamaziTesbihat;
  bool aksamNamazi;
  bool aksamNamaziTesbihat;
  bool yatsiNamazi;
  bool yatsiNamaziTesbihat;

  ModelTakip({
    required this.tarih,
    required this.mail,
    required this.kuranOkuma,
    required this.kuranEzber,
    required this.risaleOkuma,
    required this.risaleEzber,
    required this.osmanlicaYazi,
    required this.cevsenOkuma,
    required this.kitapOkuma,
    required this.sabahNamazi,
    required this.sabahNamaziTesbihat,
    required this.ogleNamazi,
    required this.ogleNamaziTesbihat,
    required this.ikindiNamazi,
    required this.ikindiNamaziTesbihat,
    required this.aksamNamazi,
    required this.aksamNamaziTesbihat,
    required this.yatsiNamazi,
    required this.yatsiNamaziTesbihat,
  });
}
