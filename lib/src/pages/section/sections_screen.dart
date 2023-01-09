import 'package:sumarte/src/models/user.dart';
import 'package:sumarte/src/services/auth_service.dart';
import 'package:sumarte/src/ui_view/home_section_one.dart';
import 'package:sumarte/src/ui_view/title_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_section_three.dart';
import 'home_section_two.dart';

class SectionsHomeScreen extends StatefulWidget {
  const SectionsHomeScreen({Key key, this.animationController})
      : super(key: key);

  final AnimationController animationController;

  @override
  _SectionsHomeScreenState createState() => _SectionsHomeScreenState();
}

class _SectionsHomeScreenState extends State<SectionsHomeScreen>
    with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];
  //final ScrollController scrollController = ScrollController();
  //double topBarOpacity = 1;

  @override
  void initState() {
    addAllListData();
    /* scrollController.addListener(() {
         if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }

    });}*/
    super.initState();
  }

  void addAllListData() {
    const int count = 9;
    listViews.add(wolecomeHomeSection());
    listViews.add(
      HomeSectionOne(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

/*
    listViews.add(
      TitleView(
        titleTxt: 'Segmentos',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );*/

    listViews.add(
      HomeSectionTwo(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

/*
    listViews.add(
      TitleView(
        titleTxt: 'Noticias',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
*/

    listViews.add(
      HomeSectionThree(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.922,
      padding: const EdgeInsets.only(top: 160),
      child: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 13),
            itemCount: listViews.length,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        },
      ),
    );
  }

  Widget wolecomeHomeSection() {
    final AuthenticationService authenticationService = AuthenticationService();

    return FutureBuilder<User>(
      future: authenticationService.currentUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return TitleView(
            titleTxt:
                'Hola! ' + toBeginningOfSentenceCase(snapshot.data.firstName),
            subTxt: "¿Qué quieres hacer hoy?",
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController,
                    curve: Interval((1 / 9) * 2, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          );
        }
      },
    );
  }
}
