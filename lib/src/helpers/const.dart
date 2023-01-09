part of 'helpers.dart';

class Constants {
  // Name
  static String appName = "Ayuntamiento SDN";

  /* Colores propios de la app segun el logo**/

  static Color main = Color(0xffbda928);
  static Color second = Color(0xff386d39);
  /*  */
  static Color greenLightBackground = Color(0xff125167);
  static Color greenBackground = Color(0xff386d39);

  static Color orangeDark = Color(0xFF17262A);
  // Material Design Color
  static Color lightPrimary = Color(0xfffcfcff);
  static Color lightAccent = Color(0xFF3B72FF);
  static Color lightBackground = Color(0xfffcfcff);

  static Color darkPrimary = Colors.black;
  static Color darkAccent = Color(0xFF3B72FF);
  static Color darkBackground = Colors.black;

  static Color textPrimary = Color(0xFF486581);
  static Color textDark = Color(0xFF102A43);

  static Color backgroundColor = Color(0xFFF5F5F7);

  // Green
  static Color darkGreen = Color(0xFF3ABD6F);
  static Color lightGreen = Color(0xFFA1ECBF);
  static Color extraDarkGreen = Color(0xFF459C5A);

  // Yellow
  static Color darkYellow = Color(0xFF3ABD6F);
  static Color lightYellow = Color(0xFFFFDA7A);

  // Blue
  static Color darkBlue = Color(0xFF3B72FF);
  static Color lightBlue = Color(0xFF3EC6FF);

  // Orange
  static Color darkOrange = Color(0xFF17262A);

  //Purple
  static Color lightPurple = Color(0xff898edf);
  static Color darkPurple = Color(0xff635EA6);
  static Color extraDarkPurple = Color(0xff494c79);

  // Gray
  static Color darkGrey = Color(0xff8A8D93);
  static Color grey = Color(0xff707070);
  static Color greyLight = Color(0xffDCDCDC);

  static ThemeData lighTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Constants.orangeDark,
      backgroundColor: Constants.orangeDark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        headline6: TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
        bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        bodyText2: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      ),
    );
  }

  static double headerHeight = 228.5;
  static double paddingSide = 30.0;
}
