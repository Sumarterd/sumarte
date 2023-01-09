import 'package:sumarte/src/helpers/helpers.dart';
import 'package:flutter/material.dart';

class ButtonNavigator extends StatelessWidget {
  final Function onTabTapped;
  final int currentIndex;

  ButtonNavigator({this.onTabTapped, this.currentIndex});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Constants.orangeDark,
      unselectedItemColor: Colors.white.withOpacity(.60),
      selectedItemColor: Colors.white,
      onTap: this.onTabTapped,
      currentIndex: this.currentIndex,
      unselectedLabelStyle: TextStyle(fontSize: 12),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list, color: Colors.white.withOpacity(.60)),
          activeIcon: Icon(Icons.list, color: Colors.white),
          label: 'Mis Solicitudes',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add,
            color: Colors.white.withOpacity(.60),
          ),
          activeIcon: Icon(Icons.add, color: Colors.white),
          label: 'Nueva Solicitud',
        )
      ],
    );
  }
}
