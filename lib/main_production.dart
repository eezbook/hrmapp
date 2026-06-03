import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env.prod');
  AppConfig.initialize(
    flavor: Flavor.production,
    apiBaseUrl: dotenv.env['API_BASE_URL']!,
    clientName: dotenv.env['CLIENT_NAME']!,
    primaryColorValue: int.parse(dotenv.env['PRIMARY_COLOR']!),
    logoAsset: dotenv.env['LOGO_ASSET']!,
  );
  await runHrmApp();
}
