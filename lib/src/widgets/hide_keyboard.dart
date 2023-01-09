import 'package:flutter/material.dart';

class HideKeyboard extends StatelessWidget {
  final Widget child;
  HideKeyboard({this.child});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: this.child,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        });
  }
}
