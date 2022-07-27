import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  BitmapDescriptor? _pinLocationIcon;
  Map<MarkerId, Marker>? _markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> get markers => _markers!;
  final MarkerId markerId = const MarkerId("1");

  GoogleMapController? _mapController;
  GoogleMapController get mapController => _mapController!;

  final Location _location = Location();
  Location get location => _location;
  BitmapDescriptor get pinLocationIcon => _pinLocationIcon!;

  LatLng? _locationPosition;
  get locationPosition => _locationPosition;

  initialization() async {
    await getUserLocation();
    await setCustomMapPin();
  }

  getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.onLocationChanged.listen(
      (LocationData currentLocation) {
        _locationPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
        notifyListeners();
        print(_locationPosition.toString() + 'hellllllllllllllll');

        _markers!.clear();

        Marker marker = Marker(
          markerId: markerId,
          position: LatLng(
            _locationPosition!.latitude,
            _locationPosition!.longitude,
          ),
          icon: pinLocationIcon,
          draggable: true,
          onDragEnd: ((newPosition) {
            _locationPosition = LatLng(
              newPosition.latitude,
              newPosition.longitude,
            );

            // notifyListeners();
          }),
        );

        _markers![markerId] = marker;

        notifyListeners();
      },
    );
  }

  setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  setCustomMapPin() async {
    _pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/destination_map_marker.png',
    );
  }

  takeSnapshot() {
    return _mapController!.takeSnapshot();
  }
}
