import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor { dev, staging, production }

class AppConfig {
  AppConfig._();

  static late Flavor _flavor;
  static late String _apiBaseUrl;
  static late String _clientName;
  static late int    _primaryColorValue;
  static late String _logoAsset;
  // Optional: virtual-host header to inject in dev (so the Android emulator
  // can reach a WAMP virtual host via its IP address).
  static String? _devHost;

  static void initialize({
    required Flavor flavor,
    String?         apiBaseUrl,       // explicit override (dev); null → read from .env
    required String clientName,
    required int    primaryColorValue,
    required String logoAsset,
    String?         devHost,
  }) {
    _flavor             = flavor;
    _apiBaseUrl         = apiBaseUrl ?? dotenv.env['API_BASE_URL']!;
    _clientName         = clientName;
    _primaryColorValue  = primaryColorValue;
    _logoAsset          = logoAsset;
    _devHost            = devHost;
  }

  static Flavor  get flavor      => _flavor;
  static String  get apiBaseUrl  => _apiBaseUrl;
  static String  get clientName  => _clientName;
  static Color   get primaryColor => Color(_primaryColorValue);
  static String  get logoAsset   => _logoAsset;
  /// The hostname Apache should see (for WAMP virtual-host routing from a device).
  /// Only set in the dev flavor; null in staging/production.
  static String? get devHost     => _devHost;
  static bool    get isDev       => _flavor == Flavor.dev;
  static bool    get isProduction => _flavor == Flavor.production;
}
