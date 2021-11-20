import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/products_details_screen.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/manage_products_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'providers/products_provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    /*
    ChangeNotifierProvider u kombinaciji sa create: create:(ctx) => ProductsProvider() treba koristiti ukoliko koristimo
    nize u widgetima context ili ako podatke koristimo u widgetima koji nisu lista i grid. Posto ga ovdje ne koristimo i treba nam samo vrijednost koristicemo ChangeNotifierProvider.value.
    Jedna vazna naponena je da u slucaju lista i grida da bi se izbjegao problem recikliranja widgeta i starih podataka
    treba koristiti ChangeNotifierProvider.value! Ukoliko dodje do promjene screena ChangeNotifierProvider brise sve stare podatke koji su se koristili
    u prethodnom screenu i ne moramo mi da vodimo racuna da se ne bi memorija popunila.
    */

    return MultiProvider (
      providers: [
        ChangeNotifierProvider(create:(ctx) => Auth(),),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(update:(ctx, auth, previousProducts) => ProductsProvider(auth.getToken, auth.getUser,previousProducts == null ? [] : previousProducts.items)),
        ChangeNotifierProvider(create:(ctx) => Cart(),),
        ChangeNotifierProxyProvider<Auth, Orders>(update:(ctx, auth, previousOrders) => Orders(auth.getToken, previousOrders == null ? [] : previousOrders.orders)),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shop',
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isLogedIn ? ProductOverviewScreen()
              :
          FutureBuilder(
            future: auth.autoLogin(),
            builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
          ),
          routes: {
            OrdersScreen.routeName : (ctx) => OrdersScreen(),
            ManageProductsScreen.routeName: (ctx) => ManageProductsScreen(),
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
          onGenerateRoute: (settings){
            return MaterialPageRoute(builder: (ctx) => ProductOverviewScreen());
          },
          onUnknownRoute: (settings){
            return MaterialPageRoute(builder: (ctx) => ProductOverviewScreen());
          },
        )
      ),
    );
  }
}

