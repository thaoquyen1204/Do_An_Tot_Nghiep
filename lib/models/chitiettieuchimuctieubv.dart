// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';


List<ChiTietTieuChiMucTieuBV> usuarioFromJsonChiTietTieuChiMucTieuBV(String str) => List<ChiTietTieuChiMucTieuBV>.from(json.decode(str).map((x) => ChiTietTieuChiMucTieuBV.fromJson(x)));

String usuarioToJson(List<ChiTietTieuChiMucTieuBV> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class ChiTietTieuChiMucTieuBV {
    int makpi;
    String noidungkpi;
    String kehoach;
    double trongsokpibv;
    String maphieukpibenhvien;
    String? tieuchiid;
    String? phuongphapdo;
    bool congvieccanhanbv;

    ChiTietTieuChiMucTieuBV({
        required this.makpi,
        required this.noidungkpi,
        required this.kehoach,
        required this.trongsokpibv,
        required this.maphieukpibenhvien,
        this.tieuchiid,
        this.phuongphapdo,
        required this.congvieccanhanbv,
    });

   factory ChiTietTieuChiMucTieuBV.fromJson(Map<String, dynamic> json) => ChiTietTieuChiMucTieuBV(
        makpi: json["maKPI"],
        noidungkpi: json["noiDungKPI"],
        kehoach: json["keHoach"],
        trongsokpibv: (json["trongSoKPIBV"] ?? 0.0).toDouble(),  // Xử lý null cho double
        maphieukpibenhvien: json["maPhieuKPIBV"],
        tieuchiid: json["tieuChiID"] ?? "",  // Nếu null, gán giá trị mặc định
        phuongphapdo: json["phuongPhapDo"] ?? "",  // Nếu null, gán giá trị mặc định
        congvieccanhanbv: json["congViecCaNhanBV"] ?? false,  // Nếu null, gán false
      );

  Map<String, dynamic> toJson() => {
  "maKPI": makpi,
  "noiDungKPI": noidungkpi,
  "keHoach": kehoach,
  "trongSoKPIBV": trongsokpibv,  
  "maPhieuKPIBV": maphieukpibenhvien,
  "tieuChiID": tieuchiid, 
  "phuongPhapDo":phuongphapdo,
  "congViecCaNhanBV": congvieccanhanbv,
};

}
