// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

List<Usuario1> usuarioFromJson1(String str) => List<Usuario1>.from(json.decode(str).map((x) => Usuario1.fromJson(x)));

String usuarioToJson(List<Usuario1> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Usuario1 {
    int makpi;
    String noidung;
    String? donvitinh;
    String? phuongphapdo;
    bool? congvieccanhan;
    String? chitieu;
    String? tieuchiid;
    
    
    Usuario1({
        required this.makpi,
        required this.noidung,
        required this.donvitinh,
        required this.phuongphapdo,
        required this.congvieccanhan,
        required this.chitieu,
        required this.tieuchiid,
     
    });

    factory Usuario1.fromJson(Map<String, dynamic> json) => Usuario1(
        makpi: json["maKPI"],
        noidung: json["noiDung"],
        donvitinh: json["donViTinh"],
        phuongphapdo: json["phuongPhapDo"],
        congvieccanhan: json["congViecCaNhan"],
        chitieu: json["chiTieu"],
        tieuchiid: json["tieuChiID"],
       
    );

    Map<String, dynamic> toJson() => {
        "maKPI": makpi,
        "noiDung": noidung,
        "donViTinh": donvitinh,
        "phuongPhapDo": phuongphapdo,
        "congViecCaNhan": congvieccanhan,
        "chiTieu": chitieu,
        "tieuChiID": tieuchiid,
        
    };

}
