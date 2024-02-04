import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:msp_app/api/api.dart';

class ProductDetailsForm extends StatefulWidget {
  @override
  _ProductDetailsFormState createState() => _ProductDetailsFormState();
}

class _ProductDetailsFormState extends State<ProductDetailsForm> {
  final _locationController = TextEditingController();
  final _quantityController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _fabricationDateController = TextEditingController();
  Map<String, dynamic>? _selectedProduct;
  String _successMessage = '';

  Future<List<Map<String, dynamic>>> _searchProduct(String query) async {
    if (query.isEmpty) {
      return [];
    }
    try {
      // * TRAE DETALLES DE LOS PRODUCTOS DEL CONTROLADOR
      List<dynamic> products =
          await ApiService().consultarDetallesProducto(query);
      return products
          .map((product) => {
                'id': product['id'].toString(),
                'nombreComercial': product['nombreComercial']
              })
          .toList();
    } catch (e) {
      print("API call failed with error: $e");
      return [];
    }
  }

  void dispose() {
    _locationController.dispose();
    _quantityController.dispose();
    _expirationDateController.dispose();
    _fabricationDateController.dispose();
    super.dispose();
  }

  Future<void> showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación de registro'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Desea registrar este producto?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Registrar'),
              onPressed: () {
                registerProduct(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showSuccessMessage(BuildContext context) {
    setState(() {
      _successMessage = 'Ingreso registrado exitosamente!';
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        _successMessage,
        style: TextStyle(fontSize: 20),
      ),
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _successMessage = '';
      });
    });
    Navigator.pop(context);
  }

  void registerProduct(BuildContext context) {
    if (_selectedProduct != null) {
      final productId = int.tryParse(_selectedProduct!['id']) ?? 0;
      final quantity = int.parse(
          _quantityController.text.isEmpty ? '0' : _quantityController.text);
      final location = _locationController.text;
      final expirationDate = _expirationDateController.text;
      final fabricationDate = _fabricationDateController.text;

      ApiService()
          .registrarProductoMedico(
              fechaCaducidad: expirationDate,
              fechaFabricacion: fabricationDate,
              ubicacion: location,
              cantidad: quantity,
              administradorId: 1,
              productoMedicoId: productId)
          .then((response) {
        print('Product registered successfully');
        showSuccessMessage(context);
      }).catchError((error) {
        print('Failed to register product: $error');
      });
    } else {
      print('No product selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Autocomplete<Map<String, dynamic>>(
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text == '') {
                    return const Iterable<Map<String, dynamic>>.empty();
                  }
                  return _searchProduct(textEditingValue.text);
                },
                displayStringForOption: (Map<String, dynamic> option) =>
                    option['nombreComercial'] ?? 'Sin nombre',
                onSelected: (Map<String, dynamic> selection) {
                  setState(() {
                    _selectedProduct = selection;
                  });
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Nombre del producto',
                      suffixIcon: Icon(FontAwesomeIcons.magnifyingGlass),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Locación de bodega',
                  hintText: "Rack A17 (ejemplo)",
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.locationCrosshairs),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  hintText: "Ingrese la cantidad",
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.listOl),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _fabricationDateController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  DateInputFormatter(), // Use the custom formatter here
                ],
                decoration: InputDecoration(
                  labelText: 'Fecha fabricación',
                  hintText: "dd/mm/aaaa",
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.calendar),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _expirationDateController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  DateInputFormatter(), // Use the custom formatter here
                ],
                decoration: InputDecoration(
                  labelText: 'Fecha caducidad',
                  hintText: "dd/mm/aaaa",
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.calendar),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
        child: FloatingActionButton.extended(
          elevation: 10,
          onPressed: () => showConfirmationDialog(context),
          label: Text(
            'Subir',
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 234, 234, 234),
            ),
          ),
          icon: Icon(FontAwesomeIcons.cloudArrowUp),
          foregroundColor: Color.fromARGB(255, 234, 234, 234),
          backgroundColor: Color.fromARGB(255, 67, 67, 67),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Color(0XFFFECE02),
        height: 60,
        shape: CircularNotchedRectangle(),
        notchMargin: 1.0,
      ),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    if (newText.isEmpty || newText.length > 10) {
      return oldValue;
    }

    final regExp = RegExp(r'^\d{0,2}/?\d{0,2}/?\d{0,4}$');
    if (!regExp.hasMatch(newText)) {
      return oldValue;
    }

    var formattedText = newText;
    if (newText.length == 3 && !newText.endsWith('/')) {
      formattedText = newText.substring(0, 2) + '/' + newText.substring(2);
    } else if (newText.length == 6 && !newText.endsWith('/')) {
      formattedText = newText.substring(0, 5) + '/' + newText.substring(5);
    }

    return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length));
  }
}
