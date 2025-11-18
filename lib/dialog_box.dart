import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:todo_app/my_buttons.dart';

class DialogBox extends StatelessWidget {
  final controller;
  Function(String?) onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[200],
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //get user input
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
              ),
            ),

            //space btw textfield and buttons
            SizedBox(
              height: 8,
            ),

            //buttons -> save and cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //save button
                MyButtons(
                  text: "Save",
                  onPressed: () async {
                    // Get current location and address
                    String? locationAddress;
                    try {
                      // Request location permission
                      LocationPermission permission = await Geolocator.requestPermission();
                      if (permission == LocationPermission.denied) {
                        // Permission denied, save without location
                        onSave(null);
                        return;
                      }

                      // Get current position
                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);

                      // Get address from coordinates
                      List<Placemark> placemarks = await placemarkFromCoordinates(
                          position.latitude, position.longitude);

                      if (placemarks.isNotEmpty) {
                        Placemark place = placemarks.first;
                        // Build Chinese address
                        locationAddress = [
                          place.administrativeArea,
                          place.locality,
                          place.subLocality,
                          place.thoroughfare,
                        ].where((part) => part != null && part.isNotEmpty).join(" ");
                      }
                    } catch (e) {
                      // Handle any errors
                      print("Error getting location: $e");
                    }
                    onSave(locationAddress);
                  },
                ),

                SizedBox(
                  width: 10,
                ),
                //cancel button
                MyButtons(
                    text: "Cancel",
                    onPressed: onCancel),
              ],
            )
          ],
        ),
      ),
    );
  }
}
