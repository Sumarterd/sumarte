import 'dart:ui';

import 'package:sumarte/src/bloc/auth/auth_bloc.dart';
import 'package:sumarte/src/config/setting_widget.dart';
import 'package:sumarte/src/models/tabIcon_data.dart';
import 'package:sumarte/src/models/user.dart';
import 'package:sumarte/src/pages/card_invoice.dart';
import 'package:sumarte/src/pages/edit_profile_page.dar.dart';
import 'package:sumarte/src/pages/login_page.dart';
import 'package:sumarte/src/pages/payment_history.dart';
import 'package:sumarte/src/pages/reset_password.dart';
import 'package:sumarte/src/pages/section/sections_invoice_screen.dart';
import 'package:sumarte/src/pages/section/sections_request_detail_screen.dart';
import 'package:sumarte/src/pages/section/sections_request_screen.dart';
import 'package:sumarte/src/pages/section/sections_screen.dart';
import 'package:sumarte/src/pages/section/sections_trash_screen.dart';
import 'package:sumarte/src/services/auth_service.dart';
import 'package:sumarte/src/widgets/circular_indicatiors_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme.dart';
import 'bottom_bar_view.dart';

class MainFullViewer extends StatefulWidget {
  static final routeName = '/main';

  const MainFullViewer({Key key, this.identificationPage}) : super(key: key);
  final identificationPage;

  _MainFullViewerState createState() => _MainFullViewerState();
}

class _MainFullViewerState extends State<MainFullViewer>
    with TickerProviderStateMixin {
  AuthenticationService authenticationService = AuthenticationService();
  double topBarOpacity = 1;
  Animation<double> topBarAnimation;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  AnimationController animationController;
  Widget tabBody = Container(
    color: AppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    //chequear login page para resolver el load animation del header
    topBarAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    if (widget.identificationPage == "home") {
      tabIconsList[0].isSelected = true;
      tabBody = SectionsHomeScreen(animationController: animationController);
    } else if (widget.identificationPage == "trash") {
      tabIconsList[1].isSelected = true;
      tabBody = SectionsTrashScreen(animationController: animationController);
    }else if (widget.identificationPage == "invoice") {
      tabIconsList[2].isSelected = true;
      tabBody = SectionsInvoiceScreen(animationController: animationController);
    } else if (widget.identificationPage == "report") {
      tabIconsList[0].isSelected = false;
      tabBody = SectionsRequestScreen(animationController: animationController);
    } else if (widget.identificationPage == "request") {
      tabIconsList[3].isSelected = true;
      tabBody = SectionsRequestDetailSacreen(animationController: animationController);
    } else if (widget.identificationPage == "CreateRequest") {
      tabIconsList[3].isSelected = true;
      tabBody = SectionsRequestScreen(animationController: animationController);
    }else if (widget.identificationPage == "profile") {
      tabIconsList[3].isSelected = true;
      tabBody = EditProfileScreen(animationController: animationController);
    }else if (widget.identificationPage == "card") {
      tabIconsList[0].isSelected = false;
      tabBody = CardInvoiceScreen(animationController: animationController);
    }else if (widget.identificationPage == "paymnetHistory") {
      tabIconsList[0].isSelected = false;
      tabBody = PaymentHistoryScreen(animationController: animationController);
    }
    super.initState();

    User current = authenticationService.getUserLogged();
    if (current.needResetPass.toLowerCase() == '1') {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, ResetPassword.routeName, (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.authenticated == false) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(
              context, LoginPage.routeName, (route) => false);
        });
      }
    }, builder: (context, state) {
      if (state.authenticated == false) {
        return Container();
      }

      return Container(
        color: AppTheme.background,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: SettingWidget(),
          body: FutureBuilder<bool>(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                return Stack(
                  children: <Widget>[
                    TopBarHeader(context),
                    tabBody,
                    BottomBar(),
                  ],
                );
              }
            },
          ),
        ),
      );
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  // ignore: non_constant_identifier_names
  Widget BottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            animationController.reverse().then<dynamic>((data) {
              if (!mounted) {
                return;
              }
              setState(() {
                tabBody = SectionsRequestScreen(
                    animationController: animationController);
              });
            });
          },
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = SectionsHomeScreen(
                      animationController: animationController);
                });
              });
            }else if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = SectionsTrashScreen(
                      animationController: animationController);
                });
              });
            } else if (index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = SectionsInvoiceScreen(
                      animationController: animationController);
                });
              });
            } else if (index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = SectionsRequestDetailSacreen(
                      animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget TopBarHeader(BuildContext context) {
    return Container(
      height: 150,
      child: FadeTransition(
        opacity: topBarAnimation,
        child: Transform(
          transform: Matrix4.translationValues(
              0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.nearlyDarkOrange.withOpacity(topBarOpacity),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: AppTheme.grey.withOpacity(0.2 * topBarOpacity),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ],
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 26,
                      right: 26,
                      top: 26 - 8.0 * topBarOpacity,
                      bottom: 23 - 8.0 * topBarOpacity),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: FutureBuilder<User>(
                            future: authenticationService.currentUser(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Image(
                                        image: AssetImage("assets/logo2.png"),
                                        height: 50.0,
                                        width: 50.0,
                                      ),
                                    ),/*
                                    Text(
                                      "ASDN " *//* snapshot.data.firstName*//*,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18 + 6 - 6 * topBarOpacity,
                                          letterSpacing: 1.2,
                                          color: AppTheme.white),
                                    ),*/
                                  ],
                                );
                              }
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      child: CircularProgressIndicatorWidget(),
                                      height: 40.0,
                                      width: 40.0,
                                    )
                                  ]);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 0,
                          right: 0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Container(
                                child: IconButton(
                                  iconSize: 30,
                                  onPressed: () =>
                                      {Scaffold.of(context).openDrawer()},
                                  icon: Icon(Icons.more_vert),
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
}
