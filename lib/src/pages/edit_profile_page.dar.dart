
import 'package:sumarte/src/config/app_theme.dart';
import 'package:sumarte/src/helpers/helpers.dart';
import 'package:sumarte/src/models/Profile.dart';
import 'package:sumarte/src/models/search_response_geolocation.dart';
import 'package:sumarte/src/models/tabIcon_data.dart';
import 'package:sumarte/src/models/user.dart';
import 'package:sumarte/src/services/auth_service.dart';
import 'package:sumarte/src/services/request_service.dart';
import 'package:sumarte/src/utils/functions.dart';
import 'package:sumarte/src/widgets/circular_indicatiors_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key key, this.animationController})
      : super(key: key);

  final AnimationController animationController;

  @override
  _EditProfileScreenState createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> with TickerProviderStateMixin {

  AnimationController animationController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  final formKey = GlobalKey<FormState>();
  //final _idController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _identificationCardController = TextEditingController();

  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    super.initState();
    User current = authenticationService.getUserLogged();
    Future<Profile> userProfile = authenticationService.userProfile(current.identificationCard);
    userProfile.then((value)
    {
      _identificationCardController.text = value.identificationCard;
      _firstNameController.text = value.firstName;
      _lastNameController.text = value.lastName;
      _phoneController.text = value.phone;
      _emailController.text = value.email;
    });
  }
  bool canPressRegisterBtn = true;
  final RequestService requestService = RequestService();
  final AuthenticationService authenticationService = AuthenticationService();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          height: MediaQuery.of(context).size.height * 0.922,
          padding: const EdgeInsets.only(top: 160),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  inputIdentificationCard(),
                  inputFirstName(),
                  inputLastName(),
                  inputEmail(),
                  inputPhone(),
                  inputPassword(),
                  inputPassword2(),
                  btnSave(),
                ],
              ),
            ),
          ),
        );
  }
  Widget inputFirstName() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Nombre",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.nearlyDarkOrange,
                      fontWeight: FontWeight.bold)),
              Text(' * ',
                  style: TextStyle(fontSize: 15, color: AppTheme.redText))
            ],
          ),
          TextFormField(
            controller: _firstNameController,
            validator: (String detail) {
              if (detail.length <= 0) {
                return "Debe colocar el primer nombre";
              }
              return null;
            },
            minLines: 1,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            autofocus: false,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                  BorderSide(color: Constants.grey.withOpacity(0.5)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.grey,
                  ),
                ),
                labelStyle: TextStyle(color: Colors.white60),
            ),
          ),

        ],
      ),
    );
  }
  Widget inputLastName() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Apellido",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.nearlyDarkOrange,
                      fontWeight: FontWeight.bold)),
              Text(' * ',
                  style: TextStyle(fontSize: 15, color: AppTheme.redText))
            ],
          ),
          TextFormField(
            controller: _lastNameController,
            validator: (String detail) {
              if (detail.length <= 0) {
                return "Debe colocar el primer nombre";
              }
              return null;
            },
            minLines: 1,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            autofocus: false,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: Constants.grey.withOpacity(0.5)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Constants.grey,
                ),
              ),
              labelStyle: TextStyle(color: Colors.white60),
            ),
          ),

        ],
      ),
    );
  }
  Widget inputEmail() {

          return Container(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("E-mail",
                        style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.nearlyDarkOrange,
                            fontWeight: FontWeight.bold)),
                    Text(' * ',
                        style: TextStyle(fontSize: 15, color: AppTheme.redText))
                  ],
                ),
                TextFormField(
                  controller: _emailController,
                  validator: (String email) {
                    print(email.length);
                    if (email.length <= 0) {
                      return "Ingrese el correo electrónico";
                    } else if (!EmailValidator.validate(email)) {
                      return "Correo electrónico invalido";
                    }
                    return null;
                  },
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  autofocus: false,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Constants.grey.withOpacity(0.5)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Constants.grey,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.white60),
                  ),
                ),

              ],
            ),
          );
  }
  Widget inputPhone() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Telefono",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.nearlyDarkOrange,
                      fontWeight: FontWeight.bold)),
              Text(' * ',
                  style: TextStyle(fontSize: 15, color: AppTheme.redText))
            ],
          ),
          TextFormField(
            controller: _phoneController,
            validator: (String phone) {
              if (phone.length <= 0) {
                return "Ingrese el teléfono ";
              } else if (phone.length != 10) {
                return "Ingrese un teléfono correcto";
              }
              return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            minLines: 1,
            keyboardType: TextInputType.number,
            maxLines: 4,
            autofocus: false,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: Constants.grey.withOpacity(0.5)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Constants.grey,
                ),
              ),
              labelStyle: TextStyle(color: Colors.white60),
            ),
          ),

        ],
      ),
    );
  }
  Widget inputIdentificationCard() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("No. Documento",
                  style: TextStyle(
                      fontSize: 16,
                      color: Constants.grey,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          TextFormField(
            enabled: false,
            controller: _identificationCardController,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            autofocus: false,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: Constants.grey.withOpacity(0.5)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Constants.grey,
                ),
              ),
              labelStyle: TextStyle(color: Colors.white60),
            ),
          ),

        ],
      ),
    );
  }

  Widget inputPassword() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Contraseña",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.nearlyDarkOrange,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            inputFormatters: [
              FilteringTextInputFormatter.singleLineFormatter
            ],
            validator: (String password) {
              if (password.length > 0) {
               if (password.length < 6) {
                return "La constraseña debe tener un minimo de 6 caracteres";
                }
              }
              return null;
            },
            decoration: InputDecoration(hintText: "*************",
              enabledBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: Constants.grey.withOpacity(0.5)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Constants.grey,
                ),
              ),
              labelStyle: TextStyle(color: Colors.white60),
            ),
          ),

        ],
      ),
    );
  }
  Widget inputPassword2() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Confirmar contraseña",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.nearlyDarkOrange,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          TextFormField(
            obscureText: true,
            controller: _password2Controller,
            inputFormatters: [
              FilteringTextInputFormatter.singleLineFormatter
            ],
            validator: (String password) {
              if (_passwordController.text != password) {
                return "Las constraseñas no coinciden";
              }
              return null;
            },
            decoration: InputDecoration(hintText: "*************",
              enabledBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: Constants.grey.withOpacity(0.5)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Constants.grey,
                ),
              ),
              labelStyle: TextStyle(color: Colors.white60),
            ),
          ),

        ],
      ),
    );
  }

  Widget btnSave() {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      width:  double.infinity,
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: canPressRegisterBtn ? saveUserProfile : null,
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                  side: BorderSide(color: AppTheme.white))),
        ),
        child: Container(
          alignment: Alignment.center,
          height: 50.0,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(80.0),
            gradient: new LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 136, 34),
                Color.fromARGB(255, 255, 177, 41)
              ],
            ),
          ),
          padding: const EdgeInsets.all(0),
          child: Text(
            "ACTUALIZAR",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void saveUserProfile() async {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    Map<String, dynamic> data = {
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "email": _emailController.text,
      "password":_passwordController.text,
      "phone": _phoneController.text,
      "IdentificationCard": _identificationCardController.text,
    };

    setState(() {
      canPressRegisterBtn = false;
    });
    bool resp = await requestService.saveprofile(data);

    if (resp) {
      SchedulerBinding.instance.addPostFrameCallback((_) {

        setState(() {
          canPressRegisterBtn = true;
          _password2Controller.clear();
          _passwordController.clear();
        });

        showAlertDialog(context, "Usuario actualizado correctamente.", true);
      });
    } else {
      setState(() {
        canPressRegisterBtn = true;
      });
      showAlertDialog(context, "Error al actualizar el perfil.", false);
    }

  }
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }


}
