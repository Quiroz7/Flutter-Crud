import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_api_apks/AppBarAPis/logInUsu-model.dart';
import 'package:flutter_api_apks/AppBarAPis/main.dart';
import 'package:http/http.dart' as http;

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); 

  final String validEmail = 'juan@juan.com';
  final String validPassword = '555';

  @override
  void initState() {
    super.initState();
    _getUsuarios();
  }

  DataModelUsuario? _dataModelUsuario;

  _getUsuarios() async {
    isLoading = true;
    try {
      String url = 'https://coff-v-art-api.onrender.com/api/user';
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        _dataModelUsuario = DataModelUsuario.fromJson(json.decode(res.body));
        isLoading = false;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 3, 37, 65),
      ),
      body: Container(
        color: const Color.fromARGB(192, 244, 245, 245),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                'https://th.bing.com/th/id/OIP.1NnSdHyJzQknI_uULOkoxgAAAA?pid=ImgDet&rs=1',
                width: 200, 
                height: 200, 
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  icon: Icon(Icons.person), 
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30,),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  icon: Icon(Icons.lock), 
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
               
                    final enteredEmail = _emailController.text.trim();
                    final enteredPassword = _passwordController.text.trim();
                    int positionUsuario = -1;

                   
                    for (int i = 0;
                        i < _dataModelUsuario!.usuarios.length;
                        i++) {
                      if (_dataModelUsuario!.usuarios[i].email ==
                              enteredEmail &&
                          _dataModelUsuario!.usuarios[i].password ==
                              enteredPassword) {
                        positionUsuario = i;
                        break;
                      }
                    }

                    if (positionUsuario != -1) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const MainApp(),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Correo o contraseña errados')),
                      );
                    }
                  }
                },
                child: const Text('Ingresar'),
               
              ),
            ],
          ),
        ),
      ),
    );
  }
}
