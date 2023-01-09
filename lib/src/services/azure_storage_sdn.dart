import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:azblob/azblob.dart';
import 'package:mime/mime.dart';
// import 'package:http/http.dart' as http;

class AzureStorageSdn {
  static final AzureStorageSdn _instancia = new AzureStorageSdn._internal();

  factory AzureStorageSdn() {
    return _instancia;
  }

  AzureStorageSdn._internal();

  Future uploadImageToAzure(
      BuildContext context, File _imageFile, String imageName) async {
    try {
      String fileName = basename(_imageFile.path);
      // read file as Uint8List
      // Uint8List content = await _imageFile.readAsBytes();
      final fileBytes = _imageFile.readAsBytesSync();

      String contentType = lookupMimeType(fileName);

      final storage = AzureStorage.parse(dotenv.env['CONNECTION_STRING']);

      String container = "imagemobile";
      // final res = await storage.getBlob(
      //     "/imagemobile/240519080_10159259626836469_3049094747712659905_n.jpg");
      await storage.putBlob('/$container/$imageName',
          bodyBytes: fileBytes,
          contentType: contentType,
          type: BlobType.BlockBlob);
      // http.Response.fromStream(res).then((response) {
      //   print("Uploaded! ");
      //   print('response.body ' + response.body);
      // });
      // print();
    } on AzureStorageException catch (ex) {
      print(ex.message);
    } catch (err) {
      print(err);
    }
  }
}
