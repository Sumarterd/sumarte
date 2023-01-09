import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
     /*     Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
                "assets/login/top1.png"
            ),
          ),*/
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
                "assets/login/top2.png",
            ),
          ),
          Positioned(
            top: 70,
            left: 20,
            child: Image.asset(
                "assets/logo_paqueno.png",
                width: size.width * 0.40
            ),
          ),
         /* Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
                "assets/login/bottom1.png",
                width: size.width
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
                "assets/login/bottom2.png",
                width: size.width
            ),
          ),*/
          child
        ],
      ),
    );
  }
}