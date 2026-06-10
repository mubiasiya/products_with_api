import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:with_api/feature/core/theme/app_theme.dart';
import 'package:with_api/feature/products/data/auth/logic/bloc/auth_bloc.dart';
import 'package:with_api/feature/products/data/auth/presentation/login_screen.dart';
import 'package:with_api/feature/products/data/auth/presentation/regist_screen.dart';
import 'package:with_api/feature/products/data/auth/services/api/auth_service.dart';
import 'package:with_api/feature/products/data/auth/services/shared_pref/auth_shared.dart';
import 'package:with_api/feature/products/data/cart/hive/cart_service.dart';
import 'package:with_api/feature/products/data/cart/logic/cubit/cart_cubit.dart';
import 'package:with_api/feature/products/data/cart/presentation/cart_screen.dart';
import 'package:with_api/feature/products/data/presentation/screens/home_screen.dart';
import 'package:with_api/feature/products/data/presentation/screens/my_account_screen.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_bloc.dart';
import 'package:with_api/feature/products/data/products/repositories/product_repo.dart';
import 'package:with_api/feature/products/data/products/services/api/product_api.dart';
import 'package:with_api/feature/products/data/wishlist/hive/wishlist_hive.dart';
import 'package:with_api/feature/products/data/wishlist/logic/cubit/wishlist_cubit.dart';
import 'package:with_api/feature/products/data/wishlist/presentation/wishlist_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  final bool loggedIn = await PreferenceService.isLoggedIn();
  String userId = '';

  if (loggedIn) {
    try {
      userId = await PreferenceService.getToken();
      print(userId);

      if (userId.isNotEmpty) {
        await HiveWishlistService.openUserBox(userId);
        await HiveCartService.openUserBox(userId);
        // await HiveAddressService.openUserBox(userId);
        // await HiveOrderService.openUserBox(userId);
      }
    } catch (e) {
      debugPrint("Error opening initial user storage: $e");
    }
  }

  runApp(MyApp(isLoggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthRepository())),
        BlocProvider(
          create: (context) => ProductBloc(ProductRepository(ApiService())),
        ),
        BlocProvider(create: (context) => WishlistCubit()),
        BlocProvider(create: (context) => CartCubit()),
      ],
      child: MaterialApp(
        title: 'Product List App',
        debugShowCheckedModeBanner: false,

        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: isLoggedIn ? '/home' : '/login',

        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/account': (context) => const AccountScreen(),
          '/wishlist': (context) => const WishlistScreen(),
          '/cart': (context) => const CartScreen(),
        },
      ),
    );
  }
}
