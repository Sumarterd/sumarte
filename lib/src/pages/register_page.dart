import 'package:sumarte/src/config/app_theme.dart';
import 'package:sumarte/src/config/background.dart';
import 'package:sumarte/src/helpers/helpers.dart';
import 'package:sumarte/src/models/documentstypes.dart';
import 'package:sumarte/src/services/auth_service.dart';
import 'package:sumarte/src/utils/functions.dart';
import 'package:sumarte/src/widgets/circular_indicatiors_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:sumarte/src/widgets/input_widget.dart';
import 'package:sumarte/src/bloc/register/register_bloc.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  static final routeName = '/register';

  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isRequest = false;
  bool isNoVisiblePassword = true;
  bool isLoading = false;
  String _value = "0";
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
  bool clickLogin = false;
  RegisterBloc registerBloc;

  @override
  void initState() {
    registerBloc = BlocProvider.of<RegisterBloc>(context);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
     return BlocConsumer<RegisterBloc, RegisterState>(listener: (context, state) {

         if (!state.registrado) {
           WidgetsBinding.instance
               .addPostFrameCallback((_) {
             showAlertDialog(context,state.errorRegistro,false);
           });
         }else{
           if(state.registrado){
             Navigator.pushNamedAndRemoveUntil(
                 context, LoginPage.routeName, (route) => false);
           }
         }
          }, builder: (context, state) {
     return Scaffold(
        key: scaffoldKey,
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: size.height * 0.28),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: InputWidget(
                          controller: _nameController,
                          icon: Icon(AntDesign.adduser,
                              color: Constants.orangeDark),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          labelText: "Nombre",
                          validator: (String name) {
                            if (name.length <= 0) {
                              return "Ingrese el nombre";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: InputWidget(
                          controller: _lastnameController,
                          icon:
                              Icon(AntDesign.user, color: Constants.orangeDark),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          labelText: "Apellidos",
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter
                          ],
                          validator: (String lastname) {
                            if (lastname.length <= 0) {
                              return "Ingrese los apellidos";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      documenttype(),
                      Container(
                        alignment: Alignment.center,
                        child: InputWidget(
                          controller: _documentNumberController,
                          icon: Icon(FontAwesome5.id_card,
                              color: Constants.orangeDark),
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                      Container(
                        alignment: Alignment.center,
                        child: InputWidget(
                          controller: _phoneNumberController,
                          icon: Icon(Icons.phone, color: Constants.orangeDark),
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          labelText: "No. teléfono ",
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (String phone) {
                            if (phone.length <= 0) {
                              return "Ingrese el teléfono ";
                            } else if (phone.length != 10) {
                              return "Ingrese un teléfono correcto";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
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
                          controller: _passwordController,
                          icon:
                              Icon(AntDesign.lock, color: Constants.orangeDark),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          labelText: "Contraseña",
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter
                          ],
                          validator: (String password) {
                            if (password.length <= 0) {
                              return "Ingrese la constraseña";
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
                          controller: _password2Controller,
                          icon: Icon(Icons.lock_sharp,
                              color: Constants.orangeDark),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          labelText: "Confirmar contraseña",
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter
                          ],
                          validator: (String password) {
                            if (password.length <= 0) {
                              return "Ingrese la constraseña";
                            }
                            if (_passwordController.text != password) {
                              return "Las constraseñas no coinciden";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        alignment: Alignment.centerRight,
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: ElevatedButton(
                          onPressed: _onSubmit,
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
                              "REGISTRAR",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()))
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Ya tienes una cuenta? ",
                            style: TextStyle(
                                color: AppTheme.dark_grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 13)),
                        TextSpan(
                            text: "Inicia aqui",
                            style: TextStyle(
                                color: AppTheme.nearlyDarkOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
     );
     });
  }

  Widget documenttype() {
    return Container(
      padding: EdgeInsets.all(15),
      child: _dropdownDocument(),
    );
  }

  Widget _dropdownDocument() {
    AuthenticationService requestService = AuthenticationService();
    return FutureBuilder<DocumentsTypes>(
        future: requestService.documenttype(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicatorWidget();
          }
          List<DocumentType> data = [];

          data.add(
            DocumentType(
                idTipoDocumento: "0",
                descripcionDocumento: "Seleccione un tipo de documento"),
          );

          if (snapshot.hasData) {
            data.addAll(snapshot.data.data.toList());
          }

          return DropdownButtonFormField<String>(
            style: TextStyle(color: Colors.black54, fontSize: 17),
            decoration: InputDecoration(
              icon:
                  Icon(FontAwesome5.address_card, color: Constants.orangeDark),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Constants.orangeDark.withOpacity(0.5)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Constants.orangeDark,
                ),
              ),
            ),
            isExpanded: true,
            value: _value,
            validator: (value) {
              if (value == "0") {
                return "Debe seleccionar el tipo de documento";
              }
              return null;
            },
            onChanged: (type) => setState(() => _value = type),
            items: data
                .map<DropdownMenuItem<String>>(
                    (value) => new DropdownMenuItem<String>(
                          value: value.idTipoDocumento,
                          child: new Text(value.descripcionDocumento),
                        ))
                .toList(),
          );
        });
  }

  void _onSubmit() async {
    if (!formKey.currentState.validate()) return;
    registerBloc.add(
      RegisterButtonPressed(
          name: _nameController.text,
          lastname: _lastnameController.text,
          documentNumber: _documentNumberController.text,
          phone: _phoneNumberController.text,
          email: _emailController.text,
          tipoDoc: _value,
          password: _passwordController.text),
    );
    setState(() {
      clickLogin = true;
    });

  }

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

  void setIsRequest(bool isRequest) {
    setState(() {
      this.isRequest = isRequest;
    });
  }
}
