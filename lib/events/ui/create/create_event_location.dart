import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/geolocation.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:ticketing/events/ui/create/bloc/crate_event_state.dart';
import 'package:ticketing/events/ui/create/bloc/create_event_cubit.dart';
import 'package:ticketing/events/ui/create/create_event_app_bar.dart';
import 'package:ticketing/events/ui/create/create_event_next_button.dart';
import 'package:ticketing/events/ui/create/create_event_type.dart';

class CreateEventLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createEventAppBar(context),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                color: Theme.of(context).primaryColor,
                child: _SearchBar(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Where will your event happen?',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Container()),
                  ],
                ),
              )
            ],
          ),
          createEventPositionedNextButton(context, _navigateToCreateEventType),
        ],
      ),
    );
  }

  void _navigateToCreateEventType(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => CreateEventType()));
  }
}

const _kGoogleApiKey = 'AIzaSyB55b7VQXflfiPZuDMLSj6uInpapJgFVBY';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: _kGoogleApiKey);

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
        builder: (context, state) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              key: const Key('loginForm_emailInput_textField'),
              onTap: () async {
                final prediction = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: _kGoogleApiKey,
                    mode: Mode.overlay,
                    language: 'en',
                    components: [Component(Component.country, "et")]);

                if (prediction != null) {
                  PlacesDetailsResponse detail =
                      await _places.getDetailsByPlaceId(prediction.placeId);
                  final lat = detail.result.geometry.location.lat;
                  final lng = detail.result.geometry.location.lng;
                  context.read<CreateEventCubit>().onLocationChanged(lat, lng);
                }
              },
              onChanged: (query) {},
              decoration: InputDecoration(
                filled: true,
                hintText: 'Search Location',
                hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5), fontSize: 14),
                suffixIcon: Icon(Icons.mic, color: Colors.grey),
                prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.search, color: Colors.grey)),
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                focusedBorder: OutlineInputBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(50)),
                    borderSide:
                        BorderSide(width: 0, color: Colors.transparent)),
                enabledBorder: OutlineInputBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(50)),
                    borderSide:
                        BorderSide(width: 0, color: Colors.transparent)),
              ),
            ),
          ),
        ),
      );
    });
    /*return ;*/
  }
}

// class _Map extends StatelessWidget {
//   final GlobalKey<GoogleMapStateBase> _key = GlobalKey<GoogleMapStateBase>();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CreateEventCubit, CreateEventState>(
//       builder: (context, state) {
//         final location = state.location ?? {};
//         if (location["lat"] == null || location["lng"] == null)
//           return Container();

//         final markers = Set<Marker>();
//         markers.add(Marker(GeoCoord(location["lat"], location["lng"])));

//         return Container(
//             width: double.infinity,
//             height: 300,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(3))),
//             child: GoogleMap(
//               key: _key,
//               initialZoom: 16,
//               markers: markers,
//               interactive: true,
//               onTap: (GeoCoord coordinate) {
//                 context.read<CreateEventCubit>().onLocationChanged(
//                     coordinate.latitude, coordinate.longitude);
//                 markers.clear();
//                 markers.add(Marker(
//                     GeoCoord(coordinate.latitude, coordinate.longitude)));
//               },
//               initialPosition: GeoCoord(location["lat"], location["lng"]),
//             ));
//       },
//     );
//   }
// }
