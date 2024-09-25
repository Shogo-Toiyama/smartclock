import 'package:go_router/go_router.dart';
import 'package:smartclock/presentation/pages/home/home_page.dart';
import 'package:smartclock/presentation/pages/welcome/welcom_page.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: '/welcome', 
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ]
  );
  GoRouter getRouter() {
    return router;
  }
}
