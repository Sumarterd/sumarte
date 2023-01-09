class SegmentListData {
  SegmentListData({
    this.id = 0,
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.desc,
    this.kacl = 0,
  });
  int id;
  String imagePath;
  String titleTxt;
  Object startColor;
  Object endColor;
  List<String> desc;
  int kacl;

  static List<SegmentListData> tabIconsList = <SegmentListData>[
    SegmentListData(
      id: 0,
      imagePath: 'assets/home/invoice.png',
      titleTxt: 'Facturas',
      kacl: 10,
      desc: <String>['Consulta', 'tus últimas', '10 factuas.'],
      startColor: 0xff4a70cb,
      endColor: 0xff4a70cb,
    ),
    SegmentListData(
      id: 1,
      imagePath: 'assets/home/report.png',
      titleTxt: 'Reporte',
      kacl: 602,
      desc: <String>['Reporta', 'incidentes en', 'tu sector.'],
      startColor: 0xFF213333,
      endColor: 0xFF3A5160,
    ),
    SegmentListData(
      id: 2,
      imagePath: 'assets/home/news.png',
      titleTxt: 'Noticias',
      kacl: 602,
      desc: <String>['Enterate de', 'las novedades', 'de tu sector.'],
      startColor: 0xffa4c639,
      endColor: 0xffa4c639,
    ),
  ];
}
