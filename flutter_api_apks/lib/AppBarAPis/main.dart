import 'package:flutter/material.dart';
import 'package:flutter_api_apks/AppBarAPis/alertaget.dart';
import 'package:flutter_api_apks/AppBarAPis/clientesget.dart';
import 'package:flutter_api_apks/AppBarAPis/photo.dart';
import 'package:flutter_api_apks/AppBarAPis/proveedorget.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 32, 76, 133),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Proveedores'),
                Tab(text: 'Alertas'),
                Tab(text: 'Clientes'),
                Tab(text: 'Cámara & Gps',),
               
              ],
            ),
            title: const Text('VALICOR'),
          ),
          body: Column(
            children: [
              Image.network(
                'https://th.bing.com/th/id/OIP.esZngO9eqaXlpntGc5cIwAHaEK?pid=ImgDet&rs=1',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    ProveedoresTab(),
                    AlertaApi(),
                    ClientesAPi(),
                    TakePhoto(),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

