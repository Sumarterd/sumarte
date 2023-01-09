import 'dart:convert' show base64Encode, json, jsonDecode, jsonEncode, utf8;
import 'dart:io';

import 'package:sumarte/src/models/Profile.dart';
import 'package:sumarte/src/models/documentstypes.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:sumarte/src/helpers/helpers.dart';
import 'package:sumarte/src/models/user.dart';

import 'package:sumarte/src/share_prefs/preferences_storage.dart';

class AuthenticationService {
  static final AuthenticationService _instancia =
      new AuthenticationService._internal();

  PreferenceStorage preferenceStorage = PreferenceStorage();
  final String _baseUrl = dotenv.env['BASE_URL'];

  final _dio = new Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'],
    ),
  );

  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));
  String basicAuth = 'Basic ' +
      base64Encode(
          utf8.encode(dotenv.env['USERNAME'] + ':' + dotenv.env['PASSWORD']));

  factory AuthenticationService() {
    return _instancia;
  }

  AuthenticationService._internal();

  Future<Map<String, dynamic>> signIn(
      {String username, String password}) async {
    try {
      Map<String, String> params = {
        "IdentificationCard": "$username",
        "password": "$password",
      };
      final resp = await this._dio.post("/RequestUsersWebServer/login",
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: basicAuth,
                "X-API-KEY": dotenv.env['X-API-KEY']
              },
              validateStatus: (status) {
                return status < 600;
              }),
          data: jsonEncode(params));
  print(resp);
      if (resp.statusCode >= 200 && resp.statusCode < 250) {
        if (resp.data['status']) {
          var user = json.encode(resp.data['data']);
          await preferenceStorage.setValue(key: "currentUser", value: user);

          return {"OK": true, "user": User.fromJson(json.decode(user))};
        } else {
          return {"OK": false, "mensaje": resp.data['message']};
        }
      }
      return {"OK": false, "mensaje": "Error al al ingresar a la aplicacion"};
    } on Exception catch (e) {
      print(e.toString());
      return {"OK": false, "mensaje": "Error al ingresar a la aplicacion "};
    }
  }

  Future<Map<String, dynamic>> register(
      {String name,
      String lastname,
      String email,
      String password,
      String phone,
      String documentType,
      String identificationCard}) async {
    try {
      Map<String, String> params = {
        "first_name": "$name",
        "last_name": "$lastname",
        "email": "$email",
        "password": "$password",
        "phone": "$phone",
        "DocumentType": "$documentType",
        "IdentificationCard": "$identificationCard"
      };

      final resp =
          await this._dio.post(_baseUrl + "/RequestUsersWebServer/registration",
              options: Options(
                  headers: {
                    HttpHeaders.contentTypeHeader: "application/json",
                    HttpHeaders.authorizationHeader: basicAuth,
                    "X-API-KEY": dotenv.env['X-API-KEY']
                  },
                  followRedirects: false,
                  validateStatus: (status) {
                    return status < 600;
                  }),
              data: jsonEncode(params));

      if (resp.statusCode >= 200 && resp.statusCode < 250) {
        if (resp.data['status']) {
          return {"OK": true, "mensaje": ''};
        } else {
          return {"OK": false, "mensaje": resp.data['message']};
        }
      } else {
        return {"OK": false, "mensaje": resp.data};
      }
    } on DioError catch (e) {
      print(e.error);
      return {"OK": false, "mensaje": "Error al ingresar a la aplicacion"};
    }
  }

  Future<DocumentsTypes> documenttype() async {
    try {
      final resp = await this._dio.get(
            _baseUrl + "/RequestUsersWebServer/documenttype",
            options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: basicAuth,
                "X-API-KEY": dotenv.env['X-API-KEY']
              },
              followRedirects: false,
              validateStatus: (status) {
                return status < 600;
              },
            ),
          );

      if (resp.statusCode >= 200 && resp.statusCode < 250) {
        if (resp.data['status']) {
          return DocumentsTypes.fromJson(resp.data);
        }
      }
      return null;
    } on DioError catch (e) {
      print(e.error);
      return null;
    }
  }
  Future<Profile> userProfile(id) async {

    try {
      final resp = await this._dio.get(
        _baseUrl + "/RequestUsersWebServer/userprofile/id/" + id,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: basicAuth,
            "X-API-KEY": dotenv.env['X-API-KEY']
          },
          followRedirects: false,
          validateStatus: (status) {
            return status < 600;
          },
        ),
      );

      if (resp.statusCode >= 200 && resp.statusCode < 250) {
        if (resp.data['status']) {
          Map<String, dynamic> data;
          final jwt = preferenceStorage.getValue(key: "currentUser");
          Profile userPro;
          if (jwt != null) {
            data = json.decode(jwt);
            userPro = Profile.fromJson(data);
          }

          return userPro;
        }
      }
      return null;
    } on DioError catch (e) {
      print(e.error);
      return null;
    }
  }
  Future<User> currentUser() async {
    return this.getUserLogged();
  }

  User getUserLogged() {
    Map<String, dynamic> data;
    final jwt = preferenceStorage.getValue(key: "currentUser");
    User user;
    if (jwt != null) {
      data = json.decode(jwt);
      user = User.fromJson(data);
    }

    return user;
  }

  static Future<bool> loggedUser() async {
    PreferenceStorage preferenceStorage = PreferenceStorage();
    final jwt = preferenceStorage.getValue(key: "currentUser");

    if (jwt != null) {
      return true;
    }
    return false;
  }

  Future<bool> logout() async {
    return await preferenceStorage.deleteValue(key: "currentUser");
  }

  Future<Map<String, dynamic>> passreset(
      {String email, String identificationCard}) async {
    try {
      Map<String, String> params = {
        "email": "$email",
        "IdentificationCard": "$identificationCard"
      };

      final resp = await this._dio.post(
          _baseUrl + "/RequestUsersWebServer/passreset",
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: basicAuth,
              "X-API-KEY": dotenv.env['X-API-KEY']
            },
            followRedirects: false,
            validateStatus: (status) {
              return status < 600;
            },
          ),
          data: jsonEncode(params));

      if (resp.statusCode >= 200 && resp.statusCode < 250) {
        if (resp.data['status']) {
          return {"OK": true, "mensaje": resp.data['message']};
        }
      }
      return {"OK": false, "mensaje": resp.data['message']};
    } on DioError catch (e) {
      print(e.error);
      return {"OK": false, "mensaje": e.message};
    }
  }

  Future<Map<String, dynamic>> changepass({String id, String password}) async {
    try {
      Map<String, String> params = {"id": "$id", "password": "$password"};

      final resp = await this._dio.put(
          // https://webapi.asdn.gob.do/RequestUsersWebServer/passreset
          _baseUrl + "/RequestUsersWebServer/changepass",
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: basicAuth,
              "X-API-KEY": dotenv.env['X-API-KEY']
            },
            followRedirects: false,
            validateStatus: (status) {
              return status < 600;
            },
          ),
          data: jsonEncode(params));

      if (resp.statusCode >= 200 && resp.statusCode < 250) {
        if (resp.data['status']) {
          return {"OK": true, "mensaje": resp.data['message']};
        }
      }
      return null;
    } on DioError catch (e) {
      print(e.error);
      return null;
    }
  }
}
