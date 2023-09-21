import 'package:flutter/material.dart';
import 'package:flutter_api_apks/AppBarAPis/iconoInicio.dart';
import 'package:flutter_api_apks/theme/appTheme.dart';


void main(){
  runApp(const MainApp() );
}

class MainApp extends StatelessWidget{
  const MainApp ({super.key});

 @override
 Widget build(BuildContext context){ 
  return MaterialApp(

    debugShowCheckedModeBanner: false,
    home:   const InicioIcono(),
    theme: AppTheme.lightTheme,


  );
 }
}