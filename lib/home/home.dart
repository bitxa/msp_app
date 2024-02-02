import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localstorage/localstorage.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final LocalStorage localStorage = LocalStorage('almacen');
  final List<String> dropdownOptions = [
    'Azuay',
    'Bolívar',
    'Cañar',
    'Carchi',
    'Chimborazo',
    'Cotopaxi',
    'El Oro',
    'Esmeraldas',
    'Galápagos',
    'Guayas',
    'Imbabura',
    'Loja',
    'Los Ríos',
    'Manabí',
    'Morona Santiago',
    'Napo',
    'Orellana',
    'Pastaza',
    'Pichincha',
    'Santa Elena',
    'Santo Domingo de los Tsáchilas',
    'Sucumbíos',
    'Tungurahua',
    'Zamora-Chinchi'
  ];
  String dropdownValue = 'Loja';

  Future<void> initLocalStorage() async {
    await localStorage.ready;
    String? savedCity = localStorage.getItem('selectedAlmacen');
    savedCity = savedCity ?? 'Loja';

    print("Saved city in home" + savedCity);

    setState(() {
      dropdownValue = savedCity!;
    });
  }

  @override
  void initState() {
    super.initState();
    initLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 60, bottom: 10, left: 50, right: 50),
              child: Image.asset('assets/logo.png'),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text("Almacen",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      elevation: 20,
                      style: TextStyle(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 54, 54, 54)),
                      underline: Container(
                        height: 3,
                        color: Color(0XFFFECE02),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                        localStorage.setItem('selectedAlmacen', newValue!);
                        print("selected was: " +
                            localStorage.getItem('selectedAlmacen'));
                      },
                      items: dropdownOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: IngresoTile(),
                  ),
                  Expanded(
                    child: InventoryTile(),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.00),
              child: ElevatedButton.icon(
                icon: Icon(
                  FontAwesomeIcons.arrowRotateRight,
                  color: Colors.white,
                ),
                label: Text(
                  'Actualizar datos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Adjust font size as necessary
                  ),
                ),
                onPressed: () {
                  // Handle your button tap here.
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(
                      255, 29, 29, 29), // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16), // Inner padding for the button
                ),
              ),
            ),
            ActionButton(
              title: 'INGRESO DE PRODUCTOS',
              iconData: FontAwesomeIcons.truck,
              routeName: '/lots',
            ),
            ActionButton(
              title: 'INVENTARIO',
              iconData: FontAwesomeIcons.warehouse,
              routeName: '/',
            ),
            ActionButton(
              title: 'HISTORIAL RECEPCIONES',
              iconData: FontAwesomeIcons.clockRotateLeft,
              routeName: '/',
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final String routeName;
  final double spacing; // Added spacing parameter

  const ActionButton({
    Key? key,
    required this.title,
    required this.iconData,
    required this.routeName,
    this.spacing = 8.0, // Default spacing if not provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton.icon(
        icon: IconTheme(
          data: IconThemeData(
            size: 28, // Size of the icon
            color: Colors.black,
          ),
          child: Padding(
            padding:
                EdgeInsets.only(right: spacing), // Right padding for the icon
            child: Icon(iconData),
          ),
        ),
        label: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, routeName);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black,
          side: BorderSide(color: Colors.black, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
          minimumSize: Size(double.infinity, 56),
        ),
      ),
    );
  }
}

class IngresoTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0XFFFECE02), // Adjust the color to match your exact shade
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: Container(
        height: 150, // Adjust height as necessary
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '200',
                  style: TextStyle(
                    fontSize: 36, // Adjust font size as necessary
                    fontWeight: FontWeight.bold, // Make the text bold
                    color: Color(0XFFF0E8E8), // Adjust text color as necessary
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  textAlign: TextAlign.center,
                  'Ingresos en las últimas 24 h',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0XFF2B2C28),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InventoryTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0XFFFECE02),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: Container(
        alignment: Alignment.center, //
        height: 150,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '200\$',
                  style: TextStyle(
                    fontSize: 36, // Adjust font size as necessary
                    fontWeight: FontWeight.bold, // Make the text bold
                    color: Color(0XFFF0E8E8), // Adjust text color as necessary
                  ),
                ),
                SizedBox(height: 4), // Space between the text and subtitle
                Text(
                  'Valor estimado del inventario',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16, // Adjust font size as necessary
                    color: Color(0XFF2B2C28), // Adjust text color as necessary
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
