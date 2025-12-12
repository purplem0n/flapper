import 'package:flutter/widgets.dart';

import 'app/index.dart';
import 'bootstrap.dart';
import 'utils/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  config = AppConfig(
    env: 'development',
    supabaseUrl: 'TODO',
    supabaseKey: 'TODO',
  );
  await SharedPref.init('development');
  await bootstrap(() => const App());
}
