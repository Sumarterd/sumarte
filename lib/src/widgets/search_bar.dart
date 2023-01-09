part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (BuildContext context, state) {
        return state.seleccionManual
            ? Container()
            : FadeInDown(
                child: buildSearchBar(context),
                duration: Duration(milliseconds: 300),
              );
      },
    );
  }

  Widget buildSearchBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: size.width,
        child: GestureDetector(
          onTap: () async {
            final resultado = await showSearch(
                context: context,
                delegate: SearchDestino(
                    history: context.read<SearchBloc>().state.history,
                    proximidad: context.read<MapBloc>().state.ubicacion));

            retornoBusqueda(context, resultado);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: double.infinity,
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lugar que desea reportar?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
                Icon(Icons.search)
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: new Offset(0, 5),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> retornoBusqueda(
      BuildContext context, SearchResult result) async {
    if (result.canceled) return;

    if (result.scrollGesturesEnabled == false) {
      context.read<MapBloc>().add(OnStopMap());
    }

    if (result.positionDestination != null) {
      context.read<MapBloc>().moveCamera(result.positionDestination);
    }

    if (result.manualUbication) {
      context.read<SearchBloc>().add(OnActivarMarcadorManual());
      return;
    }
  }
}
