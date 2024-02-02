import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:msp_app/api/api.dart';
import 'package:intl/intl.dart';

class NuevoLoteScreen extends StatefulWidget {
  @override
  _NuevoLoteScreenState createState() => _NuevoLoteScreenState();
}

class _NuevoLoteScreenState extends State<NuevoLoteScreen> {
  final ApiService apiService = ApiService();

  List<dynamic> recentlyUpdatedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchRecentlyUpdatedProducts();
  }

  Future<void> _fetchRecentlyUpdatedProducts() async {
    try {
      final List<dynamic> products =
          await apiService.getRecentlyAddedProducts();
      setState(() {
        recentlyUpdatedProducts = products;
      });
    } catch (e) {
      // Handle any errors or exceptions here
      print('Error fetching recently Updated products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo ingreso'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Añadir producto'),
                onPressed: () {
                  Navigator.pushNamed(context, "/add_product");
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 67, 67, 67),
                  onPrimary: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Ingresos recientes:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildRecentlyUpdatedProductCards(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build the recently Updated product cards
  List<Widget> _buildRecentlyUpdatedProductCards() {
    return recentlyUpdatedProducts.map((product) {
      return ProductoCard(product: product);
    }).toList();
  }
}

class ProductoCard extends StatefulWidget {
  final dynamic product;

  ProductoCard({required this.product});

  @override
  _ProductoCardState createState() => _ProductoCardState();
}

class _ProductoCardState extends State<ProductoCard> {
  @override
  Widget build(BuildContext context) {
    final String productName = widget.product['productName'];
    final int cantidad = widget.product['updatedStock'];
    final String fechaIngreso = widget.product['createdAt'];

    return Card(
      margin: EdgeInsets.all(10),
      color: Color.fromARGB(Random().nextInt(255), Random().nextInt(250),
          Random().nextInt(250), 146),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                productName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Cantidad: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(width: 12),
                    Text(cantidad.toString()),
                  ],
                ),
                Row(
                  children: [
                    Text("Ingreso: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(width: 12),
                    Text(formatDate(fechaIngreso)),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

formatDate(dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  DateFormat formatter = DateFormat('yyyy/MM/dd - HH:mm');

  return formatter.format(dateTime).toString();
}
