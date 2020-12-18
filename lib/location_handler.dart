import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_location/location/hwlocation.dart';
import 'package:huawei_location/location/location_request.dart';
import 'package:huawei_location/permission/permission_handler.dart';

class LocationHandler {
  PermissionHandler permissionHandler;
  FusedLocationProviderClient locationService;
  LocationRequest locationRequest;

  int requestCode = 0;

  LocationHandler() {
    // init services
    locationService = FusedLocationProviderClient();
    permissionHandler = PermissionHandler();
    locationRequest = LocationRequest();
    locationRequest.interval = 5000;
    locationRequest.numUpdates = 5;
  }

  Future<bool> hasPermission() async {
    bool status = false;
    try {
      status = await permissionHandler.hasLocationPermission();
      print("Has permission: $status");
    } catch (e) {
      print(e.toString());
    }
    return status;
  }

  Future<HWLocation> getLastLocationWithAddress() async {
    HWLocation hwLocation;
    try {
      hwLocation =
          await locationService.getLastLocationWithAddress(locationRequest);

      print(hwLocation.toString());
    } catch (e) {
      print(e.toString());
    }

    return hwLocation;
  }

  void requestLocationUpdates() async {
    try {
      requestCode =
          await locationService.requestLocationUpdates(locationRequest);

      print(
          "Location updates requested successfully " + requestCode.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  void removeLocationUpdates() async {
    try {
      await locationService.removeLocationUpdates(requestCode);
      requestCode = null;
      print("Location updates are removed successfully");
    } catch (e) {
      print(e.toString());
    }
  }

  void requestPermission() async {
    try {
      bool status = await permissionHandler.requestLocationPermission();
      print("Is permission granted $status");
    } catch (e) {
      print(e.toString());
    }
  }
}
