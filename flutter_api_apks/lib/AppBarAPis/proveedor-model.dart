
import 'dart:convert';


ProveedorModel dataModelFromJson(String str) => ProveedorModel.fromJson(json.decode(str));

String dataModelToJson(ProveedorModel data) => json.encode(data.toJson());

class ProveedorModel {
    ProveedorModel({
        required this.proveedors,
       
    });

    List<ProveedoresVali> proveedors;
    

    factory ProveedorModel.fromJson(Map<String, dynamic> json) => ProveedorModel(
        proveedors: List<ProveedoresVali>.from(json["proveedores"].map((x) => ProveedoresVali.fromJson(x))),
        
    );

    Map<String, dynamic> toJson() => {
        "proveedores": List<dynamic>.from(proveedors.map((x) => x.toJson())),
        
    };
}

class ProveedoresVali {
    ProveedoresVali({
        required this.id,
        required this.nombreProveedor,
        required this.nit,
        required this.emailProv,
        required this.telefonoProv,
        required this.categoriaProv,
        required this.estadoProv,
        
    });

    String id;
    String nombreProveedor;
    int nit;
    String emailProv;
    int telefonoProv;
    String categoriaProv;
    bool estadoProv;
    
    factory ProveedoresVali.fromJson(Map<String, dynamic> json) => ProveedoresVali(
        id: json["_id"],
        nombreProveedor: json["nombreProveedor"],
        nit: json["nit"],
        emailProv: json["emailProv"],
        telefonoProv: json["telefonoProv"],
        categoriaProv: json["categoriaProv"],
        estadoProv: json["estadoProv"],
        
    );


    Map<String, dynamic> toJson() => {
        "_id": id,
        "nombreProveedor": nombreProveedor,
        "nit": nit,
        "emailProv": emailProv,
        "telefonoProv": telefonoProv,
        "categoriaProv": categoriaProv,
        "estadoProv": estadoProv,
        
    };

  
}

  

