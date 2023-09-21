import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_api_apks/AppBarAPis/alertamodel.dart';
import 'package:flutter_api_apks/AppBarAPis/main.dart';
import 'package:http/http.dart' as http;

final Color formBackgroundColor = Colors.grey[200]!;
const Color formLabelColor = Colors.black;
const Color formHintColor = Colors.grey;
const Color formButtonColor = Colors.deepPurpleAccent;

Future<Alert> editAlerta(
  String id,
  String enteRegulatorio,
  String fechaAlerta,
  String mensajeAlerta,
) async {
  final response = await http.put(
    Uri.parse('https://project-valisoft-2559218.onrender.com/api/alertas'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "_id": id,
      "enteRegulatorio": enteRegulatorio,
      "fechaAlerta": fechaAlerta,
      "mensajeAlerta": mensajeAlerta,
    }),
  );

  if (response.statusCode == 201) {
    return Alert.fromJson(jsonDecode(response.body));
    
    
  } else {
    throw Exception(response.body);
  }
}

class Alert {
  final String id;
  final String enteRegulatorio;
  final String fechaAlerta;
  final String mensajeAlerta;

  const Alert({
    required this.id,
    required this.enteRegulatorio,
    required this.fechaAlerta,
    required this.mensajeAlerta,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json["_id"],
      enteRegulatorio: json["enteRegulatorio"],
      fechaAlerta: json["fechaAlerta"],
      mensajeAlerta: json["mensajeAlerta"],
    );
  }
}

class AlertaPut extends StatefulWidget {

  final AlertasValicor alert;

  const AlertaPut({required this.alert, Key? key}) : super(key: key);

  @override
  State<AlertaPut> createState() {
    return _AlertaPutState();
  }
}

class _AlertaPutState extends State<AlertaPut> {
  final TextEditingController _enteRegulatorio = TextEditingController();
  final TextEditingController _fechaAlerta = TextEditingController();
  final TextEditingController _mensajeAlerta = TextEditingController();

  Future<Alert>? _futureAlert;

  @override
  void initState() {
    super.initState();
    _enteRegulatorio.text = widget.alert.enteRegulatorio;
    _fechaAlerta.text = widget.alert.fechaAlerta;
    _mensajeAlerta.text = widget.alert.mensajeAlerta;
  }

  AlertasValicor? dataFromAPI;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Editar Alertas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Editar'),
        ),
        body: Container(
          color: formBackgroundColor,
          padding: const EdgeInsets.all(8),
          child: (_futureAlert == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildTextField(_enteRegulatorio, 'Ente Regulatorio'),
        const SizedBox(height: 20),
        _buildTextField(_fechaAlerta, 'Fecha'),
        const SizedBox(height: 20),
        _buildTextField(_mensajeAlerta, 'Mensaje'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlert = editAlerta(
                widget.alert.id,
                _enteRegulatorio.text,
                _fechaAlerta.text,
                _mensajeAlerta.text,
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

  FutureBuilder<Alert> buildFutureBuilder() {
    return FutureBuilder<Alert>(
      future: _futureAlert,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                'Alerta Editada: ${snapshot.data!.enteRegulatorio}',
                style: const TextStyle(color: Colors.green),
              ),
              const SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => const MainApp(),),);             
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
            children : [
              Text(
                '${snapshot.error}',
                style: const TextStyle(color: Color.fromARGB(255, 54, 120, 244)),
              ),
              const SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => const MainApp(),),);             
                }, child: const Text('Regresar'),
              ),
            ],
          );
          }
          return const CircularProgressIndicator();
      },
    );
  }
}
