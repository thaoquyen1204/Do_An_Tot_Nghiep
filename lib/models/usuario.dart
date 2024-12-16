// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_login_api/models/kpiphongcntt.dart';

List<Usuario> usuarioFromJson(String str) => List<Usuario>.from(json.decode(str).map((x) => Usuario.fromJson(x)));

String usuarioToJson(List<Usuario> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class KPIGroupByChucVu {
  final int maChucDanh;
  final String tenChucDanh;
  final List<Kpiphongcntt> kpis;

  KPIGroupByChucVu({required this.maChucDanh, required this.tenChucDanh, required this.kpis});

  factory KPIGroupByChucVu.fromJson(Map<String, dynamic> json) {
    var list = json['KPIs'] as List;
    List<Kpiphongcntt> kpiList = list.map((i) => Kpiphongcntt.fromJson(i)).toList();

    return KPIGroupByChucVu(
      maChucDanh: json['ChucVu'],
      tenChucDanh: json['tenChucDanh'] ?? '',  // Nếu cần tên chức danh
      kpis: kpiList,
    );
  }
}
class Usuario {
    String maNv;
    String tenNv;
    String hinhAnhNv;
    String sdt;
    String gmail;
    String tenTaiKhoan;
    String matKhau;
    String maPhongKhoa;
    String maChucDanh;
    String? maQuyen;
    // int? maCapDoKpiBenhVien;
    bool? quyenTruyCap;
   String? maChucNang;
   String? tenChucDanh;
   String? tenQuyen;

    Usuario({
        required this.maNv,
        required this.tenNv,
        required this.hinhAnhNv,
        required this.sdt,
        required this.gmail,
        required this.tenTaiKhoan,
        required this.matKhau,
        required this.maPhongKhoa,
        required this.maChucDanh,
        required this.maQuyen,
        // required this.maCapDoKpiBenhVien,
       this.quyenTruyCap,
       this.maChucNang,
        this.tenChucDanh,
        this.tenQuyen,
    });

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        maNv: json["maNV"],
        tenNv: json["tenNV"],
        hinhAnhNv: json["hinhAnhNV"],
        sdt: json["sdt"],
        gmail: json["gmail"],
        tenTaiKhoan: json["tenTaiKhoan"],
        matKhau: json["matKhau"],
        maPhongKhoa: json["maPhongKhoa"],
        maChucDanh: json["maChucDanh"],
        maQuyen: json["maQuyen"],
        // maCapDoKpiBenhVien: json["maCapDoKPIBenhVien"],
        quyenTruyCap: json["quyenTruyCap"],
        maChucNang: json["maChucNang"],
       tenChucDanh: json["tenChucDanh"],
       tenQuyen: json["tenQuyen"],
    );

    Map<String, dynamic> toJson() => {
        "maNV": maNv,
        "tenNV": tenNv,
        "hinhAnhNV": hinhAnhNv,
        "sdt": sdt,
        "gmail": gmail,
        "tenTaiKhoan": tenTaiKhoan,
        "matKhau": matKhau,
        "maPhongKhoa": maPhongKhoa,
        "maChucDanh": maChucDanh,
        "maQuyen": maQuyen,
        // "maCapDoKPIBenhVien": maCapDoKpiBenhVien,
        "quyenTruyCap": quyenTruyCap,
        "maChucNang": maChucNang,
       "tenChucDanh":tenChucDanh,
       "tenQuyen":tenQuyen,
    };
    
}
