// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';


List<Kpikhoaphong> usuarioFromJsonKpikhoaphong(String str) => List<Kpikhoaphong>.from(json.decode(str).map((x) => Kpikhoaphong.fromJson(x)));

String usuarioToJsonKP(List<Kpikhoaphong> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Kpikhoaphong {
    String maphieukpikhoaphong;
    int idbieumau;
    String manv;
    int? quynam;
    DateTime ngaylapphieukpikhoaphong;
    String? nguoipheduyetkpikhoaphong;
    DateTime? ngaypheduyetkpikhoaphong;
    String? tennhanvien;
    int trangthai;
    String? machucdanh;
    

    Kpikhoaphong({
        required this.maphieukpikhoaphong,
        required this.idbieumau,
        required this.manv,
        this.quynam,
        required this.ngaylapphieukpikhoaphong,
        this.nguoipheduyetkpikhoaphong,
        this.ngaypheduyetkpikhoaphong,
        this.tennhanvien,
        required this.trangthai,
        this.machucdanh,
    });

    factory Kpikhoaphong.fromJson(Map<String, dynamic> json) => Kpikhoaphong(
        maphieukpikhoaphong: json["maPhieuKPIKP"],
        idbieumau: json["idBieuMau"],
        manv: json["maNV"],
        quynam: json["quyNam"],
        ngaylapphieukpikhoaphong: DateTime.parse(json["ngayLapPhieuKPIKP"]),
        nguoipheduyetkpikhoaphong: json["nguoiPheDuyetKPIKP"],  // Trường này có thể null
        ngaypheduyetkpikhoaphong: json["ngayPheDuyetKPIKP"] != null 
      ? DateTime.parse(json["ngayPheDuyetKPIKP"]) 
      : null,  // Xử lý null ở đây
        tennhanvien: json["tenNhanVien"],
        trangthai: json["trangThai"],
        machucdanh: json["maChucDanh"],
    );

  Map<String, dynamic> toJson() => {
  "maPhieuKPIKP": maphieukpikhoaphong,
  "idBieuMau": idbieumau,
  "maNV": manv,
  "quyNam": quynam,  // Sẽ là null nếu không có giá trị
  "ngayLapPhieuKPIKP": ngaylapphieukpikhoaphong.toIso8601String(),
 // if (ngaypheduyet != null) "ngayPheDuyet": ngaypheduyet!.toIso8601String(), // Sẽ gửi null nếu không có giá trị
  "nguoiPheDuyetKPIKP": nguoipheduyetkpikhoaphong ?? null,
  "ngayPheDuyetKPIKP": ngaypheduyetkpikhoaphong?.toIso8601String(), 
  "trangThai": trangthai,
   "maChucDanh": machucdanh,
};

}
