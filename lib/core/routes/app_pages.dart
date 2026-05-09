import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/home_page.dart';
import '../../features/login/login_page.dart';
import '../../features/login/register_page.dart';
import '../../features/product/domain/product_model.dart';
import '../../features/product/presentation/detail_page.dart';
import '../../features/product/presentation/product_provider.dart';
import 'app_routes.dart';

class AppPages {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ProductProvider()..fetchProducts(),
            child: const HomePage(),
          ),
        );

      case AppRoutes.detail:
        final args = settings.arguments;
        if (args is Product) {
          return MaterialPageRoute(builder: (_) => DetailPage(product: args));
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Product data is missing')),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route Not Found'))),
        );
    }
  }
}
