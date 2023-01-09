import 'package:sumarte/src/bloc/map/map_bloc.dart';
import 'package:sumarte/src/bloc/search/search_bloc.dart';

import 'package:sumarte/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatefulWidget {
  static final routeName = '/map';
  const MapaPage({Key key}) : super(key: key);

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  MapBloc _mapBloc;
  @override
  void initState() {
    _mapBloc = BlocProvider.of<MapBloc>(context);
    _mapBloc.iniciarSeguimiento();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final MapBloc mapBloc = BlocProvider.of<MapBloc>(context);
    setState(() {
      _mapBloc = mapBloc;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _mapBloc.cancelarSeguimiento();
    _mapBloc.add(OnExitMap());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MapBloc, MapState>(
            builder: (_, state) {
              return createMap(state);
            },
          ),
          Positioned(top: 15, child: SearchBar()),
          MarcadorManual(),
        ],
      ),
      floatingActionButton: BlocBuilder<SearchBloc, SearchState>(
          builder: (BuildContext context, state) {
        return !state.seleccionManual
            ? Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FloatingActionButton(
                          heroTag: 'location',
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            context
                                .read<SearchBloc>()
                                .add(OnActivarMarcadorManual());
                            _mapBloc.moveCamera(_mapBloc.state.ubicacion);
                          },
                        ),
                        SizedBox(height: 10),
                        FloatingActionButton(
                          child: Icon(
                            FontAwesome.location_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            context
                                .read<SearchBloc>()
                                .add(OnActivarMarcadorManual());
                            _mapBloc.moveCamera(_mapBloc.state.ubicacion);
                            _mapBloc.add(OnStopMap());
                          },
                        ),
                        SizedBox(height: 10),
                        FloatingActionButton(
                          elevation: 1,
                          heroTag: 'exit',
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Container();
      }),
    );
  }

  Widget createMap(MapState state) {
    if (!state.existeUbicacion) return Center(child: Text('Localizando .....'));

    _mapBloc.add(OnLocationUpdate(state.ubicacion));

    final cameraPosition = new CameraPosition(
        target: state.ubicacion, zoom: state.mapaSize, tilt: 0.0);

    return GoogleMap(
      scrollGesturesEnabled: state.scrollGesturesEnabled,
      initialCameraPosition: cameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      onMapCreated: _mapBloc.initMap,
      onCameraMove: (CameraPosition cameraPosition) async {
        double northeastLat = 18.7148127;
        double northeastLng = -69.78639129999999;
        double southwestLat = 18.5095789;
        double southwestLng = -70.0411441;

        if ((cameraPosition.target.longitude <= northeastLng &&
                cameraPosition.target.latitude <= northeastLat) &&
            (cameraPosition.target.longitude >= southwestLng &&
                cameraPosition.target.latitude >= southwestLat)) {
          _mapBloc.add(OutOfRange(false));
        } else {
          _mapBloc.add(OutOfRange(true));
        }

        _mapBloc.add(OnMoveMap(cameraPosition.target));
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
