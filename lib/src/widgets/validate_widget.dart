import 'package:sumarte/src/helpers/helpers.dart';
import 'package:flutter/material.dart';

class ValidateWidget extends StatelessWidget {
  final String text;
  final Function reload;
  ValidateWidget({Key key, this.text, this.reload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //LogoWidget(),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Constants.orangeDark),
              onPressed: this.reload,
              icon: Icon(Icons.update),
              label: Text(this.text, style: TextStyle(fontSize: 16)))
        ],
      ),
    );
  }
}
