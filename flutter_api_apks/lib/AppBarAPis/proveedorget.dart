import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_api_apks/AppBarAPis/proveedor-model.dart';
import 'package:flutter_api_apks/AppBarAPis/proveedorPUT.dart';
import 'package:flutter_api_apks/AppBarAPis/proveedorpost.dart';
import 'package:http/http.dart' as http;

class ProveedoresTab extends StatefulWidget {
  const ProveedoresTab({Key? key}) : super(key: key);

  @override
  State<ProveedoresTab> createState() => _ProveedoresTabState();
}

class _ProveedoresTabState extends State<ProveedoresTab> {
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  List<ProveedoresVali>? filteredProveedores;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    try {
      String url = "https://project-valisoft-2559218.onrender.com/api/proveedores";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        setState(() {
          dataFromAPI = ProveedorModel.fromJson(jsonData);
          filteredProveedores = dataFromAPI?.proveedors;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ProveedorModel? dataFromAPI;

  void _eliminarProveedor(String provId) async {
    try {
      final response = await http.delete(
        Uri.parse('https://project-valisoft-2559218.onrender.com/api/proveedores'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"_id": provId})
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

  void ingresar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProveedorPost()),
    );
  }

  String estadoToString(bool estado) {
    return estado ? 'Activo' : 'Inactivo';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 37, 65),
        title: const Text("Proveedores API"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                            filteredProveedores = dataFromAPI?.proveedors;
                          });
                        },
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        filteredProveedores = dataFromAPI?.proveedors
                            .where((proveedor) =>
                                proveedor.nombreProveedor
                                    .toLowerCase()
                                    .contains(text.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Nit')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Telefono')),
                        DataColumn(label: Text('Estado')),
                        DataColumn(label: Text('Categoria')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: filteredProveedores?.map((proveedor) {
                        return DataRow(cells: [
                          DataCell(Text(proveedor.nombreProveedor)),
                          DataCell(Text(proveedor.nit.toString())),
                          DataCell(Text(proveedor.emailProv)),
                          DataCell(Text(proveedor.telefonoProv.toString())),
                          DataCell(Text(estadoToString(proveedor.estadoProv))),
                          DataCell(Text(proveedor.categoriaProv)),
                          DataCell(
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProveedorPut(provee: proveedor),
                                      ),
                                    );
                                  },
                                  child: const Text('Editar'),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirmar eliminación'),
                                          content: const Text('¿Estás seguro de que deseas eliminar este proveedor?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancelar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Eliminar'),
                                              onPressed: () async {
                                                _eliminarProveedor(proveedor.id);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete), 
                                  color: Colors.red, 
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList() ??
                          [],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: ingresar,
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}