// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';


List<Kpicanhan> usuarioFromJsonKpicanhan(String str) => List<Kpicanhan>.from(json.decode(str).map((x) => Kpicanhan.fromJson(x)));

String usuarioToJsonCN(List<Kpicanhan> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Kpicanhan {
    String maphieukpicanhan;
    int idbieumau;
    String manv;
    int? quynam;
    DateTime ngaylapphieukpicanhan;
    String? nguoipheduyetkpicanhan;
    DateTime? ngaypheduyetkpicanhan;
    String? tennhanvien;
    int trangthai;
    

    Kpicanhan({
        required this.maphieukpicanhan,
        required this.idbieumau,
        required this.manv,
        this.quynam,
        required this.ngaylapphieukpicanhan,
        this.nguoipheduyetkpicanhan,
        this.ngaypheduyetkpicanhan,
        this.tennhanvien,
        required this.trangthai,
    });

    factory Kpicanhan.fromJson(Map<String, dynamic> json) => Kpicanhan(
        maphieukpicanhan: json["maPhieuKPICN"],
        idbieumau: json["idBieuMau"],
        manv: json["maNV"],
        quynam: json["quyNam"],
        ngaylapphieukpicanhan: DateTime.parse(json["ngayLapPhieuKPICN"]),
        nguoipheduyetkpicanhan: json["nguoiPheDuyetDDKKPI"],  // Trường này có thể null
        ngaypheduyetkpicanhan: json["ngayPheDuyetDDKKPI"] != null 
      ? DateTime.parse(json["ngayPheDuyetDDKKPI"]) 
      : null,  // Xử lý null ở đây
        tennhanvien: json["tenNhanVien"],
        trangthai: json["trangThai"],
    );

  Map<String, dynamic> toJson() => {
  "maPhieuKPICN": maphieukpicanhan,
  "idBieuMau": idbieumau,
  "maNV": manv,
  "quyNam": quynam,  // Sẽ là null nếu không có giá trị
  "ngayLapPhieuKPICN": ngaylapphieukpicanhan.toIso8601String(),
 // if (ngaypheduyet != null) "ngayPheDuyet": ngaypheduyet!.toIso8601String(), // Sẽ gửi null nếu không có giá trị
  "nguoiPheDuyetDDKKPI": nguoipheduyetkpicanhan ?? null,
  "ngayPheDuyetDDKKPI": ngaypheduyetkpicanhan?.toIso8601String(), 
  "trangThai": trangthai,
};

}
