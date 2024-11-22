// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

List<Kpiphongcntt> usuarioFromJson2(String str) => List<Kpiphongcntt>.from(json.decode(str).map((x) => Kpiphongcntt.fromJson(x)));

String usuarioToJson(List<Kpiphongcntt> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Kpiphongcntt {
    int makpi;
    String noidung;
    String? donvitinh;
    String? phuongphapdo;
    bool? congvieccanhan;
    String? chitieu;
    String? tieuchiid;
    String mapk;
    
    Kpiphongcntt({
        required this.makpi,
        required this.noidung,
        required this.donvitinh,
        required this.phuongphapdo,
        required this.congvieccanhan,
        required this.chitieu,
        required this.tieuchiid,
       required this.mapk,
    });

    factory Kpiphongcntt.fromJson(Map<String, dynamic> json) => Kpiphongcntt(
        makpi: json["maKPI"],
        noidung: json["noiDung"],
        donvitinh: json["donViTinh"],
        phuongphapdo: json["phuongPhapDo"],
        congvieccanhan: json["congViecCaNhan"],
        chitieu: json["chiTieu"],
        tieuchiid: json["tieuChiID"],
        mapk: json["maPK"],
    );

    Map<String, dynamic> toJson() => {
        "maKPI": makpi,
        "noiDung": noidung,
        "donViTinh": donvitinh,
        "phuongPhapDo": phuongphapdo,
        "congViecCaNhan": congvieccanhan,
        "chiTieu": chitieu,
        "tieuChiID": tieuchiid,
         "maPK": mapk,
    };
@override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Kpiphongcntt && other.makpi == makpi;
  }

  // Override `hashCode` để kết hợp với `==`
  @override
  int get hashCode => makpi.hashCode;
}
