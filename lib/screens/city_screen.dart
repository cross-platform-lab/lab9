import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  String cityName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, size: 40.0, color: Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  decoration: kTextFieldInputDecoration,
                  textInputAction: TextInputAction.search,
                  onChanged: (value) => cityName = value,
                  onSubmitted: (value) => Navigator.pop(context, value),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, cityName),
                child: const Text('Xem thời tiết', style: kButtonTextStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
