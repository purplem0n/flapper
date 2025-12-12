late final AppConfig config;

class AppConfig {
  final String env;
  final String supabaseUrl;
  final String supabaseKey;

  AppConfig({
    required this.env,
    required this.supabaseUrl,
    required this.supabaseKey,
  });
}
