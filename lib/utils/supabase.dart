import 'package:supabase_flutter/supabase_flutter.dart';

import '../app/index.dart';

SupabaseClient get supabase => Supabase.instance.client;

Future<void> initSupabase() async {
  if (config.supabaseUrl == 'TODO' || config.supabaseKey == 'TODO') {
    return;
  }
  await Supabase.initialize(
    url: config.supabaseUrl,
    anonKey: config.supabaseKey,
  );
}

String? getCurrentUserId() {
  return Supabase.instance.client.auth.currentSession?.user.id;
}

String? getCurrentUserEmail() {
  return Supabase.instance.client.auth.currentSession?.user.email;
}

Map<String, dynamic>? getCurrentUserAuthHeader() {
  final token = Supabase.instance.client.auth.currentSession?.accessToken;
  return token != null
      ? {
          'Authorization': 'Bearer $token',
        }
      : null;
}

User? getCurrentUser() {
  return Supabase.instance.client.auth.currentSession?.user;
}
