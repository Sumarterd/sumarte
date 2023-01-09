import 'package:sumarte/src/pages/section/request_detail_list_section.dart';
import 'package:sumarte/src/ui_view/title_view.dart';
import 'package:flutter/material.dart';

class SectionsRequestDetailSacreen extends StatefulWidget {
  const SectionsRequestDetailSacreen({Key key, this.animationController})
      : super(key: key);

  final AnimationController animationController;

  @override
  _SectionsRequestDetailSacreenState createState() =>
      _SectionsRequestDetailSacreenState();
}

class _SectionsRequestDetailSacreenState
    extends State<SectionsRequestDetailSacreen> with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];
  double topBarOpacity = 1;

  @override
  void initState() {
    addAllListData();
    super.initState();
  }

  void addAllListData() {
    const int count = 9;
    listViews.add(
      TitleView(
        titleTxt: 'Tus solicitudes',
        /*subTxt: "Lista de incidentes registrados.",*/
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      RequestDetailListSection(
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
      padding: const EdgeInsets.only(top: 150),
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
