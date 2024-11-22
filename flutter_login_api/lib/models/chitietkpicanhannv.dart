// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';


List<ChiTietKPICaNhanNV> usuarioFromJsonChiTietKpiCaNhan(String str) => List<ChiTietKPICaNhanNV>.from(json.decode(str).map((x) => ChiTietKPICaNhanNV.fromJson(x)));

String usuarioToJson(List<ChiTietKPICaNhanNV> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class ChiTietKPICaNhanNV {
    int? stt;
    String maphieukpicanhan;
    int makpi;
    String noidungkpicanhan;
    String? nguonchungminh;
    String? tieuchidanhgiaketqua;
    String? kehoach;
    double trongsokpicanhan;
    String? thuchien;
    double? tylehoanthanh;
    bool? ketqua;
    String? manhanvien;
    String? tennhanvien;

    ChiTietKPICaNhanNV({
        this.stt,
        required this.maphieukpicanhan,
        required this.makpi,
        required this.noidungkpicanhan,
        this.nguonchungminh,
        required this.tieuchidanhgiaketqua,
        required this.kehoach,
        required this.trongsokpicanhan,
        required this.thuchien,
        this.tylehoanthanh,
        this.ketqua,
 
    });

    factory ChiTietKPICaNhanNV.fromJson(Map<String, dynamic> json) => ChiTietKPICaNhanNV(
        stt: json["sott"],
        maphieukpicanhan: json["maPhieuKPICN"],
        makpi: json["maKPI"],
        noidungkpicanhan: json["noiDungKPICN"],
        nguonchungminh: json["nguonChungMinh"],
        tieuchidanhgiaketqua: json["tieuChiDanhGiaKQ"],
        kehoach: json["keHoach"] ,
        trongsokpicanhan: json["trongSoKPICN"],
        thuchien: json["thucHien"],
        tylehoanthanh: json["tyLeHoanThanh"],
        ketqua: json["ketQua"],

    );

  Map<String, dynamic> toJson() => {
    'stt':stt,
  "maPhieuKPICN": maphieukpicanhan,
  "maKPI": makpi,
  "noiDungKPICN": noidungkpicanhan,
  "nguonChungMinh": nguonchungminh,  
  "tieuChiDanhGiaKQ": tieuchidanhgiaketqua,
  "keHoach": kehoach, 
  "trongSoKPICN": trongsokpicanhan,
  "thucHien": thuchien,
  "tyLeHoanThanh": tylehoanthanh, 
  "ketQua": ketqua,

  
};

}
