import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_api_apks/AppBarAPis/clientes-model.dart';
import 'package:http/http.dart' as http;

class ClientesAPi extends StatefulWidget {
  const ClientesAPi({Key? key}) : super(key: key);

  @override
  State<ClientesAPi> createState() => _ClientesAPiState();
}

class _ClientesAPiState extends State<ClientesAPi> {
  bool _isLoading = true;
  
  List<ClientesValicor> _filteredClients = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  ClienteModel? dataFromAPI;

  _getData() async {
    try {
      String url = "https://proyectonodejsbackend.onrender.com/api/cliente";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        dataFromAPI = ClienteModel.fromJson(json.decode(res.body));
        _filteredClients = List.from(dataFromAPI!.clients);
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _filterClients(String query) {
    setState(() {
      _filteredClients = dataFromAPI!.clients.where((cliente) {
        final nombre = cliente.nombre.toLowerCase();
        final cedula = cliente.cedula.toString().toLowerCase();
        final email = cliente.email.toLowerCase();
        final telefono = cliente.telefono.toString().toLowerCase();
        final estado = cliente.estado.toString().toLowerCase();
        final lowerCaseQuery = query.toLowerCase();

        return nombre.contains(lowerCaseQuery) ||
            cedula.contains(lowerCaseQuery) ||
            email.contains(lowerCaseQuery) ||
            telefono.contains(lowerCaseQuery) ||
            estado.contains(lowerCaseQuery);
      }).toList();
    });
  }

  Widget _buildClientesTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Cédula')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Teléfono')),
          DataColumn(label: Text('Estado')),
        ],
        rows: _filteredClients.map((cliente) {
          return DataRow(cells: [
            DataCell(Center(child: Text(cliente.nombre))),
            DataCell(Center(child: Text(cliente.cedula.toString()))),
            DataCell(Center(child: Text(cliente.email))),
            DataCell(Center(child: Text(cliente.telefono.toString()))),
            DataCell(Center(child: Text(cliente.estado.toString()))),
          ]);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 37, 65),
        title: const Text("Clientes API"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
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
                            _filterClients('');
                          },
                        ),
                      ),
                      onChanged: _filterClients,
                    ),
                  ),
                  _buildClientesTable(),
                ],
              ),
            ),
    );
  }
}
