import 'package:go_router/go_router.dart';
import 'package:smartclock/presentation/pages/home/home_page.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: '/', 
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
    ]
  );
  GoRouter getRouter() {
    return router;
  }
}
