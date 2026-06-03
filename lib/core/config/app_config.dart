import 'package:flutter/material.dart';

enum Flavor { dev, staging, production }

class AppConfig {
  AppConfig._();

  static late Flavor _flavor;
  static late String _apiBaseUrl;
  static late String _clientName;
  static late int _primaryColorValue;
  static late String _logoAsset;

  static void initialize({
    required Flavor flavor,
    required String apiBaseUrl,
    required String clientName,
    required int primaryColorValue,
    required String logoAsset,
  }) {
    _flavor = flavor;
    _apiBaseUrl = apiBaseUrl;
    _clientName = clientName;
    _primaryColorValue = primaryColorValue;
    _logoAsset = logoAsset;
  }

  static Flavor get flavor => _flavor;
  static String get apiBaseUrl => _apiBaseUrl;
  static String get clientName => _clientName;
  static Color get primaryColor => Color(_primaryColorValue);
  static String get logoAsset => _logoAsset;
  static bool get isDev => _flavor == Flavor.dev;
  static bool get isProduction => _flavor == Flavor.production;
}
