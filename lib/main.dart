import 'package:flutter/material.dart';
import 'package:msp_app/home/home.dart';
import 'package:msp_app/lot/lot.dart';
import 'package:msp_app/products/add_product.dart';
import 'package:localstorage/localstorage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localStorage = LocalStorage('almacen');
  await localStorage.ready;
  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;
  const MyApp({Key? key, required this.localStorage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MspApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      // Set the 'home' as the initial route
      initialRoute: '/',
      routes: {
        // Define the routes and the widgets that should be loaded
        '/': (context) => DashboardScreen(),
        '/lots': (context) => NuevoLoteScreen(),
        '/add_product': (context) => ProductDetailsForm()

        // Add more routes here
        // '/otherScreen': (context) => OtherScreen(),
      },
      // If you want to handle undefined routes, use onGenerateRoute or onUnknownRoute
      // onGenerateRoute: (settings) {
      //   // Handle route generation here
      // },
    );
  }
}
