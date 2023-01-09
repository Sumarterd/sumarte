import 'package:sumarte/src/config/app_theme.dart';
import 'package:sumarte/src/config/main_full_view.dart';
import 'package:sumarte/src/models/segments_list_data.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeSectionTwo extends StatefulWidget {
  const HomeSectionTwo(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<double> mainScreenAnimation;

  @override
  _HomeSectionTwoState createState() => _HomeSectionTwoState();
}

class _HomeSectionTwoState extends State<HomeSectionTwo>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<SegmentListData> segmentListData = SegmentListData.tabIconsList;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: segmentListData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      segmentListData.length > 10 ? 10 : segmentListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return ItemsView(
                      homeListData: segmentListData[index],
                      animation: animation,
                      animationController: animationController);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class ItemsView extends StatelessWidget {
  const ItemsView(
      {Key key, this.homeListData, this.animationController, this.animation})
      : super(key: key);

  final SegmentListData homeListData;
  final AnimationController animationController;
  final Animation<double> animation;
  void _launchURL(url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: SizedBox(
              width: 130,
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (homeListData.id == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainFullViewer(
                                    identificationPage: "invoice")));
                      } else if (homeListData.id == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainFullViewer(
                                    identificationPage: "report")));
                      } else if (homeListData.id == 2) {
                        _launchURL(
                            "http://alcaldiasdn.gob.do/category/noticias/");
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top:  38, left: 8, right: 8, bottom: 22),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Color(0xFF3A5160).withOpacity(0.6),
                                offset: const Offset(1.1, 4.0),
                                blurRadius: 8.0),
                          ],
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(homeListData.startColor),
                              Color(homeListData.endColor),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(54.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 54, left: 10, right: 10, bottom: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                homeListData.titleTxt,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: AppTheme.white,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        homeListData.desc.join('\n'),
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          letterSpacing: 0.2,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 8,
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(homeListData.imagePath),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSheet(String text, BuildContext context) =>
      ListView(padding: EdgeInsets.all(20), children: <Widget>[
        Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar')),
      ]);
}
