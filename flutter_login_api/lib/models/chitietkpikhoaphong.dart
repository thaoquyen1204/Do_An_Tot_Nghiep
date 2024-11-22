// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';


List<ChitietKpiKP> usuarioFromJsonchitietKpikhoaphong(String str) => List<ChitietKpiKP>.from(json.decode(str).map((x) => ChitietKpiKP.fromJson(x)));

String usuarioToJsonKP(List<ChitietKpiKP> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChitietKpiKP {
    String maphieukpikhoaphong;
    int makpi;
    String noidungkpikhoaphong;
    String? nguonchungminh;
    String? tieuchidanhgiaketqua;
    String? kehoach;
    double trongsokpikhoaphong;

    ChitietKpiKP({
        required this.maphieukpikhoaphong,
        required this.makpi,
        required this.noidungkpikhoaphong,
        this.nguonchungminh,
        required this.tieuchidanhgiaketqua,
        required this.kehoach,
        required this.trongsokpikhoaphong,
    });

    factory ChitietKpiKP.fromJson(Map<String, dynamic> json) => ChitietKpiKP(
        maphieukpikhoaphong: json["maPhieuKPIKP"],
        makpi: json["maKPI"],
        noidungkpikhoaphong: json["noiDungKPIKP"],
        nguonchungminh: json["nguonChungMinh"],
        tieuchidanhgiaketqua: json["tieuChiDanhGiaKQ"],
        kehoach: json["keHoach"] ,
        trongsokpikhoaphong: json["trongSoKPIKP"],
    );

  Map<String, dynamic> toJson() => {
  "maPhieuKPIKP": maphieukpikhoaphong,
  "maKPI": makpi,
  "noiDungKPIKP": noidungkpikhoaphong,
  "nguonChungMinh": nguonchungminh,  
  "tieuChiDanhGiaKQ": tieuchidanhgiaketqua,
  "keHoach": kehoach, 
  "trongSoKPIKP": trongsokpikhoaphong,
};
}
