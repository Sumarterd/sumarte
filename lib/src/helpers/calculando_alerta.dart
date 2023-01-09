part of 'helpers.dart';

void calculandoAlerta(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Espere por favor'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('Cargando localizacion', style: TextStyle(fontSize: 12)),
            CircularProgressIndicatorWidget()
          ],
        ),
      ),
    );
  } else {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Espere por favor'),
        content: CupertinoActivityIndicator(),
      ),
    );
  }
}
