import 'package:flutter/material.dart';
import 'package:flutter_api_apks/AppBarAPis/loginUsu.dart';



class InicioIcono extends StatelessWidget {
  const InicioIcono({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>  const LogIn(),
                ),
              );
            },
            child: const Icon(Icons.wordpress, size: 50.0, ) ,
          ),
          
          
        ],
      ),
    );
  }
}
