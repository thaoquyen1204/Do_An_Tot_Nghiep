// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_login_api/models/kpiphongcntt.dart';

List<ThongBao> usuarioFromJsonThongbao(String str) => List<ThongBao>.from(json.decode(str).map((x) => ThongBao.fromJson(x)));

String usuarioToJson(List<ThongBao> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ThongBao {
    int? maThongBao;
    String maNhanVien;
    String tieuDe;
    String noiDung;
    DateTime thoiGian;
    bool trangThai;
    String? maPhieu;
   

    ThongBao({
         this.maThongBao,
        required this.maNhanVien,
        required this.tieuDe,
        required this.noiDung,
        required this.thoiGian,
        required this.trangThai,
        this.maPhieu,
    });

    factory ThongBao.fromJson(Map<String, dynamic> json) => ThongBao(
        maThongBao: json["maThongBao"],
        maNhanVien: json["maNhanVien"],
        tieuDe: json["tieuDe"],
        noiDung: json["noiDung"],
        thoiGian:  DateTime.parse(json["thoiGian"]),
        trangThai: json["trangThai"],
        maPhieu: json["maPhieu"],
                
       
    );

    Map<String, dynamic> toJson() => {
       // "maThongBao": maThongBao,
        "maNhanVien": maNhanVien,
        "tieuDe": tieuDe,
        "noiDung": noiDung,
        "thoiGian": thoiGian.toIso8601String(),
        "trangThai": trangThai,
         "maPhieu": maPhieu,
    };
    
}
