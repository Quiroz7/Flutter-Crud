import 'dart:convert';

DataModelUsuario dataModelFromJson(String str) => DataModelUsuario.fromJson(json.decode(str));

String dataModelToJson(DataModelUsuario data) => json.encode(data.toJson());



class DataModelUsuario {
  DataModelUsuario({
    required this.usuarios
  });
  
  List<Usuario> usuarios;

  factory DataModelUsuario.fromJson(Map<String, dynamic> json)=> DataModelUsuario(
    usuarios: List<Usuario>.from(json["users"].map((x)=> Usuario.fromJson(x)))
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(usuarios.map((x)=> x.toJson()))
  };
}

class Usuario {
  final String id;
  String name;
  String tel;
  String email;
  String password;
  String rol;

  Usuario({
    required this.id,
    required this.name,
    required this.tel,
    required this.email,
    required this.password,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["_id"],
        name: json["name"],
        tel: json["tel"],
        email: json["email"],
        password: json["password"],
        rol: json["rol"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "tel": tel,
        "email": email,
        "password": password,
        "rol": rol,
      };
}