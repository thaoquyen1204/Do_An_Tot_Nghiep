// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

List<ChucDanh> usuarioFromJson3(String str) => List<ChucDanh>.from(json.decode(str).map((x) => ChucDanh.fromJson(x)));

String usuarioToJson(List<ChucDanh> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChucDanh {
    String maChucDanh;
    String tenChucDanh;
    int? maCapDoChucDanh;
    String maPK;


    ChucDanh({
        required this.maChucDanh,
        required this.tenChucDanh,
        required this.maCapDoChucDanh,
        required this.maPK,
       
    });

    factory ChucDanh.fromJson(Map<String, dynamic> json) => ChucDanh(
        maChucDanh: json["maChucDanh"],
        tenChucDanh: json["tenChucDanh"],
        maCapDoChucDanh: json["maCapDoChucDanh"],
        maPK: json["maPK"],
       
    );

    Map<String, dynamic> toJson() => {
        "maChucDanh": maChucDanh,
        "tenChucDanh": tenChucDanh,
        "maCapDoChucDanh": maCapDoChucDanh,
        "maPK": maPK,
        
    };
     // Ghi đè phương thức so sánh và hashCode để loại bỏ trùng lặp
    @override
    bool operator ==(Object other) {
      if (identical(this, other)) return true;

      return other is ChucDanh && other.maChucDanh == maChucDanh;
    }

    @override
    int get hashCode => maChucDanh.hashCode;
}
