/*import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
mport 'package:gourmetpass/admin/screens/coupons/list_coupons_screen.dart';
import 'package:gourmetpass/admin/screens/dashboard_screen.dart';
import 'package:gourmetpass/admin/screens/restaurants/list_restaurants_screen.dart';
import 'package:gourmetpass/admin/screens/users/list_users_screen.dart';
import 'package:gourmetpass/providers/coupon_provider.dart';
import 'package:gourmetpass/providers/restaurant_provider.dart';
import 'package:gourmetpass/providers/user_provider.dart';
import 'package:gourmetpass/screens/auth/login_screen.dart';
import 'package:gourmetpass/screens/auth/signup_screen.dart';
import 'package:gourmetpass/screens/restaurant_list_screen.dart';
import 'package:provider/provider.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint("✅ Firebase est bien initialisé !");
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => CouponProvider()),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GourmetPass Admin',
            theme: ThemeData(
              primarySwatch: Colors.orange,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            //initialRoute: userProvider.isLoggedIn ? '/admin/dashboard' : '/login',
            routes: {
              //'/login': (context) => const LoginScreen(),
              //'/register': (context) => const SignupScreen(),
              '/home': (context) => const RestaurantListScreen(), // ✅ Vérifie cette ligne
              //'/admin/dashboard': (context) => const DashboardScreen(),
              //'/admin/restaurants': (context) => const ListRestaurantsScreen(),
              //'/admin/coupons': (context) => const ListCouponsScreen(),
              //'/admin/users': (context) => const ListUsersScreen(),
            },
          );
        },
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:gourmetpass/providers/coupon_provider.dart';
import 'package:gourmetpass/providers/restaurant_provider.dart';
import 'package:gourmetpass/screens/restaurant_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantProvider()), // ✅ Sans Firestore
        ChangeNotifierProvider(create: (_) => CouponProvider()), // ✅ Sans Firestore
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GourmetPass',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const RestaurantListScreen(),
        },
      ),
    );
  }
}
