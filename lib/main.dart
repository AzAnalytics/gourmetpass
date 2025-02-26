import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'firebase_options.dart';
import 'providers/user_provider.dart';
import 'providers/coupon_provider.dart';
import 'providers/restaurant_provider.dart';

import 'auth/login_screen.dart';
import 'auth/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/subscription_screen.dart';
import 'screens/restaurant_list_screen.dart';
import 'screens/restaurant_detail_screen.dart';
import 'screens/my_coupons_screen.dart';

import 'admin/screens/dashboard_screen.dart';
import 'admin/screens/users/list_users_screen.dart';
import 'admin/screens/restaurants/list_restaurants_screen.dart';
import 'admin/screens/coupons/list_coupons_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Configuration de Stripe (Remplace par ta clé publique)
  Stripe.publishableKey = "pk_live_51QwIEyCLyuydnuvxjV47QfXWYbnSJoVMhYXYVawB0CP2iow8th22ovO2SwkmItbtNGRkJfiv5XomZFct8UobhdV600mBPkgpqv";
  await Stripe.instance.applySettings();

  debugPrint("✅ Firebase et Stripe sont bien initialisés !");

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => CouponProvider()),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GourmetPass',
            theme: ThemeData(
              primarySwatch: Colors.orange,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: userProvider.isLoggedIn ? '/home' : '/login',
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const SignupScreen(),
              '/home': (context) => const HomeScreen(),
              '/subscription': (context) => const SubscriptionScreen(),
              '/restaurants': (context) => const RestaurantListScreen(),
              '/restaurant_detail': (context) => const RestaurantDetailScreen(restaurantId: ""),
              '/my_coupons': (context) => const MyCouponsScreen(),

              // ✅ Routes Admin
              '/admin/dashboard': (context) => const DashboardScreen(),
              '/admin/users': (context) => const ListUsersScreen(),
              '/admin/restaurants': (context) => const ListRestaurantsScreen(),
              '/admin/coupons': (context) => const ListCouponsScreen(),
            },
          );
        },
      ),
    );
  }
}
