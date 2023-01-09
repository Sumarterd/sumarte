import 'package:sumarte/src/config/app_theme.dart';
import 'package:sumarte/src/models/segments_list_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeSectionThree extends StatefulWidget {
  const HomeSectionThree(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<double> mainScreenAnimation;

  @override
  _HomeSectionThreeState createState() => _HomeSectionThreeState();
}

class _HomeSectionThreeState extends State<HomeSectionThree>
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

  void _launchURL(url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
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
                padding: EdgeInsets.only(left: 19.0, right: 19.0, bottom: 35),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: ImageSlideshow(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .25,
                    initialPage: 0,
                    indicatorColor: AppTheme.nearlyDarkOrange,
                    indicatorBackgroundColor: AppTheme.white,
                    isLoop: true,
                    children: [
                      GestureDetector(
                        onTap: () => _launchURL(
                            "http://alcaldiasdn.gob.do/category/noticias/"), // handle your image tap here
                        child: Image.asset(
                          'assets/news/1.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _launchURL(
                            "http://alcaldiasdn.gob.do/category/noticias/"), // handle your image tap here
                        child: Image.asset(
                          'assets/news/2.jpg',
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                    onPageChanged: (value) {},
                    autoPlayInterval: 3000,
                  ),
                ),
              )),
        );
      },
    );
  }
}
