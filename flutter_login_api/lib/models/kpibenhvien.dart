// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';


List<Kpibenhvien> usuarioFromJsonKpibenhvien(String str) => List<Kpibenhvien>.from(json.decode(str).map((x) => Kpibenhvien.fromJson(x)));

String usuarioToJson(List<Kpibenhvien> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Kpibenhvien {
    String maphieukpibenhvien;
    int namphieu;
    String nguoilap;
    String? nguoipheduyet;
    DateTime ngaylapphieukpibv;
    DateTime? ngaypheduyet;
    int idbieumau;
    int trangthai;
    String? tenbieumau;

    Kpibenhvien({
        required this.maphieukpibenhvien,
        required this.namphieu,
        required this.nguoilap,
        this.nguoipheduyet,
        required this.ngaylapphieukpibv,
        this.ngaypheduyet,
        required this.idbieumau,
        required this.trangthai,
        this.tenbieumau,
    });

    factory Kpibenhvien.fromJson(Map<String, dynamic> json) => Kpibenhvien(
        maphieukpibenhvien: json["maPhieuKPIBV"],
        namphieu: json["namPhieu"],
        nguoilap: json["nguoiLap"],
        nguoipheduyet: json["nguoiPheDuyet"],
        ngaylapphieukpibv: DateTime.parse(json["ngayLapPhieuKPIBV"]),
        ngaypheduyet: json["ngayPheDuyet"] != null ? DateTime.parse(json["ngayPheDuyet"]) : null,
        idbieumau: json["idBieuMau"],
        trangthai: json["trangThai"],
        tenbieumau: json["tenBieuMau"],
    );

  Map<String, dynamic> toJson() => {
  "maPhieuKPIBV": maphieukpibenhvien,
  "namPhieu": namphieu,
  "nguoiLap": nguoilap,
  "nguoiPheDuyet": nguoipheduyet,  // Sẽ là null nếu không có giá trị
  "ngayLapPhieuKPIBV": ngaylapphieukpibv.toIso8601String(),
  "ngayPheDuyet": ngaypheduyet?.toIso8601String(), 
 // if (ngaypheduyet != null) "ngayPheDuyet": ngaypheduyet!.toIso8601String(), // Sẽ gửi null nếu không có giá trị
  "idBieuMau": idbieumau,
  "trangThai": trangthai,
};

}
