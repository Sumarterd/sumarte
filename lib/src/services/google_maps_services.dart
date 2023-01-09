import 'dart:async';

import 'package:sumarte/src/helpers/helpers.dart';
import 'package:sumarte/src/models/search_response_geolocation.dart';
import 'package:sumarte/src/models/search_response_places.dart';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapService {
  final String _baseUrl = 'https://maps.googleapis.com/maps/api/';
  final String _apiKey = 'AIzaSyA9QnDhE4COEgNMvkWkZf3Lr0gGZaWc2jc';

//https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyA9QnDhE4COEgNMvkWkZf3Lr0gGZaWc2jc&latlng=18.557815312838596,-69.86141212284565

//https://maps.googleapis.com/maps/api/place/textsearch/json?query=juan%20donator&key=AIzaSyA9QnDhE4COEgNMvkWkZf3Lr0gGZaWc2jc
  final _dio = new Dio();

  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));

  final _suggestionsStreamController =
      StreamController<SearchResponsePlaces>.broadcast();

  GoogleMapService._privateConstrunctor();

  static final _instance = GoogleMapService._privateConstrunctor();

  factory GoogleMapService() {
    return _instance;
  }

  Stream<SearchResponsePlaces> get suggestionsStream =>
      _suggestionsStreamController.stream;

  void getSuggestionByQuery(String search) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resultados = await this.getResultsByQuery(search);
      this._suggestionsStreamController.add(resultados);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = search;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel());
  }

  Future<SearchResponsePlaces> getResultsByQuery(String search) async {
    try {
      final url = '${this._baseUrl}place/textsearch/json';
      final resp = await this._dio.get(url, queryParameters: {
        'key': this._apiKey,
        'query': search,
        'region': 'do',
        'language': 'es'
      });
      final data = resp.data;

      return SearchResponsePlaces.fromJson(data);
    } catch (e) {
      return SearchResponsePlaces(results: []);
    }
  }

  Future<SearchResponseGeolocation> getCoordInfo(LatLng coords) async {
    try {
      final url = '${this._baseUrl}geocode/json';
      final resp = await this._dio.get(url, queryParameters: {
        'key': this._apiKey,
        'language': 'es',
        'latlng': '${coords.latitude},${coords.longitude}',
        'result_type': 'route'
      });

      final data = SearchResponseGeolocation.fromJson(resp.data);

      return data;
    } catch (e) {
      return SearchResponseGeolocation(results: []);
    }
  }

  void dispose() {
    _suggestionsStreamController?.close();
  }
}
