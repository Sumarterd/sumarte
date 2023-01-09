import 'package:sumarte/src/config/app_theme.dart';
import 'package:flutter/material.dart';

class HomeSectionOne extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const HomeSectionOne({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 0, bottom: 0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16, left: 16, right: 16, bottom: 16),
                      child: Container(
                        width: 510.0,
                        height: 210.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/home/bg_asdn.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
