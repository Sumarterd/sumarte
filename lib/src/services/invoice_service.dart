import 'dart:convert';
import 'dart:io';
import 'package:sumarte/src/models/HistoryPayment.dart';
import 'package:sumarte/src/models/PaymentResponse.dart';
import 'package:sumarte/src/models/UserTransneg.dart';
import 'package:sumarte/src/models/user.dart';
import 'package:sumarte/src/share_prefs/preferences_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InvoiceService {
  static final InvoiceService _instancia = new InvoiceService._internal();

  final String _baseUrlInvoces = dotenv.env['BASE_URL_INVOICE'];
  final String _idPuntoDeVenta = dotenv.env['BASE_PUNTO_VENTA'];
  final String _baseUrl = dotenv.env['BASE_URL'];
  final String _servicio = dotenv.env['BASE_SERVICIO'];
  final _dio = new Dio();
  PreferenceStorage preferenceStorage = PreferenceStorage();
  String basicAuth = 'Basic ' +
      base64Encode(
          utf8.encode(dotenv.env['USERNAME'] + ':' + dotenv.env['PASSWORD']));

  factory InvoiceService() {
    return _instancia;
  }

  InvoiceService._internal();

  void sendDataLogPaymentTrans(Map<String, dynamic> data, double amount) async {
    final currentUser = preferenceStorage.getValue(key: "currentUser");
    final user = json.decode(currentUser);
    data['montoPagado'] = amount;
    data['usuarioCreacion'] = user['id'];

    await this._dio.post(
          _baseUrl + "/CarnetWebServer/insertlogpaymenttrans",
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
          data: data,
        );
  }

  Future<PaymentResponse> savePayments(
      Map<String, dynamic> dataCard, String invoiceNumber) async {
    PaymentResponse paymentResponse;
    var method = "";
    var idFactura = "";
    var comercio = "";
    var facturador = "";
    var idTransaccion = "";
    var montoPago = "";
    var modoPago = "";
    var documentoPago = "";
    var referenciaPago = "";
    if (invoiceNumber == "0") {
      method = "aplicar_pago";
      facturador = "facturador";
      idFactura = "&";
      comercio = "id_comercio";
      idTransaccion = "id_transaccion";
      montoPago = "monto_pago";
      modoPago = "modo_pago";
      documentoPago = "documento_pago";
      referenciaPago = "referencia_pago";
    } else {
      method = "aplicar_pago_factura";
      comercio = "idPuntoDeVenta";
      facturador = "servicio";
      idTransaccion = "idTransaccion";
      montoPago = "&montoPago";
      modoPago = "modo";
      documentoPago = "documentoPago";
      referenciaPago = "referenciaPago";
      idFactura = "&idFactura=${dataCard['invoice-number']}";
    }
    var cardNumber = dataCard['card-number'].toString();
    var lastNumCard = cardNumber.substring(cardNumber.length - 4);
    var customer = dataCard['reference-number'].toString().split(',');
    var uri = _baseUrlInvoces +
        method +
        "?" +
        comercio +
        "=" +
        _idPuntoDeVenta +
        "&" +
        facturador +
        "=" +
        _servicio +
        "&" +
        idTransaccion +
        "=" +
        customer[1] +
        "&cliente=" +
        customer[0] +
        idFactura +
        montoPago +
        "=" +
        dataCard['amount'].toString() +
        "&" +
        modoPago +
        "=TarjetaCredito&" +
        referenciaPago +
        "=Pago&" +
        documentoPago +
        "=" +
        lastNumCard +
        "&adquiriente=Cardnet";

    final resp = await this._dio.post(uri,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            //HttpHeaders.authorizationHeader: bearerAuth,
          },
          followRedirects: false,
          validateStatus: (status) {
            return status < 600;
          },
        ));
    if (resp.statusCode >= 200 && resp.statusCode < 250) {
      sendDataLogPaymentTrans(resp.data, dataCard['amount']);
      paymentResponse = PaymentResponse.fromJson(resp.data);
      return paymentResponse;
    }
    return null;
  }

  Future<UserTransneg> getInvocesPendding({User user}) async {
    try {
      UserTransneg userTransneg;
      var uri = _baseUrlInvoces +
          "consultar_cedula?idPuntoDeVenta=" +
          _idPuntoDeVenta +
          "&servicio=" +
          _servicio +
          "&cedula=102098126"; //+ user.identificationCard;
      final resp = await this._dio.get(uri,
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              //HttpHeaders.authorizationHeader: basicAuth,
              "X-API-KEY": dotenv.env['X-API-KEY']
            },
            followRedirects: false,
            validateStatus: (status) {
              return status < 600;
            },
          ));
      if (resp.statusCode >= 200 && resp.statusCode < 250) {
        if (resp.data['contratosAsociados'] != null) {
          userTransneg = UserTransneg.fromJson(resp.data);
        } else {
          var data = resp.data;
          userTransneg = UserTransneg.fromJson({
            'codigoRespuesta': data['codigoRespuesta'],
            'descripcionRespuesta': data['descripcionRespuesta'],
            'nombreTitular': data['nombreTitular'],
            'cantidadContratosAsociados': data['cantidadContratosAsociados'],
            'contratosAsociados': [],
            'montoAdeudado': data['montoAdeudado'],
          });
        }
        return userTransneg;
      } else {
        print("Error del servidor.");
      }
      return userTransneg;
    } on DioError catch (e) {
      print(e.error);
      return null;
    }
  }

  Future<Map<String, dynamic>> getPaymentHistory(
      {String userId, String code}) async {
    try {
      final List<HistoryPayment> historyPayment = [];
      final resp = await this._dio.get(
            _baseUrl +
                "/CarnetWebServer/getpaymenthistory/id/" +
                userId +
                "/code/" +
                code,
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
        if (resp.data['data'].length > 0) {
          for (var item in resp.data['data']) {
            historyPayment.add(HistoryPayment.fromJson(item));
          }
        }

        return {"OK": true, "data": historyPayment};
      }

      return {"OK": false, "mensaje": "No se encontraron facturas."};
    } on DioError catch (e) {
      print(e.error);
      return {"OK": false, "mensaje": "Error al obtener la facturas."};
    }
  }
}
