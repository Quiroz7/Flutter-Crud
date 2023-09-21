import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_api_apks/AppBarAPis/alertaPUT.dart';
import 'package:flutter_api_apks/AppBarAPis/alertamodel.dart';
import 'package:flutter_api_apks/AppBarAPis/alertapost.dart';
import 'package:http/http.dart' as http;

class AlertaApi extends StatefulWidget {
  const AlertaApi({Key? key}) : super(key: key);

  @override
  State<AlertaApi> createState() => _AlertaApiState();
}

class _AlertaApiState extends State<AlertaApi> {
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  List<AlertasValicor>? filteredAlerts;

  void ingresarAlertas() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AlertaPost(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  AlertaModel? dataFromAPI;

  _getData() async {
    try {
      String url = "https://project-valisoft-2559218.onrender.com/api/alertas";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        setState(() {
          dataFromAPI = AlertaModel.fromJson(jsonData);
          filteredAlerts = dataFromAPI?.alerts;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _deleteAlert(String alertId) async {
    try {
      final response = await http.delete(
        Uri.parse('https://project-valisoft-2559218.onrender.com/api/alertas'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"_id": alertId})
      );

      if (response.statusCode == 204) {
        _refreshPage();
      } else {
        throw Exception('Error al eliminar la alerta');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _refreshPage() {
    setState(() {
      _isLoading = true;
    });
    _getData();
  }

  Widget _buildAlertList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Ente Regulatorio')),
          DataColumn(label: Text('Fecha')),
          DataColumn(label: Text('Mensaje')),
          DataColumn(label: Text('Acciones')),
        ],
        rows: filteredAlerts?.map((alerta) {
          return DataRow(cells: [
            DataCell(Text(alerta.enteRegulatorio)),
            DataCell(Text(alerta.fechaAlerta)),
            DataCell(Text(alerta.mensajeAlerta)),
            DataCell(
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlertaPut(alert: alerta),
                        ),
                      );
                    },
                    child: const Text('Editar'),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Eliminar Alerta'),
                            content: const Text('¿Estás seguro de que deseas eliminar esta alerta?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancelar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Eliminar'),
                                onPressed: () async {
                                  _deleteAlert(alerta.id);
                                  Navigator.of(context).pop();
                                  _refreshPage();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ]);
        }).toList() ??
            [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 37, 65),
        title: const Text("Alertas API"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            filteredAlerts = dataFromAPI?.alerts;
                          });
                        },
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        filteredAlerts = dataFromAPI?.alerts
                            .where((alerta) =>
                                alerta.enteRegulatorio.toLowerCase().contains(text.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildAlertList(),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: ingresarAlertas,
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}