import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sumarte/src/config/app_theme.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  final AnimationController mainScreenAnimationController;
  final Animation<double> mainScreenAnimation;

  @override
  _TrashScreenScreenState createState() => _TrashScreenScreenState();
}

class _TrashScreenScreenState extends State<TrashScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.41,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 5,
            child: PhotoView(
              backgroundDecoration: BoxDecoration(
                color: AppTheme.nearlyDarkOrange,
                shape: BoxShape.circle,
              ),
              imageProvider: CachedNetworkImageProvider(
                  "https://appasdn.site/assets/images/trash_schedule.jpeg"),
            ),
          )),
      Container(
        child: Image(
          image: AssetImage('assets/truck.png'),
          width: 200,
          height: 110,
        ),
      )
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
