import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<dynamic>> consultarDetallesProducto(String nombreProducto) async {
    final response = await http
        .get(Uri.parse('$baseUrl/administrador/producto/$nombreProducto'));

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<dynamic> registrarProductoMedico({
    required String fechaCaducidad,
    required String fechaFabricacion,
    required String ubicacion,
    required int cantidad,
    required int administradorId,
    required int productoMedicoId,
  }) async {
    final LocalStorage localStorage = LocalStorage('almacen');

    // Initialize local storage
    await localStorage.ready;

    // Get the selected city from local storage
    String? savedCity = localStorage.getItem('selectedAlmacen');

    print("savedCity" + savedCity!);

    final response = await http.post(
      Uri.parse('$baseUrl/administrador/producto'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'fechaCaducidad': fechaCaducidad,
        'fechaFabricacion': fechaFabricacion,
        'ubicacion': ubicacion,
        'almacen': savedCity,
        'cantidad': cantidad,
        'administradorId': administradorId,
        'productoMedicoId': productoMedicoId,
      }),
    );

    print('Response Status Code: ${response.statusCode}');

    if (response.statusCode == 201) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register product');
    }
  }

  Future<List<dynamic>> getRecentlyAddedProducts() async {
    final response = await http
        .get(Uri.parse('$baseUrl/inventario-log/recently-added-products'));

    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recently added products');
    }
  }
}
