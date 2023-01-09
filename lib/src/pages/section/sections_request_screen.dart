import 'package:sumarte/src/models/tabIcon_data.dart';
import 'package:sumarte/src/pages/section/request_list_section.dart';
import 'package:sumarte/src/ui_view/title_view.dart';
import 'package:flutter/material.dart';

class SectionsRequestScreen extends StatefulWidget {
  const SectionsRequestScreen({Key key, this.animationController})
      : super(key: key);

  final AnimationController animationController;

  @override
  _SectionsRequestScreenState createState() => _SectionsRequestScreenState();
}

class _SectionsRequestScreenState extends State<SectionsRequestScreen>
    with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 1;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });

    addAllListData();

    super.initState();
  }

  void addAllListData() {
    const int count = 9;
    listViews.add(
      TitleView(
        titleTxt: 'Reportar nuevo incidente',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      RequestListSection(
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
}
