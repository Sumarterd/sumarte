import 'package:sumarte/src/bloc/auth/auth_bloc.dart';
import 'package:sumarte/src/config/app_theme.dart';
import 'package:sumarte/src/config/background.dart';
import 'package:sumarte/src/helpers/helpers.dart';
import 'package:sumarte/src/models/user.dart';
import 'package:sumarte/src/services/auth_service.dart';
import 'package:sumarte/src/widgets/circular_indicatiors_widget.dart';
import 'package:sumarte/src/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'login_page.dart';

class ResetPassword extends StatefulWidget {
  static final routeName = '/restpass';
  ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _newPassword = TextEditingController();
  final _newPasswordConfirm = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool isRequest = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(LoggedOut());

              Navigator.pushNamedAndRemoveUntil(
                  context, LoginPage.routeName, (route) => true);
            },
          ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      key: _scaffoldKey,
        body: Background(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: size.height * 0.38),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Por favor cambie su contraseña temporal.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: InputWidget(
                        controller: _newPassword,
                        icon: Icon(AntDesign.lock, color: Constants.orangeDark),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        labelText: "Nueva Contraseña",
                        validator: (String password) {
                          if (password.length <= 0) {
                            return "Ingrese la nueva constraseña";
                          } else if (password.length < 6) {
                            return "La constraseña debe tener un minimo de 6 caracteres";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: InputWidget(
                        controller: _newPasswordConfirm,
                        icon:
                            Icon(Icons.lock_sharp, color: Constants.orangeDark),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        labelText: "Confirmar nueva contraseña",
                        validator: (String password) {
                          if (password.length <= 0) {
                            return "Ingrese la constraseña";
                          }
                          if (_newPassword.text != password) {
                            return "Las constraseñas no coinciden";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Container(
                      alignment: Alignment.centerRight,
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: ElevatedButton(
                        onPressed: isRequest ? null : resetPassword,
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80.0),
                                      side: BorderSide(color: AppTheme.white))),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: size.width * 0.5,
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              gradient: new LinearGradient(colors: [
                                Color.fromARGB(255, 255, 136, 34),
                                Color.fromARGB(255, 255, 177, 41)
                              ])),
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            "ENVIAR",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white),
                          ),
                        ),
                      ),
                    ),
                    isLoading ? CircularProgressIndicatorWidget() : Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetPassword() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState.validate()) return;
    setState(() {
      isRequest = true;
      isLoading = true;
    });
    AuthenticationService authenticationService = AuthenticationService();
    User current = authenticationService.getUserLogged();
    final resp = await authenticationService.changepass(
        id: current.id, password: _newPassword.text);

    if (resp['OK']) {
      BlocProvider.of<AuthBloc>(context).add(LoggedOut());
      setState(() {
        isLoading = false;
      });
      BlocProvider.of<AuthBloc>(context).add(LoggedOut());
      Navigator.pushNamedAndRemoveUntil(
          context, LoginPage.routeName, (route) => false);

    } else {
      setState(() {
        isRequest = false;
      });
    }
    _newPassword.clear();
    _newPasswordConfirm.clear();
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 3000),
      backgroundColor: Colors.green,
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
