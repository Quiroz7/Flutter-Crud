import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_api_apks/AppBarAPis/main.dart';
import 'package:http/http.dart' as http;

final Color formBackgroundColor = Colors.grey[200]!;
const Color formLabelColor = Colors.black;
const Color formHintColor = Colors.grey;
const Color formButtonColor = Colors.deepPurpleAccent;

Future<Alert> createAlerta(String enteRegulatorio, String fechaAlerta, String mensajeAlerta) async {
  final response = await http.post(
    Uri.parse('https://project-valisoft-2559218.onrender.com/api/alertas'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
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

  const Alert({required this.id, required this.enteRegulatorio, required this.fechaAlerta, required this.mensajeAlerta});

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json["_id"],
      enteRegulatorio: json["enteRegulatorio"],
      fechaAlerta: json["fechaAlerta"],
      mensajeAlerta: json["mensajeAlerta"],
    );
  }
}

class AlertaPost extends StatefulWidget {
  const AlertaPost({Key? key}) : super(key: key);

  @override
  State<AlertaPost> createState() {
    return _AlertaPostState();
  }
}

class _AlertaPostState extends State<AlertaPost> {
  final TextEditingController _enteRegulatorio = TextEditingController();
  final TextEditingController _fechaAlerta = TextEditingController();
  final TextEditingController _mensajeAlerta = TextEditingController();

  Future<Alert>? _futureAlert;

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crear Alertas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Crear Alerta'),
        ),
        body: Container(
          color: formBackgroundColor,
          padding: const EdgeInsets.all(16),
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
              _futureAlert = createAlerta(
                _enteRegulatorio.text,
                _fechaAlerta.text,
                _mensajeAlerta.text,
                
              );
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: formButtonColor,
          ),
          child: const Text('Registrar'),
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
                'Alerta registrada: ${snapshot.data!.enteRegulatorio}',
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
