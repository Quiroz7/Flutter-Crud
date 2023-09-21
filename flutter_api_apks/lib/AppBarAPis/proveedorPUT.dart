import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_apks/AppBarAPis/main.dart';
import 'package:flutter_api_apks/AppBarAPis/proveedor-model.dart';
import 'package:http/http.dart' as http;

final Color formBackgroundColor = Colors.grey[200]!;
const Color formLabelColor = Colors.black;
const Color formHintColor = Colors.grey;
const Color formButtonColor = Colors.deepPurpleAccent;

Future<Proveed> updateProveedor(String id, String nombreProveedor, String nit, String emailProv, String telefonoProv, String categoriaProv, bool estadoProv) async {
  final response = await http.put(
    Uri.parse('https://project-valisoft-2559218.onrender.com/api/proveedores'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "_id": id,
      "nombreProveedor": nombreProveedor,
      "nit": int.parse(nit),
      "emailProv": emailProv,
      "telefonoProv": int.parse(telefonoProv),
      "categoriaProv": categoriaProv,
      "estadoProv": estadoProv,
    }),
  );

  if (response.statusCode == 201) {
    return Proveed.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.body);
  }
}

class Proveed {
  final String id;
  final String nombreProveedor;
  final int nit;
  final String emailProv;
  final int telefonoProv;
  final String categoriaProv;
  final bool estadoProv;

  const Proveed({
    required this.id,
    required this.nombreProveedor,
    required this.nit,
    required this.emailProv,
    required this.telefonoProv,
    required this.categoriaProv,
    required this.estadoProv,
  });

  factory Proveed.fromJson(Map<String, dynamic> json) {
    return Proveed(
      id: json["_id"],
      nombreProveedor: json["nombreProveedor"],
      nit: json["nit"],
      emailProv: json["emailProv"],
      telefonoProv: json["telefonoProv"],
      categoriaProv: json["categoriaProv"],
      estadoProv: json["estadoProv"],
    );
  }
}

class ProveedorPut extends StatefulWidget {
  final ProveedoresVali provee;

  const ProveedorPut({required this.provee, Key? key}) : super(key: key);

  @override
  State<ProveedorPut> createState() {
    return _ProveedorPutState();
  }
}

class _ProveedorPutState extends State<ProveedorPut> {
  final TextEditingController _nombreProveedor = TextEditingController();
  final TextEditingController _nit = TextEditingController();
  final TextEditingController _emailProv = TextEditingController();
  final TextEditingController _telefonoProv = TextEditingController();
  final TextEditingController _categoriaProv = TextEditingController();
  bool _estadoProv = true; // Valor por defecto

  Future<Proveed>? _futureProveed;

  @override
  void initState() {
    super.initState();
    _nombreProveedor.text = widget.provee.nombreProveedor;
    _nit.text = widget.provee.nit.toString();
    _emailProv.text = widget.provee.emailProv;
    _telefonoProv.text = widget.provee.telefonoProv.toString();
    _categoriaProv.text = widget.provee.categoriaProv;
    _estadoProv = widget.provee.estadoProv;
  }

  ProveedoresVali? dataFromAPI;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modificar Proveedores',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Modificar'),
        ),
        body: Container(
          color: formBackgroundColor,
          padding: const EdgeInsets.all(16),
          child: (_futureProveed == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildTextField(_nombreProveedor, 'Nombre'),
        const SizedBox(height: 20),
        _buildTextField(_nit, 'Nit'),
        const SizedBox(height: 20),
        _buildTextField(_emailProv, 'Email'),
        const SizedBox(height: 20),
        _buildTextField(_telefonoProv, 'Teléfono'),
        const SizedBox(height: 20),
        _buildTextField(_categoriaProv, 'Categoría'),
        const SizedBox(height: 20),
        _buildEstadoDropdown(),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureProveed = updateProveedor(
                widget.provee.id,
                _nombreProveedor.text,
                _nit.text,
                _emailProv.text,
                _telefonoProv.text,
                _categoriaProv.text,
                _estadoProv,
              );
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: formButtonColor,
          ),
          child: const Text('Actualizar'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: formHintColor),
        labelText: hintText,
        labelStyle: const TextStyle(color: formLabelColor),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildEstadoDropdown() {
    return DropdownButtonFormField<bool>(
      value: _estadoProv,
      onChanged: (bool? newValue) {
        setState(() {
          _estadoProv = newValue ?? true;
        });
      },
      items: const [
        DropdownMenuItem<bool>(
          value: true,
          child: Text('Activo'),
        ),
        DropdownMenuItem<bool>(
          value: false,
          child: Text('Inactivo'),
        ),
      ],
      decoration: const InputDecoration(
        labelText: 'Estado',
        labelStyle: TextStyle(color: formLabelColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(),
      ),
    );
  }

  FutureBuilder<Proveed> buildFutureBuilder() {
    return FutureBuilder<Proveed>(
      future: _futureProveed,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                'Proveedor actualizado: ${snapshot.data!.nombreProveedor}',
                style: const TextStyle(color: Colors.green),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainApp(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: formButtonColor,
                ),
                child: const Text('Regresar'),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              Text(
                '${snapshot.error}',
                style: const TextStyle(color: Color.fromARGB(255, 54, 120, 244)),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainApp(),
                    ),
                  );
                },
                child: const Text('Regresar'),
              ),
            ],
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
