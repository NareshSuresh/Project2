import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/utils.dart';
import 'package:weather_app/view_model/controller/global_controller.dart';

class AppbarWidget extends StatefulWidget {
  const AppbarWidget({super.key});

  @override
  State<AppbarWidget> createState() => _AppbarWidgetState();
}

class _AppbarWidgetState extends State<AppbarWidget> {
  final GlobalController globalController = Get.put(GlobalController());

  @override
  void initState() {
    super.initState();
    getAddress(
      globalController.getLatitude().value,
      globalController.getLongitude().value,
    );
  }

  Future<void> getAddress(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      Placemark place = placemarks[0];
      globalController.city.value = place.locality ?? "Unknown City";
    } catch (e) {
      print('Error fetching address: $e');
      globalController.city.value = "Unknown City";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use Obx to listen for changes in the city name
          Obx(() {
            return Text(
              globalController.city.value,
              style: mediumTextStyle,
            );
          }),
          Text(
            Utils.date,
            style: lightTitleTextStyle,
          ),
        ],
      ),
    );
  }
}

