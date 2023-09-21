import 'dart:convert';


ClienteModel dataModelFromJson(String str) => ClienteModel.fromJson(json.decode(str));

String dataModelToJson(ClienteModel data) => json.encode(data.toJson());

class ClienteModel {
    ClienteModel({
        required this.clients,
        
    });

    List<ClientesValicor> clients;
  

    factory ClienteModel.fromJson(Map<String, dynamic> json) => ClienteModel(
        clients: List<ClientesValicor>.from(json["clientes"].map((x) => ClientesValicor.fromJson(x))),
       
    );

    Map<String, dynamic> toJson() => {
        "clientes": List<dynamic>.from(clients.map((x) => x.toJson())),
        
    };
}

class ClientesValicor {
    ClientesValicor({
        required this.id,
        required this.nombre,
        required this.cedula,
        required this.email,
        required this.telefono,
        required this.estado,
        
    });

    String id;
    String nombre;
    int cedula;
    String email;
    int telefono;
    bool estado;

    factory ClientesValicor.fromJson(Map<String, dynamic> json) => ClientesValicor(
        id: json["_id"],
        nombre: json["nombre"],
        cedula: json["cedula"],
        email: json["email"],
        telefono: json["telefono"],
        estado: json["estado"],
        
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "nombreProd": nombre,
        "cedula": cedula,
        "email": email,
        "telefono": telefono,
        "estado": estado,
        
    };
}
