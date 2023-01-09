part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (BuildContext context, state) {
      return state.seleccionManual ? _BuildMardadorManual() : Container();
    });
  }
}

class _BuildMardadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _btnRegresar(context),
        _puntoCentral(),
        _confirmarDestino(context)
      ],
    );
  }

  Widget _btnRegresar(BuildContext context) {
    return Positioned(
      top: 70,
      left: 20,
      child: FadeInLeft(
        duration: Duration(milliseconds: 300),
        child: CircleAvatar(
          maxRadius: 25,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              BlocProvider.of<SearchBloc>(context)
                  .add(OnDesActivarMarcadorManual());
              context.read<MapBloc>().add(OnStartMap());
            },
          ),
        ),
      ),
    );
  }

  Widget _puntoCentral() {
    return Center(
      child: Transform.translate(
        offset: new Offset(0, -18),
        child: BounceInDown(
          from: 200,
          child: Icon(Icons.location_on, size: 50, color: Constants.orangeDark),
        ),
      ),
    );
  }

  Positioned _confirmarDestino(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Positioned(
      child: FadeInUp(
          duration: Duration(milliseconds: 300),
          child: BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              if (state.isOutOfRange) {
                return MaterialButton(
                    child: Text('Fuera de Rango',
                        style: TextStyle(color: Colors.white)),
                    color: Colors.red,
                    shape: StadiumBorder(),
                    elevation: 5,
                    splashColor: Colors.transparent,
                    minWidth: width - 120,
                    onPressed: () {});
              }
              return MaterialButton(
                  child: Text('Confirmar ubicacion',
                      style: TextStyle(color: Colors.white)),
                  color: Constants.orangeDark,
                  shape: StadiumBorder(),
                  elevation: 5,
                  splashColor: Colors.transparent,
                  minWidth: width - 120,
                  onPressed: () {
                    calculandoAlerta(context);
                    this.calcularDestino(context);
                  });
            },
          )),
      bottom: 70,
      left: 40,
    );
  }

  void calcularDestino(BuildContext context) async {
    final googleMapService = new GoogleMapService();
    // final begin = context.read<MapBloc>().state.ubicacion;
    final end = context.read<MapBloc>().state.ubicacionCentral;
    //Obtener Informacion  Destino
    final reverseQueryResponse = await googleMapService.getCoordInfo(end);

    final featureDestino = reverseQueryResponse.results[0];
    final nombreDestino = featureDestino.formattedAddress;

    BlocProvider.of<SearchBloc>(context).add(OnDesActivarMarcadorManual());

    Navigator.of(context).pop();

    BlocProvider.of<SearchBloc>(context).add(OnAddHistory(SearchResult(
        canceled: false,
        manualUbication: true,
        nombreDestino: nombreDestino,
        positionDestination: LatLng(
            featureDestino.geometry.location.lat.toDouble(),
            featureDestino.geometry.location.lng.toDouble()),
        description: featureDestino.formattedAddress)));

    context.read<MapBloc>().add(OnStartMap());

    Navigator.of(context).pop(featureDestino);
  }
}
