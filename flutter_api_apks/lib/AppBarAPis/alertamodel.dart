
import 'dart:convert';


AlertaModel dataModelFromJson(String str) => AlertaModel.fromJson(json.decode(str));

String dataModelToJson(AlertaModel data) => json.encode(data.toJson());

class AlertaModel {
    AlertaModel({
        required this.alerts,
        
    });

    List<AlertasValicor> alerts;
   

    factory AlertaModel.fromJson(Map<String, dynamic> json) => AlertaModel(
        alerts: List<AlertasValicor>.from(json["alertas"].map((x) => AlertasValicor.fromJson(x))),
       
    );

    Map<String, dynamic> toJson() => {
        "alertas": List<dynamic>.from(alerts.map((x) => x.toJson())),
        
    };
}

class AlertasValicor {
    AlertasValicor({
        required this.id,
        required this.enteRegulatorio,
        required this.fechaAlerta,
        required this.mensajeAlerta, required ,
        
        
    });

    String id;
    String enteRegulatorio;
    String fechaAlerta;
    String mensajeAlerta;
    
    
    factory AlertasValicor.fromJson(Map<String, dynamic> json) => AlertasValicor(
        id: json["_id"],
        enteRegulatorio: json["enteRegulatorio"],
        fechaAlerta: json["fechaAlerta"],
        mensajeAlerta: json["mensajeAlerta"],
        
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "enteRegulatorio": enteRegulatorio,
        "fechaAlerta": fechaAlerta,
        "mensajeAlerta": mensajeAlerta,
        
        
    };
}

  

