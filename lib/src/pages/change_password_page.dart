import 'package:sumarte/src/bloc/auth/auth_bloc.dart';
import 'package:sumarte/src/config/app_theme.dart';
import 'package:sumarte/src/config/background.dart';
import 'package:sumarte/src/helpers/helpers.dart';
import 'package:sumarte/src/services/auth_service.dart';
import 'package:sumarte/src/widgets/circular_indicatiors_widget.dart';
import 'package:sumarte/src/widgets/hide_keyboard.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sumarte/src/widgets/input_widget.dart';

import 'login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool isRequest = false;
  bool isNoVisiblePassword = true;
  bool isLoading = false;
  final _emailController = TextEditingController();
  final _nroDocumento = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return HideKeyboard(
      child: Scaffold(
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
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            "Para cambiar su contraseña favor comunicarce con el departamento de tecnología marcando: (809) 331-7171 ext: 2229.",
                            style: TextStyle(fontSize: 19),textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    /*  Container(
                        alignment: Alignment.center,
                        child: InputWidget(
                          controller: _emailController,
                          icon:
                              Icon(AntDesign.mail, color: Constants.orangeDark),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          labelText: "Correo electrónico",
                          validator: (String email) {
                            if (email.length <= 0) {
                              return "Ingrese el correo electrónico";
                            } else if (!EmailValidator.validate(email)) {
                              return "Correo electrónico invalido";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: InputWidget(
                          controller: _nroDocumento,
                          icon: Icon(FontAwesome5.id_card,
                              color: Constants.orangeDark),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          labelText:
                              "No. documento (Ejemplo: Cedula, RNC, etc...)",
                          validator: (String doc) {
                            if (doc.length == 0) {
                              return "Ingrese el numero de documento";
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
                          onPressed: isRequest ? null : resetForm,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(0)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
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
                      Container(
                        alignment: Alignment.centerRight,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()))
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Ya recuerdas la contraseña? ",
                                  style: TextStyle(
                                      color: AppTheme.dark_grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13)),
                              TextSpan(
                                  text: "Inicia aqui",
                                  style: TextStyle(
                                      color: AppTheme.nearlyDarkOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ]),
                          ),
                        ),
                      ),*/
                      isLoading
                          ? CircularProgressIndicatorWidget()
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetForm() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    setState(() {
      isRequest = true;
      isLoading = true;
    });
    AuthenticationService authenticationService = AuthenticationService();
    final resp = await authenticationService.passreset(
        email: _emailController.text, identificationCard: _nroDocumento.text);
    setState(() {
      isLoading = false;
    });
    if (resp['OK']) {
      mostrarSnackbar(resp['mensaje'], Colors.green);
      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.pushReplacement(context, navegarFadeIn(context, LoginPage()));
      });
    } else {
      mostrarSnackbar(resp['mensaje'], Colors.red);
      setState(() {
        isRequest = false;
      });
    }
    _emailController.clear();
    _nroDocumento.clear();
  }

  void mostrarSnackbar(String mensaje, Color colors) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 3000),
      backgroundColor: colors,
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  /* void resetForm() {
    _nameController.clear();
  }*/

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
