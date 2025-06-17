import 'package:flutter/material.dart';

class ProviderScreen extends StatefulWidget {
  @override
  _ProviderScreenState createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  // Simulación de datos de componentes y precios
  List<Map<String, dynamic>> componentes = [
    {'nombre': 'CPU', 'precio': 120.0, 'precioAnterior': 115.0},
    {'nombre': 'GPU', 'precio': 300.0, 'precioAnterior': 320.0},
    {'nombre': 'RAM', 'precio': 80.0, 'precioAnterior': 80.0},
  ];

  void actualizarPrecio(int index, double nuevoPrecio) {
    setState(() {
      componentes[index]['precioAnterior'] = componentes[index]['precio'];
      componentes[index]['precio'] = nuevoPrecio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Precios de Componentes en Tiempo Real')),
        body: ListView.builder(
          itemCount: componentes.length,
          itemBuilder: (context, index) {
            final comp = componentes[index];
            final diferencia = comp['precio'] - comp['precioAnterior'];
            return Card(
              child: ListTile(
                title: Text(comp['nombre']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Precio actual: ${comp['precio']} USD'),
                    Text('Precio anterior: ${comp['precioAnterior']} USD'),
                    Text(
                      'Diferencia: ${diferencia > 0 ? '+' : ''}${diferencia.toStringAsFixed(2)} USD',
                      style: TextStyle(
                        color: diferencia > 0
                            ? Colors.red
                            : (diferencia < 0 ? Colors.green : Colors.grey),
                      ),
                    ),
                    Row(
                      children: [
                        Text('Actualizar precio:'),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onSubmitted: (value) {
                              final nuevo = double.tryParse(value);
                              if (nuevo != null) {
                                actualizarPrecio(index, nuevo);
                              }
                            },
                            decoration: InputDecoration(hintText: 'Nuevo precio'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
