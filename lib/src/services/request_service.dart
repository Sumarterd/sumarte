import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:sumarte/src/helpers/helpers.dart';
import 'package:sumarte/src/models/Profile.dart';
import 'package:sumarte/src/models/Request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class RequestService {
  static final RequestService _instancia = new RequestService._internal();
  final String _baseUrl = dotenv.env['BASE_URL'];
  final _dio = new Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));
  String basicAuth = 'Basic ' +
      base64Encode(
          utf8.encode(dotenv.env['USERNAME'] + ':' + dotenv.env['PASSWORD']));

  factory RequestService() {
    return _instancia;
  }

  RequestService._internal();

  Future<List<dynamic>> requesttype() async {
    try {
      final resp =
          await this._dio.get(_baseUrl + "/RequestWebServer/requesttype",
              options: Options(
                  headers: {
                    HttpHeaders.contentTypeHeader: "application/json",
                    HttpHeaders.authorizationHeader: basicAuth,
                    "X-API-KEY": dotenv.env['X-API-KEY']
                  },
                  followRedirects: false,
                  validateStatus: (status) {
                    return status < 600;
                  }));

      if (resp.statusCode >= 200 && resp.statusCode < 250) {
        if (resp.data['status'] == true) {
          return resp.data['data'];
        }
      }
      return null;
    } on DioError catch (e) {
      print(e.error);
      return null;
    }
  }

  Future<bool> requestinsert(
      Map<String, dynamic> data, List<String> images) async {
    try {
      Map<String, String> fileMap = {};

      int i = 1;
      images.forEach((image) async {
        // final bytes = File(image.path).readAsBytesSync();
        // String img64 = base64Encode(bytes);
        fileMap[i.toString()] = image;
        i++;
      });

      data['RequestImages'] = fileMap;

      var formData = FormData.fromMap(data);
      final resp = await _dio.post(_baseUrl + '/RequestWebServer/insertrequest',
          data: formData,
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: basicAuth,
                "X-API-KEY": dotenv.env['X-API-KEY']
              },
              followRedirects: false,
              validateStatus: (status) {
                return status < 600;
              }));

      if (resp.data['status']) {
        return true;
      }
      return false;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> getRequest({String idUsuario}) async {
    try {
      final List<Request> requests = [];
      final resp = await this._dio.get(
            _baseUrl + "/RequestWebServer/getrequestuser/user/" + idUsuario,
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
        if (resp.data['status'] == false) {
          return {
            "OK": false,
            "mensaje": resp.data['message'],
          };
        }

        if (resp.data['data'].length > 0) {
          for (var item in resp.data['data']) {
            item["images"] = await this
                .getPostImageRequest(idRequest: item["ReclamacionId"]);
            requests.add(Request.fromJson(item));
          }
        }
        return {"OK": true, "data": requests};
      }
      return {"OK": false, "mensaje": "No existe ninguna solicitud pendiente"};
    } on DioError catch (e) {
      print(e.error);
      return {"OK": false, "mensaje": "Error obtener las solictudes"};
    }
  }

  Future<List<String>> getPostImageRequest({String idRequest}) async {
    try {
      final List<String> images = [];

      final resp = await this._dio.get(
            _baseUrl + "/RequestWebServer/getimagebyrequest/id/" + idRequest,
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
        if (resp.data['status'] == true) {
          if (resp.data['data'].length > 0) {
            for (var image in resp.data['data']) {
              images.add(image['Imagen']);
            }
          }
        }
      }
      return images;
    } on DioError catch (e) {
      print(e.error);
      return null;
    }
  }

  Future<List<Image>> getImageRequest({String idRequest}) async {
    try {
      final List<Image> images = [];
      final resp = await this._dio.get(
            _baseUrl + "/RequestWebServer/getimagebyrequest/id/" + idRequest,
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
        if (resp.data['status'] == true) {
          if (resp.data['data'].length > 0) {
            for (var item in resp.data['data']) {
              images.add(Image(image: imageFromBase64String(item['Imagen'])));
            }
          }
        }
      }
      return images;
    } on DioError catch (e) {
      print(e.error);
      return [];
    }
  }

  ImageProvider imageFromBase64String(String base64String) {
    return MemoryImage(base64Decode(base64String));
    // return Image.memory(
    //   base64Decode(base64String),
    //   fit: BoxFit.fitWidth,
    //   width: double.infinity,
    // );
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }


  Future<bool> saveprofile(Map<String, dynamic> data) async {
    try {
      var formData = Profile.fromJson(data);

      final resp = await _dio.post(_baseUrl + '/RequestWebServer/saveprofile',
          data: formData,
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: basicAuth,
                "X-API-KEY": dotenv.env['X-API-KEY']
              },
              followRedirects: false,
              validateStatus: (status) {
                return status < 600;
              }));

      if (resp.data['status']) {
        return true;
      }
      return true;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }
}
