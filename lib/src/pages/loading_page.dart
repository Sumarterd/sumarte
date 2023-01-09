import 'package:sumarte/src/helpers/gps.dart';
import 'package:sumarte/src/helpers/helpers.dart';
import 'package:sumarte/src/utils/functions.dart';
import 'package:sumarte/src/widgets/circular_indicatiors_widget.dart';
import 'package:sumarte/src/widgets/validate_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'login_page.dart';

class LoadingPage extends StatefulWidget {
  static final routeName = '/loading';
  const LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addObserver(this);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      bool internet = await connectionValidate();
      if (await Geolocator.isLocationServiceEnabled() && internet) {
        Navigator.pushReplacement(context, navegarFadeIn(context, LoginPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: validate(context: context),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, String>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['Type'] == 'NA') {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 // children: <Widget>[LogoWidget()],
                ),
              );
            }
            return ValidateWidget(
              text: snapshot.data['MSJ'],
              reload: () {
                switch (snapshot.data['Type']) {
                  case "LOCATION":
                    Geolocator.openLocationSettings();
                    break;
                  case "INTERNET":
                    this.validate(context: context);
                    break;
                  default:
                }
              },
            );
          } else {
            return Center(child: CircularProgressIndicatorWidget());
          }
        },
      ),
    );
  }

  Future<Map<String, String>> validate({BuildContext context}) async {
    if (mounted) {
      Map<String, dynamic> gps = await checkGpsLocation(context: context);
      if (gps["OK"] == false) {
        return {"Type": "LOCATION", "MSJ": gps["MSJ"]};
      }

      bool internet = await connectionValidate();

      if (internet == false) {
        return {"Type": "INTERNET", "MSJ": "No posee conexion a internet"};
      }
      if (mounted) {
        Navigator.pushReplacement(context, navegarFadeIn(context, LoginPage()));
      }
    }
    return {"Type": "NA", "MSJ": ""};
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
