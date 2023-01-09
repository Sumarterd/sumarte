import 'package:sumarte/src/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputWidget extends StatelessWidget {
  final TextInputType keyboardType;
  final StatelessWidget icon;
  final String labelText;
  final bool obscureText;
  final StatelessWidget suffixIcon;
  final StatelessWidget prefixIcon;
  final List<FilteringTextInputFormatter> inputFormatters;
  final Function validator;
  final TextEditingController controller;

  InputWidget(
      {@required this.keyboardType,
      this.icon,
      this.suffixIcon,
      this.prefixIcon,
      @required this.labelText,
      @required this.obscureText,
      this.validator,
      this.controller,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        autofocus: false,
        controller: controller,
        obscureText: obscureText,
        validator: this.validator,
        keyboardType: this.keyboardType,
        style: TextStyle(color: Colors.black54),
        inputFormatters: this.inputFormatters,
        decoration: InputDecoration(
          icon: icon,
          suffixIcon: this.suffixIcon,
          prefixIcon: this.prefixIcon,
          // hintText: 'ejemplo@correo.com',
          labelText: this.labelText,
          // counterText: snapshot.data,
          // errorText: snapshot.error,

          labelStyle: TextStyle(color: Colors.black54),
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
        // onChanged: bloc.changeEmail,
      ),
    );
  }
}
