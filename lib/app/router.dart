import 'package:go_router/go_router.dart';

import '../features/template/index.dart';
import '../utils/index.dart';

final counterRoute = GoRoute(
  path: '/template',
  builder: (context, state) => const TemplatePage(),
);

final router = GoRouter(
  initialLocation: counterRoute.path,
  routes: <RouteBase>[
    counterRoute,
  ],
  redirect: (context, state) {
    if (state.fullPath == '/') {
      if (getCurrentUserId() == null) {
        return '/signup';
      } else {
        return '/';
      }
    }
    return null;
  },
);
