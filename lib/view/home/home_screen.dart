import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/utils/utils.dart';
import 'package:weather_app/view/home/widgets/appbar_widget.dart';
import 'package:weather_app/view/home/widgets/current_temp_widget.dart';
import 'package:weather_app/view/home/widgets/footer_widget.dart';
import 'package:weather_app/view/home/widgets/info_widget.dart';
import 'package:weather_app/view_model/controller/global_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalController globalController = Get.put(GlobalController());
  final TextEditingController cityController = TextEditingController();

  Future<void> _refreshData() async {
    await globalController.getLocationAndFetchWeather();
  }

  void _fetchWeatherByCity(String cityName) async {
    if (cityName.isEmpty) return;

    try {
      await globalController.fetchWeatherByCity(cityName);
    } catch (error) {
      Get.snackbar(
        "Error",
        "Failed to fetch weather data for $cityName. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator.adaptive(
        onRefresh: _refreshData,
        child: Obx(
              () => globalController.checkLoading().isTrue
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Container(
            decoration: BoxDecoration(
              gradient:
              Utils.getBackgroundGradient(globalController.weatherMain),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: const [
                  AppbarWidget(),
                  CurrentTempWidget(),
                  InfoWidget(),
                  FooterWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Weather App",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: "Enter a city",
                    icon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: Colors.black26),
                  ),
                  style: const TextStyle(color: Colors.black87),
                  onSubmitted: _fetchWeatherByCity,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
