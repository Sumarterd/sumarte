import 'package:sumarte/src/models/search_response_places.dart';
import 'package:sumarte/src/models/search_result.dart';
import 'package:sumarte/src/services/google_maps_services.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchDestino extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;

  final GoogleMapService _googlemapservice;
  final LatLng proximidad;
  final List<SearchResult> history;

  SearchDestino({this.proximidad, this.history})
      : this.searchFieldLabel = 'Buscar...',
        this._googlemapservice = new GoogleMapService();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => this.query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => this.close(context, SearchResult(canceled: true)));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (this.query.length == 0) {
      return ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Colocar ubicacion manualmente'),
            onTap: () {
              this.close(
                  context,
                  SearchResult(
                      canceled: false,
                      manualUbication: true,
                      scrollGesturesEnabled: true));
            },
          ),
          ...this
              .history
              .map((result) => ListTile(
                    leading: Icon(Icons.history),
                    title: Text(result.nombreDestino),
                    subtitle: Text(result.description),
                    onTap: () {
                      SearchResult r = result.copyWith(
                          manualUbication: true, scrollGesturesEnabled: false);
                      this.close(context, r);
                    },
                  ))
              .toList()
              .reversed,
        ],
      );
    }

    return this._buildResultsSuggestions();
  }

  Widget _buildResultsSuggestions() {
    if (this.query.length == 0) {
      return Container();
    }
// this._trafficService.getResultsByQuery(this.query.trim(), proximidad),
    this._googlemapservice.getSuggestionByQuery(this.query.trim());

    return StreamBuilder(
      stream: this._googlemapservice.suggestionsStream,
      builder: (context, AsyncSnapshot<SearchResponsePlaces> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final places = snapshot.data.results;

        if (places.length == 0) {
          return ListTile(title: Text('No hay resultados con $query'));
        }
        return ListView.separated(
          separatorBuilder: (_, i) => Divider(),
          itemCount: places.length,
          itemBuilder: (_, index) {
            final place = places[index];
            return ListTile(
              leading: Icon(Icons.place),
              title: Text(place.formattedAddress),
              subtitle: Text(place.name),
              onTap: () {
                this.close(
                  context,
                  SearchResult(
                      canceled: false,
                      manualUbication: true,
                      scrollGesturesEnabled: false,
                      positionDestination: LatLng(place.geometry.location.lat,
                          place.geometry.location.lng),
                      nombreDestino: place.formattedAddress,
                      description: place.name),
                );
              },
            );
          },
        );
      },
    );
  }
}
