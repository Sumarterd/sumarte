import 'package:sumarte/src/config/app_theme.dart';
import 'package:flutter/material.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  const CircularProgressIndicatorWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.nearlyDarkOrange),
        backgroundColor: AppTheme.white);
  }
}
