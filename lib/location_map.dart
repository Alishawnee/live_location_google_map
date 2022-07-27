import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'location_provider.dart';

class LocationMap extends StatefulWidget {
  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map Live Tracking"),
        backgroundColor: Colors.redAccent,
      ),
      body: googleMapUI(),
      //     body: Column(
      //       children: [
      //         //_searchBar(),
      //         Expanded(
      //           child: GoogleMap(
      //             mapType: MapType.satellite,
      //             myLocationEnabled: true,
      //             myLocationButtonEnabled: true,
      //             initialCameraPosition: CameraPosition(
      //               target: LatLng(28.7041, 77.1025),
      //               zoom: 18,
      //             ),
      //             onMapCreated: (GoogleMapController controller) async {},
      //           ),
      //         ),
      //       ],
      //     ),
    );
  }

  Widget googleMapUI() {
    return Consumer<LocationProvider>(builder: (consumerContext, model, child) {
      return model.locationPosition != null
          ? GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: model.locationPosition,
                zoom: 18,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(model.markers.values),
              onMapCreated: (GoogleMapController controller) async {
                Provider.of<LocationProvider>(context, listen: false)
                    .setMapController(controller);
              },
            )
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
    });
  }
}
